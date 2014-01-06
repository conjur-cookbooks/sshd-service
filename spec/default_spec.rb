require 'chefspec'

describe "sshd-service::default" do
  let(:log_level) { :info }
  let(:attributes) { {} }
  let(:chef_run) { 
    ChefSpec::Runner.new(cookbook_path: ['..'], log_level: log_level) do |node|
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
  end
end
