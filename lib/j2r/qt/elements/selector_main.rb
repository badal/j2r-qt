#!/usr/bin/env ruby
# encoding: utf-8

# File: selectormain.rb
# Created: 2/10/12
#
# (c) Michel Demazure <michel@demazure.com>

require 'Qt'

require_relative 'selector.rb'
require_relative 'selector_elements.rb'

module JacintheReports
  module GuiQt
    # main selector window
    class SelectorMain < JacintheMain
      ABOUT = ['Sélecteur pour Jacinthe', "Version #{J2R::NAME}", 'S.M.F. 2013',
               COPYRIGHT]

      # @return [SelectorMain] new instance
      def initialize(*args)
        super()
        add_central_widget(SelectorCentralWidget.new)
        resize(400, 550)
        self.window_title = "Sélecteur pour #{J2R::NAME}"
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
