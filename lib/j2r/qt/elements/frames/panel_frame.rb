#!/usr/bin/env ruby
# encoding: utf-8

# File: panel_frame.rb
# Created: 21/06/12
#
# (c) Michel Demazure <michel@demazure.com>

module JacintheReports
  module GuiQt
    # common "modifier" panel for all line operations
    class PanelFrame < Qt::VBoxLayout
      include Signals
      slots :clicked
      signals :modify

      def initialize
        super()
        @pane = Qt::TextEdit.new(Qt::Frame.new)
        add_widget(@pane)
        buttons = Qt::HBoxLayout.new
        addLayout(buttons)
        buttons.addStretch
        button = Qt::PushButton.new('Modifier')
        button.setStyleSheet('* { background-color: rgb(255,255,200) }')
        buttons.add_widget(button)
        connect_button(button, :clicked)
      end

      def clicked
        emit(modify)
      end

      def update_content(html)
        @pane.setHtml(html)
        @pane.setReadOnly(true)
      end
    end
  end
end
