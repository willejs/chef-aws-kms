module AwsKmsCookbook
  # helper methods for custom resource
  module AWSKmsHelpers
    def require_aws_sdk
      chef_gem 'aws-sdk' do
        version aws_sdk_version
        compile_time true
        action :install
      end

      require 'aws-sdk'
    end

    def init_aws_client(aws_region)
      # support session tokens
      if ENV['AWS_SECURITY_TOKEN']
        credentials = Aws::Credentials.new(
          ENV['AWS_ACCESS_KEY_ID'],
          ENV['AWS_SECRET_ACCESS_KEY'],
          ENV['AWS_SECURITY_TOKEN']
        )
        # TODO: handle exceptions here.
        kms = Aws::KMS::Client.new(region: aws_region, credentials: credentials)
      else
        kms = Aws::KMS::Client.new(region: aws_region)
      end

      kms
    end

    def decrypt_file(file, kms)
      # TODO: handle exceptions here and check xx0 perms on files and that they are <4kb.
      contents = File.read(file)
      # TODO: handle exceptions here.
      kms.decrypt(ciphertext_blob: contents).plaintext
    end
  end
end
