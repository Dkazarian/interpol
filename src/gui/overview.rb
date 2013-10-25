include Java

import java.awt.event.KeyEvent
import javax.swing.JButton
import javax.swing.JFrame
import javax.swing.JMenuBar
import javax.swing.JMenuItem
import javax.swing.JMenu
#import javax.swing.ImageIcon
import java.lang.System


class Overview < JFrame
  
    def initialize
        super "Overview form"
        
        self.initGUI
    end
      
    def initGUI
      
        menubar = JMenuBar.new
        #icon = ImageIcon.new "exit.png"

        fileMenu = JMenu.new "File"
        fileMenu.setMnemonic KeyEvent::VK_F

        itemExit = JMenuItem.new "Exit"#, icon
        itemExit.addActionListener do |e|
            System.exit 0
        end
        
        itemExit.setMnemonic KeyEvent::VK_C
        itemExit.setToolTipText "Exit application"

        fileMenu.add itemExit

        menubar.add fileMenu

        self.setJMenuBar menubar  
        
        self.setDefaultCloseOperation JFrame::EXIT_ON_CLOSE
        self.setSize 250, 200
        self.setLocationRelativeTo nil
        self.setVisible true
    end
end