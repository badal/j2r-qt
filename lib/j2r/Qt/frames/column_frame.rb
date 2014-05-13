#!/usr/bin/env ruby
# encoding: utf-8

# File: column_frame.rb
# Created: 06/06/12
#
# (c) Michel Demazure <michel@demazure.com>

module JacintheReports
  module GuiQt
    # line for the column editing panel
    class ColumnLine < ModelDataLine
      slots :field_selected, :name_selected

      def initialize(index, recipe)
        super()

        @index = index
        @recipe = recipe

        @fields = FieldCombo.new(@recipe)
        connect(@fields, SIGNAL_ACTIVATED, self, SLOT(:field_selected))
        add_widget(@fields)

        @entry = Qt::LineEdit.new
        @entry.frame = true
        @entry.enabled = false
        add_widget(@entry)
        connect(@entry, SIGNAL('editingFinished()'), self, SLOT(:name_selected))
        build_buttons
      end

      def build_with_selection(field = FieldCombo::FIRSTLINE, name = '')
        ret = @fields.build_with(field)
        @entry.enabled = ret
        @entry.text = name
      end

      def field_selected
        if @fields.no_field
          _erase
        else
          @entry.enabled = true
          @entry.text = @fields.currentText
          update_selection
        end
      end

      def name_selected
        update_selection
      end

      def erase_selection
        @fields.currentIndex = 0
        @entry.text = nil
        @entry.enabled = false
      end

      # WARNING : here a force encoding !!!
      def selection
        [@fields.currentText, @entry.text.force_encoding('utf-8')]
      end
    end

    # column editing panel
    class ColumnFrame < ModelDataFrame
      LINES = 6

      def initialize(recipe)
        super(recipe, recipe.columns, 'COLONNES', LINES)
      end

      def new_line(indx)
        ColumnLine.new(indx, @recipe)
      end

      def empty_panel_line
        [FieldCombo::FIRSTLINE, '']
      end

      def changed(indx)
        list = @lines.map { |line| line.selection.first }
        list = list.select { |field| field != FieldCombo::FIRSTLINE }
        list == list.uniq ? update_recipe : @lines[indx].erase_selection
      end

      def update_recipe
        @panel = @lines.map(&:selection)
        cols = @recipe.columns
        cols.clear
        @panel.each do |(field, name)|
          next if field == FieldCombo::FIRSTLINE || name.empty?
          cols[field.to_sym] = name
        end
        if @lines.size == cols.size
          add_line
          build_panel
        end
      end
    end
  end
end
