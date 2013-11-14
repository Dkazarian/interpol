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

require_relative "canvas.rb"

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
