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

      DUMMY = Object.new
      def DUMMY.tiers_list
        nil
      end

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

        @mailing_frame = MailingFrame.new(DUMMY)
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
        connect(@selection_frame, SIGNAL(:source_changed)) { source_changed }
      end

      def source_changed
        @mailing_frame.source = @selection_frame.selector
      end

      # send the message to the console (overrides)
      # @param [String] msg message to transmit
      def console_message(msg)
        emit(status_message(msg.force_encoding('utf-8')))
      end

      # send the text to the show area (overrides)
      # @param [String] html text to show
      def show_html(html)
        @html = html
        @show_zone.setHtml(@html.force_encoding('utf-8'))
      end

      # send the text to the show area (append)
      # @param [String] html text to append
      def append_html(html)
        @html = @html + '<P>' + html
        @show_zone.setHtml(@html.force_encoding('utf-8'))
      end
    end
  end
end
