#!/usr/bin/env ruby
# encoding: utf-8

# File: ip_manager_main.rb
# Created: 30/06/2016
#
# (c) Michel Demazure <michel@demazure.com>

require 'Qt'

require_relative 'common_elements.rb'
require_relative 'frames/ip_editor.rb'
require_relative 'frames/ip_manager_central_widget.rb'

module JacintheReports
  module GuiQt
    # main selector window
    class IPManagerMain < JacintheMain
      ABOUT = ['Manager de plages IP pour Jacinthe', "Version #{J2R::NAME}",
               "version jacman-ip #{JacintheManagement::IP::VERSION}",
               'S.M.F. 2016',
               "\u00A9 Michel Demazure"]

      # @return [IPManagerMain] new instance
      def initialize(*_args)
        super()
        set_central_widget(IPManagerCentralWidget.new)
        resize(400, 300)
        self.window_title = "Manager d'IP pour #{J2R::NAME}"
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
