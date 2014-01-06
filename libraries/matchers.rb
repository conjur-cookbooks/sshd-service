if defined?(ChefSpec)
  def define_service(message)
    ChefSpec::Matchers::ResourceMatcher.new(:service, :nothing, message)
  end
end