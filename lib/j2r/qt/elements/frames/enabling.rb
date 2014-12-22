#!/usr/bin/env ruby
# encoding: utf-8

# File: enabling.rb
# Created: 10/07/13
#
# (c) Michel Demazure <michel@demazure.com>
module JacintheReports
  module GuiQt
    # methods for sub-panels of the report panel (cross_frame and mailing_frame)
    module Enabling
      # disable the panel
      def disable
        self.enabled = false
      end

      # enable the panel
      def enable
        self.enabled = true
      end

      # connect in +obj+ the signals
      def connect_enabling(obj)
        self.class.slots :enable, :disable
        connect(obj, SIGNAL(:do_operations), self, SLOT(:disable))
        connect(obj, SIGNAL(:no_operations), self, SLOT(:enable))
      end
    end
  end
end
