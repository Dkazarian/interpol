require "java"

class Input
  
  
  module Swing
    include_package "javax.swing"
  end

  
  def initialize
    
  end
  
  def start
    frame = Swing::JFrame.new()
    label = Swing::JLabel.new("hi there")
    frame.getContentPane().add(label)
    frame.setDefaultCloseOperation(Swing::JFrame::EXIT_ON_CLOSE)
    frame.pack()
    frame.set_visible(true)
  end
  
end