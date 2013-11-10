require 'rspec'
require_relative '../src/ui/command_line.rb'


describe CommandLine do
  
  before :each do
  	@cmd = CommandLine.new
  end

  # it "should not explode" do    
  #   exec_commands [
  #   	"add 1,1 0,0 2,2", 
  #   	"interpolate!", 
  #   	"rm 0,0",
  #   	"rm 2,2",
  #   	"rm 1,1"
  #   	]
  # end
  

end

def exec_commands command
	if command.respond_to? :each
		command.each {|c| @cmd.exec_command(c)}
	else 
		@cmd.exec_command c
	end
end