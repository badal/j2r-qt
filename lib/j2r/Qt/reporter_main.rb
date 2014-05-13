#!/usr/bin/env ruby
# encoding: utf-8

# File: reporter_gui.rb
# Created: 10/06/12
#
# (c) Michel Demazure <michel@demazure.com>

require 'Qt'
require_relative 'reporter_qt.rb'

module JacintheReports
  module GuiQt
    # reporter main window
    class ReporterMain < JacintheMain
      ABOUT = ['Rapporteur pour Jacinthe', "Version #{J2R::NAME}", 'S.M.F. 2013',
               J2R::COPYRIGHT]

      QUIT_MSG = ['La maquette a été modifiée.', 'Vous aller quitter sans l\'enregistrer.']

      HELP_FILE = File.join(J2R::HELP_DIR, 'jacdoc.html')

      # @param [String or nil] recipe_file of command line
      def initialize(recipe_file = nil)
        super()
        add_central_widget(ReporterCentralWidget.new(recipe_file))
        resize(700, 930)
        self.window_title = "Rapporteur pour #{J2R::NAME}"
      end

      # protecting close event
      # WARNING needs camelCase form !!!
      # noinspection RubyInstanceMethodNamingConvention
      def closeEvent(event) # rubocop:disable MethodName
        if  !central_widget.need_saving || Dialog.confirm(QUIT_MSG.join("\n"))
          event.accept
        else
          event.ignore
        end
      end

      # open about dialog
      def about
        Qt::MessageBox.about(self, 'Jacinthe Reports', ABOUT.join("\n"))
      end

      # open help dialog
      def help
        J2R.open_file_command(HELP_FILE)
      end
    end
  end
end
