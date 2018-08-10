module AwsKmsCookbook
  # Create a class and define the aws_kms resource in this library
  class AwsKms < Chef::Resource
    require_relative 'helpers'
    include AwsKmsCookbook::AwsKmsHelpers

    resource_name :aws_kms

    default_action :decrypt

    property :crypt_folder, String, default: '/etc/chef/crypt'
    property :manage_crypt_folder, [TrueClass, FalseClass], default: true
    property :decrypt_folder, String, default: '/etc/chef/private'
    property :manage_decrypt_folder, [TrueClass, FalseClass], default: true
    property :aws_region, String, default: 'us-east-1'
    # PLEASE PLEASE PLEASE dont use this, its a terrible idea and is just for testing.
    # Use IAM roles!
    property :aws_access_key_id, [String, nil], default: nil
    property :aws_secret_access_key, [String, nil], default: nil
    property :aws_security_token, [String, nil], default: nil

    action :decrypt do
      Chef::Log.info('installing the aws gem')

      chef_gem 'aws-sdk' do
        compile_time true
        action :install
      end

      require 'aws-sdk'

      directory new_resource.decrypt_folder do
        owner 'root'
        group 'root'
        mode '0700'
        action :create
        recursive true
        only_if { new_resource.manage_decrypt_folder == true }
      end

      directory new_resource.crypt_folder do
        owner 'root'
        group 'root'
        mode '0700'
        action :create
        recursive true
        only_if { new_resource.manage_crypt_folder == true }
      end

      log 'setting up the aws client'
      kms = init_aws_client(
        new_resource.aws_region,
        new_resource.aws_access_key_id,
        new_resource.aws_secret_access_key,
        new_resource.aws_security_token
      )

      log 'decrypting files'
      Dir.glob("#{new_resource.decrypt_folder}/*.crypt").each do |file|
        log "processing encrypted file: #{file}"
        decrypted_file = decrypt_file(file, kms)
        log 'writing out decrypted data'
        output_file = "#{new_resource.decrypt_folder}/#{file.split('/')[-1].chomp('.crypt')}"

        file output_file do
          action :create
          owner 'root'
          group 'root'
          mode '0600'
          content decrypted_file
        end
      end
    end
  end
end
