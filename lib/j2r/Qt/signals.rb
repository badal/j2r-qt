#!/usr/bin/env ruby
# encoding: utf-8

# File: signals.rb
# Created: 21/06/12
#
# (c) Michel Demazure <michel@demazure.com>

module JacintheReports
  # all classes and methods for both GUIs
  module GuiQt
    # common signalisation for GUIs
    module Signals
      SIGNAL_CLICKED = SIGNAL(:clicked)
      SIGNAL_ACTIVATED = SIGNAL('activated(const QString&)')

      # signaling for console_message
      # @param [Frame] frame fram to be connected
      def console_connect(frame)
        connect(frame, SIGNAL('ask_console_message (const QString&)'),
                self, SLOT('console_message (const QString&)'))
      end

      # signaling for show_html
      # @param [Frame] frame fram to be connected
      def show_connect(frame)
        connect(frame, SIGNAL('ask_show_html (const QString&)'),
                self, SLOT('show_html (const QString&)'))
      end

      # connecting buttons
      # @param [Qt::PushButton] button button to connect
      # @param [Symbol] action SLOT action to connect
      def connect_button(button, action)
        connect(button, SIGNAL_CLICKED, self, SLOT(action))
      end

      # send the message to the console
      # @param [String] msg message to transmit
      def console_message(msg)
        emit(ask_console_message(msg.force_encoding('utf-8')))
      end

      # send the test to the show area
      # @param [String] html text to show
      def show_html(html)
        emit(ask_show_html(html.force_encoding('utf-8')))
      end
    end
  end
end
