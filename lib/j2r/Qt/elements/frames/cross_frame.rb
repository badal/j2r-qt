#!/usr/bin/env ruby
# encoding: utf-8

# File: cross_frame.rb
# Created: 27/06/12
#
# (c) Michel Demazure <michel@demazure.com>

module JacintheReports
  module GuiQt
    # cross reporting panel
    class CrossFrame < PrettyFrame
      slots :update_cross, :cross

      def initialize(recipe)
        extend Enabling
        super('Tableau croisé')
        set_color(YELLOW)
        @recipe = recipe
        build_layout
        connect_signals
      end

      def build_layout
        @layout.add_widget(Qt::Label.new('Lignes'))
        @lines = FieldCombo.new(@recipe)
        @layout.add_widget(@lines)
        @layout.add_widget(Qt::Label.new('Colonnes'))
        @columns = FieldCombo.new(@recipe)
        @layout.add_widget(@columns)
        @cross = Qt::PushButton.new('Créer')
        @layout.add_widget(@cross)
        @layout.add_widget(HLine.new)
        @left = ExportLayout.new(:vertical)
        @layout.addLayout(@left)
        @layout.insertSpacing(5, 45)
        @layout.insertSpacing(7, 15)
        @layout.addStretch
      end

      def connect_signals
        [@lines, @columns].each do |combo|
          connect(combo, SIGNAL_ACTIVATED, self, SLOT(:update_cross))
        end
        connect_button(@cross, :cross)
        connect_enabling(@recipe)
      end

      def build_panel
        exporting = @recipe.exporting
        @lines.build_with(exporting[:lines])
        @columns.build_with(exporting[:columns])
        update_cross
      end

      def lines_and_columns
        lines, columns = [@lines, @columns].map(&:currentText)
        exporting = @recipe.exporting
        exporting[:lines] = lines unless @lines.no_field
        exporting[:columns] = columns unless @columns.no_field
        [lines, columns]
      end

      def update_cross
        lines, columns = lines_and_columns
        incorrect = @lines.no_field || @columns.no_field || lines == columns
        @cross.enabled = !incorrect
      end

      def cross
        lines, columns = [@lines, @columns].map { |combo| combo.currentText.to_sym }
        console_message "Tableau croisé ; lignes : #{lines}; colonnes : #{columns}"
        cross_table = @recipe.build_table([lines, columns]).cross_table(lines, columns)
        report = Reports::Report.new(cross_table, 'Tableau croisé')
        @left.load_report(report)
        emit(ask_show_html(cross_table.doc_for_html))
      end
    end
  end
end
