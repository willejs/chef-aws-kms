directory "#{Chef::Config[:file_cache_path]}/private"

aws_kms_decrypt 'default' do
	crypt_folder "#{Chef::Config[:file_cache_path]}/cookbooks/custom_resource_test/files/crypt"
	decrypt_folder "#{Chef::Config[:file_cache_path]}/private"
end
