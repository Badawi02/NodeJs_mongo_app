## Tools Used
 - AWS
 - Terraform
 - Ansible
 - Docker
 - Kubernates
 - Argo
 - Jenkins
 - Bash script
 - Helm

### Project Details:

 - Terraform scripts that build an environment on AWS content ( An EKS cluster with worker nodes in different availability zones and EC2 to install jenkins in it ) :
     - 1 VPC
     - 2 subnets
     - 1 IGW
     - 1 route table
     - 1 security group
     - 1 EC2
     - 2 worker nodes
     - 1 ECR
 - install jenkins on EC2 using ansible
 - access jenkins from > http://<public_ip for ec2>:8080
 - make ci/cd (dev_pipeline) with jenkins :
     - make unit testing on app
     - build a nodeJs app image and push it to ECR
     - Ensure that the Docker images are scanned for vulnerabilities
     - Deploy the app and mongoDB in Kubernetes 
     - access the application through the deployed on port 31000.
 - make ci/cd (argo_pipeline) with jenkins :
     - deploy argoCD in Kubernetes with Helm
     - apply application for nodeJs and mongoDB on Argo
     - Synced the app and database with gitlab repo


### Getting Started

- Clone The Code

```bash
  git clone https://gitlab.com/kashier1/node.js_app.git
```
- Setup your AWS account credentials

```bash
  aws configure
```
- Change the path and point it to AWS credentials files like this :

![AWS credentials](images/0.png)

-----------------------------------------------------------------------------------------
### Build the Infrastructure

```bash
  cd terraform
```
```bash
  terraform init
```
- Output:

![init](images/1.png)

```bash
  terraform plan
```
```bash
  terraform apply
```
- Output:

![apply](images/2.png)

- Copy the public IP from terrafom 

Now you can check your AWS account, you can see this resources has been created:
- 1 VPC named "vpc-main"
- 2 Subnets
- 1 Internet gateway
- 1 security group 
- 1 routing table
- 1 EC2
- Private Kubernetes cluster (EKS) with 2 worker nodes
- 1 ECR "node-js_app"


## Install Jenkins on EC2 with ansible :

- Run 

```bash
    cd ansible
```
- Put the public ip of EC2 in inventory file

- RUN

```bash
    ansible-playbook -i inventory install_jenkins.yml
```
- Output:

![agent](images/3.png)


- Copy the output from ansible


-----------------------------------------------------------------------------------------

## configure Jenkins :

- You can access jenkins from browser >  http://<public_ip for ec2>:8080

- put the output from ansible in init password like this :

 ![agent](images/4.png)

- install suggested plugins :

 ![agent](images/5.png)

- create account in Jenkins :

 ![agent](images/6.png)

- Now you can enter to jenkins :

 ![agent](images/7.png)

- put your credentials ( you must use the same ID ) like this :

 ![agent](images/8.png)


## Make dev_pipleline : 

- create your pipleline :

- configure your pipleline, put your url of repo and choose your github credentials :

 ![agent](images/11.png)


## You can make webhook :
  - It's not working with me because i use free tier of gitlab , so i can't create access token 
  - but this is the steps :
    - create personal access token on gitlab from setting
    - create webhook on gitlab with url of jenkisn from setting
    - install gitlab plugin on jenkins
    - create credential (Gitlab API token)
    - in configuration pipleline enable "Build when a change is pushed to GitLab" and choose gitlab token

##  Steps of jenkinsfile for dev_pipeline :
- make unit testing on app
- build a nodeJs app image and push it to ECR
- Ensure that the Docker images are scanned for vulnerabilities
- Deploy the app and mongoDB in Kubernetes 


##  Build your pipleline :
 ![agent](images/12.png)


## You can find all images you build it in ECR :

  ![agent](images/14.png)

## That will deploy on EKS in namespace (dev) :

- Enter your AWS credentials

```bash
    aws configure
```

- connect to cluster

```bash
    aws eks --region us-east-1 update-kubeconfig --name cluster
```
- Run 

```bash
    kubectl get all -n dev
```
## Now you can show all resources of cluster

- mongoDB statefulset and Exopse it with ClusterIP service
- PV and PVC as storge for database
- nodeJs App Deployment and Exopse it with NodePort service
- Output:

![agent](images/15.png)

## Make argo_pipleline :

- create your pipleline :

- configure your pipleline, put your url of repo and choose your gitlab credentials :

 ![agent](images/16.png)

## Steps of jenkinsfile for argo_pipeline :

- Creat namespace (argo)
- deploy argoCD on namespace argo on EKS
- get your password and username to can access argoCD from browser
- deploy applications to make Synce between manifests files in GitLab and the deployed on EKS



## Build your pipleline :

 ![agent](images/17.png)


## That will deploy on EKS in namespace (argo) :

```bash
    kubectl get all -n argo
```
```bash
    kubectl get application -n argo
```
- Output:

![agent](images/18.png)

## The app now Synced with argo :

- Output:

![agent](images/19.png)

## Now you can access your app from any worker node  :

- like this : http://<"ip of any worker node">:31000   

- Output:

![agent](images/20.png)
