module AwsKmsCookbook
  # helper methods for custom resource
  module AwsKmsHelpers
    def init_aws_client(aws_region, access_key_id, secret_access_key, aws_security_token)
      # support session tokens
      if ENV['AWS_SECURITY_TOKEN'] || aws_security_token
        Chef::Log.info('using sec token')
        credentials = Aws::Credentials.new(
          ENV['AWS_ACCESS_KEY_ID'] || access_key_id,
          ENV['AWS_SECRET_ACCESS_KEY'] || secret_access_key,
          ENV['AWS_SECURITY_TOKEN'] || aws_security_token
        )
        # TODO: handle exceptions here.
        kms = Aws::KMS::Client.new(region: aws_region, credentials: credentials)
      else
        Chef::Log.info('not using sec token')
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
