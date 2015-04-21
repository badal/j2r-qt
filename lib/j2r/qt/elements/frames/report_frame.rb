#!/usr/bin/env ruby
# encoding: utf-8

# File: report_frame.rb
# Created: 12/06/12
#
# (c) Michel Demazure <michel@demazure.com>

module JacintheReports
  module GuiQt
    # report panel for reporter report frame
    class ReportFrame < PrettyFrame
      NO_BLOW = 'Ne pas éclater'
      SIZE = 15
      slots :create_report

      def initialize(recipe)
        super('Rapport')
        @recipe = recipe
        set_color(YELLOW)
        @layout.add_widget(Qt::Label.new('Colonne à éclater'))
        @field = PrettyCombo.new(20)
        @field.enabled = true
        @layout.add_widget(@field)
        @layout.add_widget(Qt::Label.new('Titre du rapport'))
        @title = Qt::LineEdit.new
        @layout.add_widget(@title)
        @button = Qt::PushButton.new('Créer')
        @layout.add_widget(@button)
        @layout.add_widget(HLine.new)
        @save_and_show = SaveAndShowLayout.new(:vertical, @recipe)
        @layout.addLayout(@save_and_show)
        @layout.insert_spacing(5, 45)
        @layout.insert_spacing(7, 15)
        @layout.addStretch
        connect_signals
      end

      def connect_signals
        connect_button(@button, :create_report)
        console_connect(@save_and_show)
      end

      def build_panel
        list = [NO_BLOW] + @recipe.columns.values
        blow = @recipe.exporting[:blow]
        @field.build_with_list(list, blow)
        @title.text = @recipe.exporting[:title] || default_title
      end

      def default_title
        title = @recipe.db_table.to_s.capitalize
        title += 's' unless title[-1] == 's'
        title
      end

      def create_report
        title = @title.text.force_encoding('utf-8')
        @recipe.exporting[:title] = title
        report = process_with(title)
        return unless report
        @save_and_show.load_report(report)
        show_html(report.html_sample)
        console_message "Rapport '#{title}' créé, nombre de lignes #{report.size} au total"
      end

      def process_with(title)
        col = @field.currentText
        @recipe.exporting[:blow] = col
        if col == NO_BLOW
          Reports::Report.new(@recipe.table_for_report, title)
        else
          process_and_blow_with(title, col)
        end
      end

      def process_and_blow_with(title, col)
        tables = @recipe.table_for_bundle(col)
        # FIXME: bad hack
        if tables.is_a?(Reports::Table)
          Reports::Report.new(tables, title + ' éclaté')
        elsif ReportFrame.to_blow?(tables.size)
          Reports::Bundle.new(tables, title + ' éclaté')
        else
          :internal_error
        end
      end

      def self.to_blow?(size)
        size < SIZE || Dialog.confirm("Eclater #{size} valeurs, vraiment ?")
      end
    end
  end
end
