#!/usr/bin/env ruby
# encoding: utf-8

# File: export_frame.rb
# Created: 27/06/12
#
# (c) Michel Demazure <michel@demazure.com>

module JacintheReports
  module GuiQt
    # main export panel for the reporter
    class ExportFrame < PrettyFrame
      def initialize(recipe)
        super('EXPLOITATION')
        set_color(GREEN)
        self.frame_shadow = Qt::Frame::Raised
        @recipe = recipe
        @parametrizer = ParametrizerFrame.new(@recipe)
        build_layout
        connect_frames
      end

      def build_layout
        @layout.add_layout(@parametrizer)
        @layout.add_widget(HLine.new)
        horizontal = Qt::HBoxLayout.new
        @layout.addLayout(horizontal)
        @report_frame = ReportFrame.new(@parametrizer)
        horizontal.add_widget(@report_frame)
        @cross_frame = CrossFrame.new(@parametrizer)
        horizontal.add_widget(@cross_frame)
        @mailing_frame = MailingFrame.new(@parametrizer)
        horizontal.add_widget(@mailing_frame)
        @layout.addStretch
      end

      def connect_frames
        [@report_frame, @cross_frame, @mailing_frame].each do |frame|
          console_connect(frame)
          show_connect(frame)
        end
      end

      def build_panel
        @parametrizer.build_panel
        @report_frame.build_panel
        @cross_frame.build_panel
      end
    end
  end
end
