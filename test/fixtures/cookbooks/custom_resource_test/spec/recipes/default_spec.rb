require_relative '../spec_helper'

describe 'custom_resource_test::default' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new do |node, _server|
        node.set['aws-kms']['aws_access_key_id'] = 'test'
        node.set['aws-kms']['aws_secret_access_key'] = 'test'
        node.set['aws-kms']['aws_security_token'] = 'test'
      end
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
