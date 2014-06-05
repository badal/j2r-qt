#!/usr/bin/env ruby
# encoding: utf-8

# File: jacinthe_main.rb
# Created: 08/07/12
#
# (c) Michel Demazure <michel@demazure.com>

module JacintheReports
  module GuiQt
    # Jacinthe common main window
    class JacintheMain < Qt::MainWindow
      # copyright
      COPYRIGHT = "\u00A9 Michel Demazure & Kenji Lefevre"

      # help directory
      HELP_FILE = File.expand_path('../../../../help/jacdoc.html', File.dirname(__FILE__))

      include Signals
      slots :about, :help

      def initialize
        super
        self.window_icon = Icons.from_file('Board-11-Flowers-icon.png')
        @status = statusBar
        @status.showMessage "Bonjour #{User.name}"
        about = Qt::PushButton.new('A propos...')
        help = Qt::PushButton.new(Icons.icon('standardbutton-help'), 'Aide')
        @status.addPermanentWidget(help)
        @status.addPermanentWidget(about)
        @status.connect(about, SIGNAL_CLICKED, self, SLOT(:about))
        @status.connect(help, SIGNAL_CLICKED, self, SLOT(:help))
      end

      def add_central_widget(widget)
        self.central_widget = widget
        connect(widget, SIGNAL('status_message (const QString&)'),
                @status, SLOT('showMessage (const QString&)'))
      end

      # start the application
      def self.run
        application = Qt::Application.new(ARGV)
        new(ARGV[0]).show
        application.exec
      end
    end
  end
end
