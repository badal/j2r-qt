#!/usr/bin/env ruby
# encoding: utf-8

# File: save_and_show_layout.rb
# Created: 18/06/12,
# Updated with check protection and renamed: 23/4/2015
#
# (c) Michel Demazure <michel@demazure.com>

module JacintheReports
  module GuiQt
    # common layout for exporting panels
    class SaveAndShowLayout < Qt::BoxLayout
      FORMATS = %w(html csv pdf)

      include Signals
      signals 'ask_console_message (const QString&)'
      slots :save_report, :open_report, :format_changed

      def initialize(direction, recipe)
        super(layout_direction(direction))
        @report = nil
        @recipe = recipe
        add_widget(Qt::Label.new('Format'))
        @format = PrettyCombo.new(10)
        @format.addItems(FORMATS)
        @format.enabled = true
        add_widget(@format)
        build_buttons
        addStretch
      end

      def layout_direction(direction)
        case direction
        when :horizontal
          Qt::BoxLayout::LeftToRight
        when :vertical
          Qt::BoxLayout::TopToBottom
        else
          nil
        end
      end

      def build_buttons
        buttons = Qt::HBoxLayout.new
        addLayout(buttons)
        connect(@format, SIGNAL_ACTIVATED, self, SLOT(:format_changed))
        @save_button = Qt::PushButton.new(Icons.icon('standardbutton-save'), 'Enregistrer')
        connect_button(@save_button, :save_report)
        @save_button.enabled = false
        buttons.add_widget(@save_button)
        @show_button = Qt::PushButton.new(Icons.icon('standardbutton-open'), 'Ouvrir')
        connect_button(@show_button, :open_report)
        buttons.add_widget(@show_button)
        @show_button.enabled = false
      end

      def load_report(report)
        @report = report
        @save_button.enabled = true
        @recipe.processed = true
        format_changed
      end

      def format_changed
        @show_button.enabled = ! (@format.currentText == 'pdf' || @report.nil?)
      end

      def check
        msg = "Le rapport n'a pas été créé après la modification de la maquette"
        @recipe.processed || Dialog.confirm(msg)
      end

      def save_report
        return unless check
        format = @format.currentText
        console_message send("output_#{format}".to_sym)
      end

      def open_report
        return unless check
        format = @format.currentText
        send "open_#{format}".to_sym
      end

      def ask_path(extension)
        filename = File.join(User.sorties, @report.default_name + extension)
        Dialog.ask_save_file(self, filename)
      end

      # create and save html output
      def output_html
        path = ask_path('.html')
        path ? @report.to_html_file(path) : 'Annulé'
      end

      # create and save csv output
      def output_csv
        if @report.is_a?(Reports::Bundle)
          @report.to_csv_usr_file
        else
          path = ask_path('.csv')
          path ? @report.to_csv_file(path) : 'Annulé'
        end
      end

      # create and save pdf output, ask confirm
      def output_pdf
        siz = @report.size.to_i
        if siz < 500 || Dialog.confirm("Cela demandera environ #{siz / 250} secondes")
          path = ask_path('.pdf')
          path ? build_and_save_pdf(path) : 'Annulé'
        else
          'Annulé'
        end
      rescue
        pdf_error
      end

      # create and save the pdf output
      # @param [String] path full path of pdf file
      def build_and_save_pdf(path)
        message = 'Construction du fichier pdf'
        message_box = Qt::MessageBox.new(Qt::MessageBox::Warning, 'ATTENDEZ', message)
        message_box.setWindowIcon(Icons.from_file('Board-11-Flowers-icon.png'))
        message_box.standard_buttons = nil
        message_box.informative_text = 'Patientez ...'
        message_box.show
        console_message message
        ret = @report.to_pdf_file(path)
        message_box.accept
        ret
      end

      # show the report in the browser
      def open_html
        console_message(J2R.open_file_command(@report.temp_html))
      end

      # show the report in Excel
      def open_csv
        console_message(J2R.open_file_command(@report.temp_csv))
      end

      # reports error in  a popup
      def pdf_error
        message = 'Le fichier pdf n\'a pas pu être créé !'
        message_box = Qt::MessageBox.new(Qt::MessageBox::Warning, 'Jacinthe', message)
        message_box.setWindowIcon(Icons.from_file('Board-11-Flowers-icon.png'))
        message_box.exec
        'Fichier pdf non créé'
      end
    end
  end
end
