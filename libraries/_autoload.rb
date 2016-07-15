begin
  gem 'aws-sdk', '= 2.3.22'
rescue LoadError
  unless defined?(ChefSpec)
    run_context = Chef::RunContext.new(Chef::Node.new, {}, Chef::EventDispatch::Dispatcher.new)

    require 'chef/resource/chef_gem'

    docker = Chef::Resource::ChefGem.new('aws-sdk', run_context)
    docker.version '= 2.3.22'
    docker.run_action(:install)
  end
end
