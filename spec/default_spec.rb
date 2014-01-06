require 'chefspec'

describe "sshd-service::default" do
  let(:log_level) { :info }
  let(:attributes) { {} }
  let(:chef_spec_options) { {} }
  let(:chef_run) {
    ChefSpec::Runner.new(chef_spec_options.merge(cookbook_path: ['..'], log_level: log_level)) do |node|
      attributes.each do |k,v|
        node.override[k] = v
      end
    end.converge(described_recipe) 
  }
  
  context "platform" do
    subject { chef_run }
    describe "fedora" do
      let(:attributes) { { 'platform_family' => 'fedora' } }
      %w(openssh-clients openssh).each do |pkg|
        specify { should install_package(pkg) }
      end
      specify { should define_service("sshd") }
    end
    describe "default" do
      %w(openssh-client openssh-server).each do |pkg|
        specify { should install_package(pkg) }
      end
      specify { should define_service("ssh") }
    end
    describe "ubuntu" do
      let(:chef_spec_options) {
        {
          platform: 'ubuntu',
          # fauxhai does not have 13.10 yet
          version: '13.04'
        }
      }
      describe "13.10" do
        it "uses upstart as the service provider" do
          Chef::VersionConstraint.any_instance.should_receive(:include?).and_return true
          
          should define_service('ssh')
          subject.find_resource(:service, "ssh").provider.should == Chef::Provider::Service::Upstart
        end
      end
    end
  end
end
