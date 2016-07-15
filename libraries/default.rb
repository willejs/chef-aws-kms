module AwsKmsCookbook
  # Create a class and define the openvpn_server resource in this library
  class AwsKms < Chef::Resource
    require_relative 'helpers'

    resource_name :aws_kms_decrypt

    default_action :decrypt

    property :crypt_folder, String, default: '/etc/chef/crypt'
    property :decrypt_folder, String, default: '/etc/chef/private'
    property :aws_region, String, default: 'eu-west-1'

    action :decrypt do
      require_aws_sdk
      kms = init_aws_client(aws_region)

      Dir.glob("#{crypt_folder}/*.crypt").each do |file|
        log "processing encrypted file: #{file}"
        decrypted_file = decrypt_file(file, kms)

        log 'writing out decrypted data'
        output_file = "#{decrypt_folder}/#{file.sub('./', '').chomp('.crypt')}"

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
