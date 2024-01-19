// test/test.js
import { expect } from 'chai';
import { sayHello } from '../index.js';

describe('sayHello function', () => {
  it('should return "Hello, World!"', () => {
    const result = sayHello();
    expect(result).to.equal('Hello, World!');
    console.log('Tests Finished Successfully')
    process.exit();
  });
});
