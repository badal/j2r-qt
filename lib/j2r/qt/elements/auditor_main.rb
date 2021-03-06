#!/usr/bin/env ruby
# encoding: utf-8

# File: auditor_main.rb
# Created: 27/06/12
#
# (c) Michel Demazure <michel@demazure.com>

require 'Qt'

require_relative 'common_elements.rb'
require_relative 'frames/tiers_audit_frame.rb'
require_relative 'frames/auditor_central_widget.rb'

module JacintheReports
  module GuiQt
    # main auditor window
    class AuditorMain < JacintheMain
      ABOUT = ['Auditeur pour Jacinthe', "Version #{J2R::NAME}", 'S.M.F. 2013',
               COPYRIGHT]

      # @return [AuditorMain] new instance
      # @param [String] initial_hint string given
      def initialize(initial_hint = nil)
        super()
        add_central_widget(AuditorCentralWidget.new(initial_hint))
        resize(400, 550)
        self.window_title = "Auditeur pour #{J2R::NAME}"
        window.window_icon = Icons.from_file('Board-11-Flowers-icon.png')
      end

      # open the about dialog
      def about
        Qt::MessageBox.about(self, 'Jacinthe Reports', ABOUT.join("\n"))
      end

      # open the help dialog
      def help
        J2R.open_file_command(HELP_FILE)
      end
    end
  end
end
