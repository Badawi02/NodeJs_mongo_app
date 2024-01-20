pipeline {
    agent any
    environment {
        USER_ID  = credentials('AWS_USER_ID')
    }
    stages {
        stage('Test') {
            steps {
                script {
                    sh """
                    cd app
                    npm install
                    npm run test
                    """
                }
            }
        }

        stage('Build') {
            steps {
                script{
                    withCredentials([string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'ACCESS_KEY'), string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'SECRET_KEY')]){
                        sh """AWS_ACCESS_KEY_ID=${ACCESS_KEY} AWS_SECRET_ACCESS_KEY=${SECRET_KEY} aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${USER_ID}.dkr.ecr.us-east-1.amazonaws.com """
                        sh """ docker build -t node-js_app:${BUILD_NUMBER} app/. """
                        sh """ docker tag node-js_app:${BUILD_NUMBER} ${USER_ID}.dkr.ecr.us-east-1.amazonaws.com/node-js_app:${BUILD_NUMBER} """
                        sh """ docker push ${USER_ID}.dkr.ecr.us-east-1.amazonaws.com/node-js_app:${BUILD_NUMBER} """
                        sh """ echo ${BUILD_NUMBER} > ../node-js_app-build-number.txt """
                        sh """ echo ${USER_ID} > ../node-js_app-user-id.txt """
                    }
                }
            }
        }
        

        stage("Store Scan image Results") {
            steps {
                script {
                    withCredentials([string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'ACCESS_KEY'), string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'SECRET_KEY')]){
                        def imageUri = "node-js_app"
                        sh """ AWS_ACCESS_KEY_ID=${ACCESS_KEY} AWS_SECRET_ACCESS_KEY=${SECRET_KEY} aws ecr describe-image-scan-findings --repository-name '${imageUri}' --image-id imageTag='${BUILD_NUMBER}' --region us-east-1 > all_findings_${BUILD_NUMBER}.json  """ 
                    }
                }
            }
        }

        stage("Show the Critical Vulnerabilities ") {
            steps {
                script {
                    sh """ cat all_findings_${BUILD_NUMBER}.json | jq -r '.imageScanFindings.findingSeverityCounts.CRITICAL as $critical | .imageScanFindings.findings[] | select(.severity == "CRITICAL") | "($critical) CRITICAL: (.name) - (.description)"'  """
                }
            }
        }
        
        stage('deploy') {
            steps {
                script{
                    withCredentials([string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'ACCESS_KEY'), string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'SECRET_KEY')]){
                        sh """ AWS_ACCESS_KEY_ID=${ACCESS_KEY} AWS_SECRET_ACCESS_KEY=${SECRET_KEY} aws eks --region us-east-1 update-kubeconfig --name cluster """
                        sh """ export BUILD_NUMBER=\$(cat ../node-js_app-build-number.txt) """
                        sh """ export USER_ID=\$(cat ../node-js_app-user-id.txt) """
                        sh """ mv kubernetes/nodejs-app/node-app-deployment.yaml kubernetes/nodejs-app/node-app-deployment.yaml.tmp """
                        sh """ cat kubernetes/nodejs-app/node-app-deployment.yaml.tmp | envsubst > kubernetes/nodejs-app/node-app-deployment.yaml """
                        sh """ rm -f kubernetes/nodejs-app/node-app-deployment.yaml.tmp """
                        sh """ AWS_ACCESS_KEY_ID=${ACCESS_KEY} AWS_SECRET_ACCESS_KEY=${SECRET_KEY} kubectl apply -f kubernetes/NameSpaces """
                        sh """ AWS_ACCESS_KEY_ID=${ACCESS_KEY} AWS_SECRET_ACCESS_KEY=${SECRET_KEY} kubectl apply -f kubernetes/nodejs-app """
                        sh """ AWS_ACCESS_KEY_ID=${ACCESS_KEY} AWS_SECRET_ACCESS_KEY=${SECRET_KEY} kubectl apply -f kubernetes/mongo-DB """
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline Successed!.'
        }
    }
}
