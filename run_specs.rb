require 'rspec' #gem install 'rspec'
Dir.foreach("spec") do |file|
  RSpec::Core::Runner.run(["spec/"+file]) unless ((file == ".") || (file == ".."))
end