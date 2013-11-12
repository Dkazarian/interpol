unless Kernel.respond_to?(:require_relative)
  module Kernel
    def require_relative(path)
      require File.join(File.dirname(caller[0]), path.to_str)
    end
  end
end

require_relative "model/interpolator"
require_relative "model/point"
require_relative "model/polynomial"
require_relative "ui/command_line"
require_relative "gui/overview.rb"

interpolator = Interpolator.new
console = CommandLine.new interpolator
t1= Thread.new do 
	Overview.new(interpolator)
end
5.times { puts("")}
console.start
abort