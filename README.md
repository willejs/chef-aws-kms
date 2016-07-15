# aws-kms cookbook

## Description

This library cookbook gives you a simple workflow for encrypting secrets with AWS kms and then using chef to decrypt and store them on an instance.

The cookbook includes a thorfile to encrypt your secrets into .crypt files, and a chef LWRP to decrypt all .crypt files in a folder.

Additionally the readme is going to advise you which IAM roles you should assign an instance to run this without keys.

## Usage

There is an example fixture cookbook in `fixtures/cookbooks/default` it will show you how to use it as below.

```
aws_kms 'default' do
  crypt_folder = '/etc/chef/crypt'
  decrypt_folder = '/etc/chef/private'
end
```

### Properties

- `crypt_folder` - Where your collection of .crypt folders are stored, this could be in a cookbook, or baked into your ec2 image, or dropped on the box someother way
- `decrypt_folder` - The location to decrypt the files to 

## Tests

`chef exec rake test`
`chef exec kitchen test`

## Thorfile

This is going to encrypt your files for you and append a .crypt extension to the resulting files, its then upto you to put them somewhere (your cookbook, your instance etc.)
not yet implimented

# Requirements

The chefdk
