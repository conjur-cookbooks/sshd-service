require 'chefspec'
require 'chefspec/berkshelf'

describe "sshd-service::default" do
  let(:log_level) { :info }
  let(:attributes) { {} }
  let(:chef_spec_options) { {} }
  let(:chef_run) {
    ChefSpec::SoloRunner.new(chef_spec_options.merge(log_level: log_level)) do |node|
      attributes.each do |k,v|
        node.override[k] = v
      end
    end.converge(described_recipe)
  }

  context "platform" do
    subject { chef_run }

    describe "default" do
      %w(openssh-client openssh-server).each do |pkg|
        specify { should install_package(pkg) }
      end
      specify { should enable_service("ssh") }
      specify { should start_service("ssh") }
    end
  end
end
