if defined?(ChefSpec)
  ChefSpec.define_matcher(:aws_kms)

  def decrypt_aws_kms(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:aws_kms, :decrypt, resource_name)
  end
end
