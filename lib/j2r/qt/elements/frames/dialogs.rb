#!/usr/bin/env ruby
# encoding: utf-8

# File: dialogs.rb
# Created: 21/06/12
#
# (c) Michel Demazure <michel@demazure.com>

module JacintheReports
  module GuiQt
    # Jacinthe style dialog
    class Dialog < Qt::Dialog
      include Signals

      def initialize(widget, title = 'Jacinthe')
        super()
        setWindowTitle(title)
        setWindowIcon(Icons.from_file('Board-11-Flowers-icon.png'))
        layout = Qt::VBoxLayout.new
        setLayout(layout)
        layout.add_widget(widget)
        buttons = Qt::HBoxLayout.new
        layout.addLayout(buttons)
        button_box = Qt::DialogButtonBox.new
        buttons.add_widget(button_box)
        yes_button = button_box.addButton('ACCEPTER', Qt::MessageBox::AcceptRole)
        no_button = button_box.addButton('ANNULER', Qt::MessageBox::RejectRole)
        yes_button.default = true
        connect_button(yes_button, :accept)
        connect_button(no_button, :reject)
      end

      def self.confirm(message)
        message_box = Qt::MessageBox.new(Qt::MessageBox::Warning, 'Jacinthe', message)
        message_box.setWindowIcon(Icons.from_file('Board-11-Flowers-icon.png'))
        message_box.setInformativeText('Confirmez-vous ?')
        message_box.addButton('OUI', Qt::MessageBox::AcceptRole)
        no_button = message_box.addButton('NON', Qt::MessageBox::RejectRole)
        message_box.setDefaultButton(no_button)
        message_box.exec == 0
      end

      def self.ask_save_file(parent, filename)
        extension = "*#{File.extname(filename)}"
        Qt::FileDialog.getSaveFileName(
            parent.parentWidget, 'Enregistrer le fichier ?',
            filename, extension)
      end
    end
  end
end
