include Java

import java.awt.event.KeyEvent
import javax.swing.JButton
import javax.swing.JList
import javax.swing.ListSelectionModel
import javax.swing.JScrollPane
import javax.swing.JLabel
import javax.swing.JFrame
import javax.swing.JPanel
import java.awt.Dimension
import java.lang.System


require_relative "../model/interpolator.rb"
require_relative "../model/point.rb"


class WindowPoints < JFrame
  
    def initialize model, title, remove_button
      super title
      self.initGUI model, remove_button
    end
    
    def initGUI model, remove_button
      self.setLayout nil
      
      separation = 20
      field_width = 100
      field_height = 25
      list_width = 150
      list_height = 300
      remove_height = 0
      remove_height = 25 if remove_button
      window_width = list_width + 2 * separation
      window_height = 3 * separation + 2 * field_height + list_height + 2 * remove_height
      
      descriptionLabel = JLabel.new "description here"
      descriptionLabel.setBounds separation, separation, window_width - 2 * separation, field_height
      
      list = JList.new #TODO pasarle la lista de puntos
      list.setSelectionMode ListSelectionModel.SINGLE_INTERVAL_SELECTION
      list.setVisibleRowCount -1
      listScroller = JScrollPane.new list
      list.setBounds separation, 2 * separation + field_height, list_width, list_height

      if remove_button
        removeButton = JButton.new "Remove"
        removeButton.addActionListener do |e|
          System.exit 0 #TODO eliminar punto seleccionado
        end
        removeButton.setBounds separation, 2 * separation + field_height + list_height, list_width, remove_height
        self.add removeButton
        
        clearButton = JButton.new "Remove all"
        clearButton.addActionListener do |e|
          System.exit 0 #TODO eliminar todos los puntos
        end
        clearButton.setBounds separation, 2 * separation + field_height + list_height + remove_height, list_width, remove_height
        self.add clearButton
      end

      closeButton = JButton.new "Close"
      closeButton.addActionListener do |e|
        self.dispose
      end
      closeButton.setBounds window_width - field_width, window_height - field_height, field_width, field_height
      
      self.add descriptionLabel
      self.add list
      self.add closeButton
      
      window_size = Dimension.new window_width, window_height
      self.getContentPane.setPreferredSize window_size
      self.pack
      self.setResizable false
      
      self.setDefaultCloseOperation JFrame::EXIT_ON_CLOSE
      self.setLocationRelativeTo nil
      self.setVisible true
    end
end