require "java"

class Input
  
  def initialize
    
  end
  
  def start
    frame = javax.swing.JFrame.new()
    label = javax.swing.JLabel.new("hi there")
    frame.getContentPane().add(label)
    frame.setDefaultCloseOperation(javax.swing.JFrame::EXIT_ON_CLOSE)
    frame.pack()
    frame.set_visible(true)
  end
  
end