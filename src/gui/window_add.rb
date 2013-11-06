include Java

import java.awt.event.KeyEvent
import javax.swing.JButton
import javax.swing.JTextField
import javax.swing.JLabel
import javax.swing.JFrame
import javax.swing.JPanel
import java.awt.Dimension
import java.lang.System


require_relative "../model/interpolator.rb"
require_relative "../model/point.rb"


class WindowAdd < JFrame
  
    def initialize model
      super "Add points"
      self.initGUI model
    end
      
    def initGUI model
      self.setLayout nil
      
      separation = 20
      field_width = 100
      field_height = 25
      window_width = 2 * field_width + 3 * separation
      window_height = 3 * separation + 3 * field_height
      
      descriptionLabel = JLabel.new "description here"
      descriptionLabel.setBounds separation, separation, window_width - 2 * separation, field_height
      
      xField = JTextField.new
      yField = JTextField.new
      xField.setBounds separation, descriptionLabel.getBounds.y + descriptionLabel.getBounds.height + separation, field_width, field_height
      yField.setBounds xField.getBounds.x + xField.getBounds.width + separation, xField.getBounds.y, field_width, field_height
      
      addButton = JButton.new "Add"
      addButton.addActionListener do |e|
        x = xField.getText
        y = yField.getText
        model.add x, y
        xField.setText ""
        yField.setText ""
      end
      addButton.setBounds window_width - field_width, window_height - field_height, field_width, field_height

      closeButton = JButton.new "Close"
      closeButton.addActionListener do |e|
        self.dispose
      end
      closeButton.setBounds window_width - 2 * field_width, window_height - field_height, field_width, field_height
      
      self.add descriptionLabel
      self.add xField
      self.add yField
      self.add addButton
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