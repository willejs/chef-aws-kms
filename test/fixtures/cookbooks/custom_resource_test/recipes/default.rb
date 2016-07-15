directory "#{Chef::Config[:file_cache_path]}/private"

aws_kms_decrypt 'default' do
	crypt_folder "#{Chef::Config[:file_cache_path]}/cookbooks/custom_resource_test/files/crypt"
	decrypt_folder "#{Chef::Config[:file_cache_path]}/private"
	aws_access_key_id node['aws-kms']['aws_access_key_id']
	aws_secret_access_key node['aws-kms']['aws_secret_access_key']
	aws_security_token node['aws-kms']['aws_security_token']
end
