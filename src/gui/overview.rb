include Java

import java.awt.event.KeyEvent
import javax.swing.JButton
import javax.swing.JFrame
import javax.swing.JMenuBar
import javax.swing.JMenuItem
import javax.swing.JMenu
#import javax.swing.ImageIcon
import java.lang.System

import java.awt.Graphics
import java.awt.Color


require_relative "window_add.rb"
require_relative "window_points.rb"

require_relative "../model/interpolator.rb"


class Overview < JFrame
  
    def initialize model
      super "Overview form"
      self.initGUI model
    end
      
    def initGUI model
      canvas = Canvas.new
      
      menubar = JMenuBar.new
      #icon = ImageIcon.new "exit.
      
      #################################################### Program Menu
      programMenu = JMenu.new "Program"
      programMenu.setMnemonic KeyEvent::VK_F
      
      #Program > Interpolate
      itemInterpolate = JMenuItem.new "Interpolate"
      itemInterpolate.addActionListener do |e|
        model.interpolate
        #TODO mostrar el resultado en un dialog
      end
      itemInterpolate.setMnemonic KeyEvent::VK_I
      itemInterpolate.setToolTipText "Interpolate current points"

      #Program > Refresh
      itemRefresh = JMenuItem.new "Refresh"
      itemRefresh.addActionListener do |e|
          canvas.redraw model, 0, 0, 100, 100
      end
      itemRefresh.setMnemonic KeyEvent::VK_R
      itemRefresh.setToolTipText "Refresh draw"
      
      #Program > Exit
      itemExit = JMenuItem.new "Exit"#, icon
      itemExit.addActionListener do |e|
          System.exit 0
      end
      itemExit.setMnemonic KeyEvent::VK_C
      itemExit.setToolTipText "Exit application"

      programMenu.add itemInterpolate
      programMenu.addSeparator
      programMenu.add itemRefresh
      programMenu.addSeparator
      programMenu.add itemExit
      menubar.add programMenu
      
      #################################################### Points Menu
      pointsMenu = JMenu.new "Points"
      pointsMenu.setMnemonic KeyEvent::VK_P
      
      #Points > Add
      itemAdd = JMenuItem.new "Add..."
      itemAdd.addActionListener do |e|
        WindowAdd.new model
      end
      itemAdd.setMnemonic KeyEvent::VK_A
      itemAdd.setToolTipText "Add one or multiple points"
      #Points > Remove
      itemRemove = JMenuItem.new "Remove..."
      itemRemove.addActionListener do |e|
        WindowPoints.new model, "Remove points", true
      end
      itemRemove.setMnemonic KeyEvent::VK_R
      itemRemove.setToolTipText "Remove one or multiple points"
      #Points > View
      itemView = JMenuItem.new "View list"
      itemView.addActionListener do |e|
        WindowPoints.new model, "View points", false
      end
      itemView.setMnemonic KeyEvent::VK_V
      itemView.setToolTipText "View point list"
      
      pointsMenu.add itemAdd
      pointsMenu.add itemRemove
      pointsMenu.addSeparator
      pointsMenu.add itemView
      menubar.add pointsMenu
      
      #################################################### Window
      self.setJMenuBar menubar
      
      self.getContentPane.add canvas
      
      self.setDefaultCloseOperation JFrame::EXIT_ON_CLOSE
      self.setSize 500, 500
      self.setLocationRelativeTo nil
      self.setVisible true
    end
    
end


class Canvas < JPanel
  
  def redraw model, x, y, width, height
    @model = model
    @x = x
    @y = y
    @width = width
    @height = height
    self.repaint
  end
  
  def paintComponent g
    super g
    self.draw g
  end
  
  def draw g
    g.setColor(Color.new(125, 167, 116))
    g.fillRect 10, 15, 90, 60

    g.setColor(Color.new(42, 179, 231))
    g.fillRect 130, 15, 90, 60

    g.setColor(Color.new(70, 67, 123))
    g.fillRect 250, 15, 90, 60

    g.setColor(Color.new(130, 100, 84))
    g.fillRect 10, 105, 90, 60

    g.setColor(Color.new(252, 211, 61))
    g.fillRect 130, 105, 90, 60

    g.setColor(Color.new(241, 98, 69))
    g.fillRect 250, 105, 90, 60

    g.setColor(Color.new(217, 146, 54))
    g.fillRect 10, 195, 90, 60

    g.setColor(Color.new(63, 121, 186))
    g.fillRect 130, 195, 90, 60

    g.setColor(Color.new(31, 21, 1))
    g.fillRect 250, 195, 90, 60
  end
end