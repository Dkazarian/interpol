include Java

import java.awt.event.KeyEvent
import javax.swing.JButton
import javax.swing.JFrame
import javax.swing.JMenuBar
import javax.swing.JMenuItem
import javax.swing.JMenu
#import javax.swing.ImageIcon
import java.lang.System


require_relative "window_add.rb"


class Overview < JFrame
  
    def initialize
      super "Overview form"
      
      self.initGUI
    end
      
    def initGUI
      menubar = JMenuBar.new
      #icon = ImageIcon.new "exit.
      
      #################################################### File Menu
      fileMenu = JMenu.new "File"
      fileMenu.setMnemonic KeyEvent::VK_F
      
      #File > Exit      
      itemExit = JMenuItem.new "Exit"#, icon
      itemExit.addActionListener do |e|
          System.exit 0
      end
      itemExit.setMnemonic KeyEvent::VK_C
      itemExit.setToolTipText "Exit application"

      fileMenu.add itemExit
      menubar.add fileMenu
      
      #################################################### Points Menu
      pointsMenu = JMenu.new "Points"
      pointsMenu.setMnemonic KeyEvent::VK_P
      
      #Points > Add
      itemAdd = JMenuItem.new "Add..."
      itemAdd.addActionListener do |e|
        WindowAdd.new
      end
      itemAdd.setMnemonic KeyEvent::VK_A
      itemAdd.setToolTipText "Add one or multiple points"
      #Points > Remove
      itemRemove = JMenuItem.new "Remove..."
      itemRemove.setMnemonic KeyEvent::VK_R
      itemRemove.setToolTipText "Remove one or multiple points"
      #Points > View
      itemView = JMenuItem.new "View list"
      itemView.setMnemonic KeyEvent::VK_V
      itemView.setToolTipText "View point list"
      
      pointsMenu.add itemAdd
      pointsMenu.add itemRemove
      pointsMenu.addSeparator
      pointsMenu.add itemView
      menubar.add pointsMenu
      
      #################################################### Window
      self.setJMenuBar menubar  
      
      self.setDefaultCloseOperation JFrame::EXIT_ON_CLOSE
      self.setSize 250, 200
      self.setLocationRelativeTo nil
      self.setVisible true
    end
end