include Java

import java.awt.event.KeyEvent
import javax.swing.JButton
import javax.swing.JFrame
import javax.swing.JScrollPane
import javax.swing.JMenuBar
import javax.swing.JMenuItem
import javax.swing.JMenu
import javax.swing.JOptionPane
#import javax.swing.ImageIcon
import java.lang.System

import java.awt.Graphics
import java.awt.Color
import java.awt.Dimension



require_relative "window_add.rb"
require_relative "window_points.rb"

require_relative "../model/interpolator.rb"


class Overview < JFrame
  
    def initialize interpolator
      super "Interpol"
      self.initGUI interpolator
    end
    
    def initGUI interpolator
      canvas = Canvas.new
      @canvas = canvas
      canvas.setInterpolator interpolator
      canvas.setZoom 1
      interpolator.add_listener self, :polynomial_changed, :refresh
      
      scroll = JScrollPane.new canvas
      
      
      menubar = JMenuBar.new
      #icon = ImageIcon.new "exit.
      
      #################################################### Program Menu
      programMenu = JMenu.new "Program"
      #programMenu.setMnemonic KeyEvent::VK_F
      
      #Program > Interpolate
      itemInterpolate = JMenuItem.new "Interpolate"
      itemInterpolate.addActionListener do |e|
        interpolator.interpolate!
        itemInterpolate.setEnabled false
      end
      #itemInterpolate.setMnemonic KeyEvent::VK_I
      itemInterpolate.setToolTipText "Interpolate current points"

      #Program > Refresh
      itemRefresh = JMenuItem.new "Refresh"
      itemRefresh.addActionListener do |e|
        refresh
      end
      #itemRefresh.setMnemonic KeyEvent::VK_R
      itemRefresh.setToolTipText "Refresh draw"
      
      #Program > Exit
      itemExit = JMenuItem.new "Exit"#, icon
      itemExit.addActionListener do |e|
          System.exit 0
      end
      #itemExit.setMnemonic KeyEvent::VK_C
      itemExit.setToolTipText "Exit application"

      programMenu.add itemInterpolate
      programMenu.addSeparator
      programMenu.add itemRefresh
      programMenu.addSeparator
      programMenu.add itemExit
      menubar.add programMenu
      
      #################################################### Points Menu
      pointsMenu = JMenu.new "Points"
      #pointsMenu.setMnemonic KeyEvent::VK_P
      
      #Points > Add
      itemAdd = JMenuItem.new "Add..."
      itemAdd.addActionListener do |e|
        WindowAdd.new interpolator
      end
      #itemAdd.setMnemonic KeyEvent::VK_A
      itemAdd.setToolTipText "Add one or multiple points"
      #Points > Remove
      itemRemove = JMenuItem.new "Remove..."
      itemRemove.addActionListener do |e|
        WindowPoints.new interpolator, "Remove points", true
      end
      #itemRemove.setMnemonic KeyEvent::VK_R
      itemRemove.setToolTipText "Remove one or multiple points"
      #Points > View
      itemView = JMenuItem.new "View list"
      itemView.addActionListener do |e|
        WindowPoints.new interpolator, "View points", false
      end
      #itemView.setMnemonic KeyEvent::VK_V
      itemView.setToolTipText "View point list"
      
      pointsMenu.add itemAdd
      pointsMenu.add itemRemove
      pointsMenu.addSeparator
      pointsMenu.add itemView
      menubar.add pointsMenu

      #################################################### View Menu
      viewMenu = JMenu.new "View"
      
      #View > Zoom in
      itemZoomIn = JMenuItem.new "Zoom in"
      itemZoomIn.addActionListener do |e|
        canvas.zoomIn
        refresh
      end
      itemZoomIn.setToolTipText "Graph zoom in"
      #View > Zoom out
      itemZoomOut = JMenuItem.new "Zoom out"
      itemZoomOut.addActionListener do |e|
        canvas.zoomOut
        refresh
      end
      itemZoomOut.setToolTipText "Graph zoom out"
      #View > Duplicate zoom
      itemDuplicateZoom = JMenuItem.new "Duplicate zoom"
      itemDuplicateZoom.addActionListener do |e|
        canvas.duplicateZoom
        refresh
      end
      itemDuplicateZoom.setToolTipText "Graph 2x zoom in"
      #View > Restore zoom
      itemRestoreZoom = JMenuItem.new "Restore zoom"
      itemRestoreZoom.addActionListener do |e|
        canvas.setZoom 1
        refresh
      end
      itemRestoreZoom.setToolTipText "Graph restore zoom"
      
      viewMenu.add itemZoomIn
      viewMenu.add itemZoomOut
      viewMenu.addSeparator
      viewMenu.add itemDuplicateZoom
      viewMenu.addSeparator
      viewMenu.add itemRestoreZoom
      menubar.add viewMenu
      
      #################################################### Help Menu
      helpMenu = JMenu.new "Help"
      
      #Help > About
      itemAbout = JMenuItem.new "About..."
      itemAbout.addActionListener do |e|
        JOptionPane.showMessageDialog(self, "Interpolator\n\nDaniela Belen Kazarian\nFranco Tomas Hecht\nPablo Santiago Fernandez\n\n2013")
      end
      itemAbout.setToolTipText "About Interpolator"
      
      helpMenu.add itemAbout
      menubar.add helpMenu
      
      #################################################### Window
      self.setJMenuBar menubar
      
      self.getContentPane.add scroll
      
      self.setDefaultCloseOperation JFrame::EXIT_ON_CLOSE
      self.setSize 650, 500
      self.setLocationRelativeTo nil
      self.setVisible true
    end
    
    def refresh params=nil
      @canvas.repaint
    end
    
end


class Canvas < JPanel
  
  def setInterpolator interpolator
    @interpolator = interpolator
  end
  
  def setZoom zoom
    @zoom = zoom
  end
  
  def zoomIn
    @zoom = @zoom + 1
  end
  
  def zoomOut
    @zoom = @zoom - 1 if @zoom > 1
  end
  
  def duplicateZoom
    @zoom = @zoom * 2
  end
  
  def paintComponent g
    super 
    
    unless @interpolator.points.empty?
      points = @interpolator.points
      min_size = 100
      extra_size = 50
      
      pointsX = points.map{|p| p.x.abs}
      maxx = pointsX.max.to_int + 1
      maxx = min_size if maxx < min_size
      
      pointsY = points.map{|p| p.y.abs}
      maxy = pointsY.max.to_int + 1
      maxy = min_size if maxy < min_size
      
      w = 2 * maxx + extra_size
      h = 2 * maxy + extra_size
      
      zoom = @zoom
      zw = w * zoom
      zh = h * zoom
      
      self.set_size zw, zh
      self.draw_function g if @interpolator.polynomial
    end
  end
  
  def drawPoint g, x, y
    g.drawLine x, y, x, y
  end
  
  def color r, g, b
    Color.new r, g, b
  end

  def sign n
    n / n.abs
  end

  def draw_function g
    #user def constants
    color_back = color 100, 100, 100
    color_grid = color 150, 150, 150
    grid_size = 10
    color_axis = color 0, 100, 255
    color_function = color 255, 255, 255
    color_point = color 230, 0, 0

    #other constants
    w = self.getWidth
    h = self.getHeight
    hw = w / 2
    hh = h / 2
    
    self.setBackground color_back
    
    #nos guardamos la antitransformacion
    at = g.getTransform
    #transformamos a coordenadas cartesianas
    g.translate hw, hh
    g.scale 1, -1
    
    #dibujamos una grilla
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
    
    #rotamos para poder imprimir texto
    g.scale 1, -1
    
    #imprimimos texto en los ejes
    g.setColor color_axis
    g.drawString "x", hw - 10, 10
    g.drawString "P(x) = y", -70, -hh + 10
    for i in 1..grid_size
      x = gridw * i
      nx = -x
      y = -gridh * i
      ny = -y
      #numeros en el eje x
      g.drawString x.to_s, x, -3
      g.drawString nx.to_s, nx, -3
      #numeros en el eje y
      g.drawString y.to_s, 3, y
      g.drawString ny.to_s, 3, ny
    end
    g.drawString "0", 3, -3
    
    #rotamos para seguir dibujando
    g.scale 1, -1
    
    #marcamos los puntos que ingresamos
    points = @interpolator.points
    g.setColor color_point
    for p in points
      g.drawLine 0, p.y, p.x, p.y
      g.drawLine p.x, 0, p.x, p.y
    end
    
    #dibujamos la funcion
    g.setColor color_function
    last_x = -hw
    for x in -hw..hw
      
      y = @interpolator.evaluate x
      last_y = y if x == -hw
      

      shh = -hh

      if (y > hh) ^ (last_y > hh)
        dy = y - last_y
        t = (hh - last_y) / dy
        dx = x - last_x
        yt = hh
        xt = last_x + t * dx
        g.drawLine last_x, last_y, xt, yt if y > hh
        g.drawLine xt, yt, x, y if last_y > hh
      elsif (y < shh) ^ (last_y < shh)
        dy = y - last_y
        t = (shh - last_y) / dy
        dx = x - last_x
        yt = shh
        xt = last_x + t * dx
        g.drawLine last_x, last_y, xt, yt if y < shh
        g.drawLine xt, yt, x, y if last_y < shh
      elsif y.abs < hh && last_y.abs < hh
        g.drawLine last_x, last_y, x, y
      end
      

      last_x = x
      last_y = y
      
    end
    
    #rotamos para poder imprimir texto
    g.scale 1, -1
    
    #imprimimos los puntos
    g.setColor color_point
    for p in points
      g.drawString p.to_s, p.x, -p.y
    end
    
    #antitransformamos
    g.setTransform at
  end
  
  def set_size w, h
    self.setPreferredSize Dimension.new(w, h)
  end
end