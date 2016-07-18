# aws-kms cookbook

## Description

This library cookbook gives you a simple workflow for encrypting secrets with AWS kms and then using chef to decrypt and store them on an instance.

The cookbook includes a thorfile to encrypt your secrets into .crypt files, and a chef LWRP to decrypt all .crypt files in a folder.

Additionally the readme is going to advise you which IAM roles you should assign an instance to run this without keys.

# The idea

Managing secrets is hard. Chef encrypted data bags are not ideal, and are reasonably hard to manage. Chef vault has overheads... So this is where KMS steps in.

KMS enables you to create a private key in amazon, and control access to it. You can then call the API to encrypt and decrypt data, if you have access privileges to that key.

Therefore, you can:
  - Encrypt all your data into files using a key
  - Bake the files into your amazon AMIs (or drop them off) and make sure they are owned by root...
  - Boot instances with an IAM role that can access a specific key to decrypt the files
  - Run chef to read all the files, decrypt them, and put them in a safe place on disk.

This means two things:
  - You must be on a machine with an IAM role to access the key
  - You must have root access to access the encrypted files

Effectively, you have to compromise the box and get root to get the encrypted secrets, which if that has happened, it's probably already game over.

## Usage

There is an example fixture cookbook in `fixtures/cookbooks/default` it will show you how to use it as below.

```
aws_kms 'default' do
  crypt_folder = '/etc/chef/crypt'
  decrypt_folder = '/etc/chef/private'
end
```

### Properties

- `crypt_folder` - Where your collection of .crypt folders are stored, this could be in a cookbook, or baked into your ec2 image, or dropped on the box some other way. String.
- `manage_crypt_folder` - Create and ensure permissions on folder. Boolean
- `decrypt_folder` - The location to decrypt the files to. String
- `manage_decrypt_folder` - Create and ensure permissions on folder. Boolean

## Tests

`chef exec rake test`
`chef exec kitchen test`

## Thorfile

This is going to encrypt your files for you and append a .crypt extension to the resulting files, its then upto you to put them somewhere (your cookbook, your instance etc.)
not yet implemented

# Requirements

The chefdk
