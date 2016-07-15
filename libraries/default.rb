module AwsKmsCookbook
  # Create a class and define the openvpn_server resource in this library
  class AwsKms < Chef::Resource
    require_relative 'helpers'
    include AwsKmsCookbook::AWSKmsHelpers

    resource_name :aws_kms_decrypt

    default_action :decrypt

    property :crypt_folder, String, default: '/etc/chef/crypt'
    property :decrypt_folder, String, default: '/etc/chef/private'
    property :aws_region, String, default: 'eu-west-1'
    property :aws_access_key_id, String, default: nil
    property :aws_secret_access_key, String, default: nil
    property :aws_security_token, String, default: nil

    action :decrypt do
      Chef::Log.info('installing the aws-sdk gem')

      chef_gem 'aws-sdk' do
        compile_time true
        action :install
      end

      require 'aws-sdk'

      log 'setting up the aws client'
      kms = init_aws_client(
		      	aws_region, 
		      	aws_access_key_id, 
		      	aws_secret_access_key,
		      	aws_security_token
			)

      log 'decrypting files'
      Dir.glob("#{crypt_folder}/*.crypt").each do |file|
        log "processing encrypted file: #{file}"
        decrypted_file = decrypt_file(file, kms)

        log 'writing out decrypted data'
        output_file = "#{decrypt_folder}/#{file.split('/')[-1].chomp('.crypt')}"

        file output_file do
          action :create
          owner 'root'
          group 'root'
          mode '0640'
          content decrypted_file
        end
      end
    end
  end
end
