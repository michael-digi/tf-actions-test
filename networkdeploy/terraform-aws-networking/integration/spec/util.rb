def assert_local_associations
  describe 'the local associations' do
    it { should have_route(TFVARS['vpc_primary_cidr']).target(gateway: 'local') }
    it { should have_route(TFVARS['utility_subnet_cidr']).target(gateway: 'local') }
    it { should have_route(TFVARS['vpc_addl_address_space'][0]).target(gateway: 'local') }
  end
end

def assert_subnet_configuration(type, az)
  it { should exist}
  it { should be_available }
  it { should have_tag('Name').value(type + ' Subnet (' + az +')')}
  its('vpc.id') { should eq ENVVARS[:vpc_id][:value] }
  its(:availability_zone) { should eq az}
  its(:available_ip_address_count) { should eq 251}
  its(:map_public_ip_on_launch) { should eq false}
end

def is_ssh_accessible(sg_name, identity)
  it { should exist }
  it { should have_tag('Name').value(sg_name) }
  its(:inbound) { should be_opened(22).protocol('tcp').for(identity) }
  its(:outbound) { should be_opened }
  its(:vpc_id) { should eq ENVVARS[:vpc_id][:value]}
end