include Java

import java.awt.event.KeyEvent
import javax.swing.JButton
import javax.swing.JFrame
import javax.swing.JScrollPane
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
      @canvas = canvas
      canvas.setModel model
      model.interpolator.add_listener self, :polynomial_changed, :refresh
      
      scroll = JScrollPane.new canvas
      
      
      menubar = JMenuBar.new
      #icon = ImageIcon.new "exit.
      
      #################################################### Program Menu
      programMenu = JMenu.new "Program"
      programMenu.setMnemonic KeyEvent::VK_F
      
      #Program > Interpolate
      itemInterpolate = JMenuItem.new "Interpolate"
      itemInterpolate.addActionListener do |e|
        model.interpolate!
        itemInterpolate.setEnabled false
      end
      itemInterpolate.setMnemonic KeyEvent::VK_I
      itemInterpolate.setToolTipText "Interpolate current points"

#      #Program > Refresh
#      itemRefresh = JMenuItem.new "Refresh"
#      itemRefresh.addActionListener do |e|
#        refresh nil
#      end
#      itemRefresh.setMnemonic KeyEvent::VK_R
#      itemRefresh.setToolTipText "Refresh draw"
      
      #Program > Exit
      itemExit = JMenuItem.new "Exit"#, icon
      itemExit.addActionListener do |e|
          System.exit 0
      end
      itemExit.setMnemonic KeyEvent::VK_C
      itemExit.setToolTipText "Exit application"

      programMenu.add itemInterpolate
#      programMenu.addSeparator
#      programMenu.add itemRefresh
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
      
      self.getContentPane.add scroll
      
      self.setDefaultCloseOperation JFrame::EXIT_ON_CLOSE
      self.setSize 500, 500
      self.setLocationRelativeTo nil
      self.setVisible true
    end
    
    def refresh params
      @canvas.repaint
    end
    
end


class Canvas < JPanel
  
  def setModel model
    @model = model
  end
  
  def paintComponent g
    super
    
    if @model.drawable
      points = @model.points
      min_size = 100
      
      pointsX = points.map{|p| p.x}
      minx = pointsX.min.to_int - 1
      maxx = pointsX.max.to_int + 1
      deltax = [minx.abs, maxx.abs].max
      deltax = min_size if deltax < min_size
      
      pointsY = points.map{|p| p.y}
      miny = pointsY.min.to_int - 1
      maxy = pointsY.max.to_int + 1
      deltay = [miny.abs, maxy.abs].max
      deltay = min_size if deltay < min_size
      
      self.set_size 2 * deltax, 2 * deltay
      self.draw_function g
    end
  end
  
  def drawPoint g, x, y
    g.drawLine x, y, x, y
  end
  
  def draw_function g
    color_back = Color.new 100, 100, 100
    color_grid = Color.new 150, 150, 150
    color_axis = Color.new 0, 100, 255
    color_function = Color.new 255, 255, 255
    
    self.setBackground color_back
    
    w = self.getHeight
    h = self.getWidth
    hw = w / 2
    hh = h / 2
    
    #nos guardamos la antitransformacion
    at = g.getTransform
    #transformamos a coordenadas cartesianas
    g.translate hw, hh
    g.scale 1, -1
    
#    g.setColor(Color.new(125, 167, 116))
#    g.fillRect 10, 15, 90, 60
    
    #dibujamos una grilla
    grid_size = 10
    gridw = (hw / grid_size).to_int
    gridh = (hh / grid_size).to_int
    for i in -grid_size..grid_size
      g.setColor color_grid
      g.drawLine gridw * i, -hh, gridw * i, hh
      g.drawLine -hw, gridh * i, hw, gridh * i
  
      g.setColor  color_axis
      g.drawLine gridw * i, 3, gridw * i, -3
      g.drawLine 3, gridh * i, -3, gridh * i
    end
    
    #dibujamos los ejes
    g.drawLine 0, -hh, 0, hh
    g.drawLine -hw, 0, hw, 0
    
    #dibujamos la funcion
    g.setColor color_function
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
  
  def set_size w, h
    self.setPreferredSize Dimension.new(w, h)
  end
end