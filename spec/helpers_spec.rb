require 'rspec'
require_relative '../libraries/helpers'

describe Class.new { include AwsKmsCookbook::AWSKmsHelpers } do
  subject(:helper) { Class.new { include AwsKmsCookbook::AWSKmsHelpers } }
  
    describe '#aws_require_sdk' do
      subject { described_class.new.aws_require_sdk }
      
      it 'should have required the sdk' do
      	expect(subject).to defined?('aws-sdk')
      end
  end
end