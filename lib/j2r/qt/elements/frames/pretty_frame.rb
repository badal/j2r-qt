#!/usr/bin/env ruby
# encoding: utf-8

# File: pretty_frame.rb
# Created: 10/06/12
#
# (c) Michel Demazure <michel@demazure.com>

module JacintheReports
  module GuiQt
    # common line format
    class Line < Qt::Frame
      def initialize(shape)
        super()
        set_frame_shape(shape)
        set_frame_shadow(Qt::Frame::Raised)
      end
    end

    # horizontal line
    class HLine < Line
      def initialize
        super(Qt::Frame::HLine)
      end
    end

    # vertical line
    class VLine < Line
      def initialize
        super(Qt::Frame::VLine)
      end
    end

    # common Jacinthe model frame
    class PrettyFrame < Qt::Frame
      YELLOW = '#FFE'
      GREEN = '#EFE'

      include Signals
      signals 'ask_console_message (const QString&)', 'ask_show_html (const QString&)',
              :recipe_updated, 'set_tab (int)'
      slots :build_panel, 'console_message (const QString&)', 'show_html (const QString&)'

      def initialize(label)
        super()
        set_size_policy(Qt::SizePolicy::Fixed, Qt::SizePolicy::Fixed)
        self.frame_shape = Qt::Frame::StyledPanel
        self.frame_shadow = Qt::Frame::Sunken
        self.line_width = 2
        self.auto_fill_background = true
        label = Qt::Label.new("<b> #{label}</b>")
        #   label.alignment = qt::AlignHCenter
        label.alignment = Qt::AlignLeft
        @layout = Qt::VBoxLayout.new(self)
        @layout.add_widget(label)
      end

      def selection_widget(label, items)
        @layout.add_widget(Qt::Label.new(label))
        combo = PrettyCombo.new(20)
        combo.enabled = true
        combo.addItems(items)
        @layout.add_widget(combo)
        combo
      end

      def build_panel
        console_message 'FAKE : TO BE OVERRIDEN'
      end

      def console_message(msg)
        emit(ask_console_message(msg.force_encoding('utf-8')))
      end

      def set_color(color) # rubocop: disable AccessorMethodName
        palette = Qt::Palette.new
        palette.set_color(backgroundRole, Qt::Color.new(color))
        self.palette = palette
      end
    end
  end
end
