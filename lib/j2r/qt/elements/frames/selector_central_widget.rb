#!/usr/bin/env ruby
# encoding: utf-8

# File: selector_central_widget.rb
# Created:  2/10/15
#
# (c) Michel Demazure <michel@demazure.com>

module JacintheReports
  module GuiQt
    # central widget for auditer
    class SelectorCentralWidget < Qt::Widget
      include Signals

      slots 'console_message (const QString&)', 'show_html (const QString&)'
      signals 'status_message (const QString&)'

      # @return [SelectorCentralWidget] new instance
      def initialize
        super()
        layout = Qt::VBoxLayout.new(self)

        # @head_label = Qt::Label.new
        # layout.add_widget(@head_label)
        # @show_zone = Qt::TextEdit.new(Qt::Frame.new)
        # layout.add_widget(@show_zone)
        horizontal = Qt::HBoxLayout.new
        layout.addLayout(horizontal)
        @selection_frame = SelectionFrame.new
        horizontal.add_widget(@selection_frame)
        list_tool = Object.new
        def list_tool.tiers_list
          [1, 2, 3]
        end
        @mailing_frame = MailingFrame.new(list_tool)
        horizontal.add_widget(@mailing_frame)
        horizontal.addStretch
        @show_zone = Qt::TextEdit.new(Qt::Frame.new)
        layout.add_widget(@show_zone)
        layout.addStretch
        connect_signals
      end

      def connect_signals
        show_connect(@selection_frame)
        console_connect(@selection_frame)
        show_connect(@mailing_frame)
        console_connect(@mailing_frame)
      end

      # send the message to the console (overrides)
      # @param [String] msg message to transmit
      def console_message(msg)
        emit(status_message(msg.force_encoding('utf-8')))
      end

      # send the text to the show area (overrides)
      # @param [String] html text to show
      def show_html(html)
        @show_zone.setHtml(html.force_encoding('utf-8'))
      end
    end
  end
end
