# custom_resource_test cookbook

This aims to show you how you can use the cookbook

## Requirements 
aws kms set up (in the IAM console) with a key with the alias: `custom_resource_test`

## How to

you need to create some encrypted data, so run this command
`aws kms encrypt --key-id alias/custom_resource_test --plaintext 'some junk data' --output text --query CiphertextBlob | base64 --decode > ./files/crypt/test_data.crypt`