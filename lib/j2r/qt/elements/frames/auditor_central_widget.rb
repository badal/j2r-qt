#!/usr/bin/env ruby
# encoding: utf-8

# File: auditer_central_widget.rb
# Created:  10/06/12
#
# (c) Michel Demazure <michel@demazure.com>

module JacintheReports
  module GuiQt
    # central widget for auditer
    class AuditorCentralWidget < Qt::Widget
      include Signals
      slots 'console_message (const QString&)', 'show_html (const QString&)'
      signals 'status_message (const QString&)'

      # @return [AuditorCentralWidget] new instance
      # @param [String] initial_hint string given
      def initialize(initial_hint)
        super()
        layout = Qt::VBoxLayout.new(self)
        @head_label = Qt::Label.new
        layout.add_widget(@head_label)
        @show_zone = Qt::TextEdit.new(Qt::Frame.new)
        layout.add_widget(@show_zone)
        horizontal = Qt::HBoxLayout.new
        layout.addLayout(horizontal)
        @audit_frame = TiersAuditFrame.new(initial_hint)
        horizontal.add_widget(@audit_frame)
        @mailing_frame = MailingFrame.new(@audit_frame)
        horizontal.add_widget(@mailing_frame)
        horizontal.addStretch
        layout.addStretch
        connect_signals
      end

      def connect_signals
        show_connect(@audit_frame)
        console_connect(@audit_frame)
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
