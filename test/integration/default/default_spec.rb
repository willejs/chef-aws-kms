describe file('/tmp/kitchen/cache/private/test_data') do
  its('content') { should match(/some junk data/) }
end
