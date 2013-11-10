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
import java.awt.Dimension


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
      canvas.setModel model
      
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
          canvas.redraw -50, -50, 100, 100
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
  
  def setModel model
    @model = model
  end
  
  def redraw x, y, width, height
    @x = x
    @y = y
    @width = width
    @height = height
    self.repaint
  end
  
  def paintComponent g
    super
    self.draw_function g unless not @model.drawable
  end
  
  def drawPoint g, x, y
    g.drawLine x, y, x, y
  end
  
  def draw_function g
    panel_width = self.getHeight
    panel_height = self.getWidth
    hw = panel_width / 2
    hh = panel_height / 2
    
    #nos guardamos la antitransformacion
    at = g.getTransform
    #transformamos a coordenadas cartesianas
    g.translate hw, hh
    g.scale 1, -1
    
#    g.setColor(Color.new(125, 167, 116))
#    g.fillRect 10, 15, 90, 60
    
    #dibujamos los ejes
    g.drawLine 0, -hw, 0, hw
    g.drawLine -hh, 0, hh, 0
    
    #dibujamos la funcion
    for x in -hw..hw
      y = @model.evaluate x
      last_x = x if x == -hw
      last_y = y if x == -hw
      g.drawLine last_x, last_y, x, y
      last_x = x
      last_y = y
    end
    
    #antitransformamos
    g.setTransform at
  end
end