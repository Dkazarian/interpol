require 'rspec' #gem install 'rspec'
specs = []
Dir.foreach("spec") {|file| specs << "spec/" + file unless ((file == ".") || (file == ".."))}
RSpec::Core::Runner.run(specs) 
