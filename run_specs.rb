unless Kernel.respond_to?(:require_relative)
  module Kernel
    def require_relative(path)
      require File.join(File.dirname(caller[0]), path.to_str)
    end
  end
end

require 'rspec' #gem install 'rspec'

specs = []
Dir.foreach("spec") {|file| specs << "spec/" + file unless ((file == ".") || (file == ".."))}
RSpec::Core::Runner.run(specs) 
