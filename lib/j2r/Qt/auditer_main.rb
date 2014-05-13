#!/usr/bin/env ruby
# encoding: utf-8

# File: auditer_gui.rb
# Created: 27/06/12
#
# (c) Michel Demazure <michel@demazure.com>

require 'Qt'
require_relative 'auditer_qt.rb'

module JacintheReports
  module GuiQt
    # main auditer window
    class AuditerMain < JacintheMain
      ABOUT = ['Auditeur pour Jacinthe', "Version #{J2R::NAME}", 'S.M.F. 2013',
               J2R::COPYRIGHT]

      HELP_FILE = File.join(J2R::HELP_DIR, 'jacdoc.html')

      # @return [AuditerMain] new instance
      # @param [String] initial_hint string given
      def initialize(initial_hint = nil)
        super()
        add_central_widget(AuditerCentralWidget.new(initial_hint))
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
