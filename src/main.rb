#require_relative "ui/consoleUI"
require_relative "ui/commandLine"
require_relative "model/interpolator"
require_relative "model/point"


#ConsoleUi.new(Interpolator.new).start

CommandLine.new(Interpolator.new).start