#!/usr/bin/env ruby
# encoding: utf-8

# File: operation_frame.rb
# Created: 09/07/13
#
# (c) Michel Demazure <michel@demazure.com>

module JacintheReports
  module GuiQt
    # line for column operations panel
    class OperationLine < Qt::HBoxLayout
      ITEMS = Recipes::Operation::NAMES
      include Signals
      slots :field_changed, :operation_changed, :erase_selection
      signals 'changed( int )'

      def initialize(index, recipe)
        super()
        @recipe = recipe
        @index = index
        setContentsMargins(6, 1, 6, 1)
        @fields = FieldCombo.new(@recipe)
        add_widget(@fields)
        add_widget(Qt::Label.new('=>'))
        @entry = PrettyCombo.new(10)
        add_widget(@entry)
        @erase = Qt::PushButton.new(Icons.icon('standardbutton-cancel'), '')
        add_widget(@erase)
        addStretch
        connect_signals
      end

      def connect_signals
        connect(@fields, SIGNAL_ACTIVATED, self, SLOT(:field_changed))
        connect(@entry, SIGNAL_ACTIVATED, self, SLOT(:operation_changed))
        connect_button(@erase, :erase_selection)
      end

      def field_changed
        @fields.no_field ? erase_selection : build_values
      end

      def clear_entry
        @entry.clear
        operation_changed
      end

      def open
        @entry.clear
        @entry.enabled = false
        @fields.build_with(FieldCombo::FIRSTLINE)
      end

      def build_with(field = FieldCombo::FIRSTLINE, index = 0)
        ret = @fields.build_with(field)
        if ret
          @entry.enabled = true
          @entry.addItems(ITEMS)
          @entry.current_index = index
        end
      end

      def build_values
        build_with(@fields.currentText.to_sym)
        operation_changed
      end

      def erase_selection
        @fields.currentIndex = 0
        clear_entry
        @entry.enabled = false
      end

      def operation_changed
        emit(changed(@index))
      end

      def selection
        [@fields.currentText.to_sym, @entry.current_index]
      end
    end

    # column operations panel of reporter
    class OperationFrame < PrettyFrame
      LINES = 6

      slots :fetch_selections

      def initialize(recipe)
        super('OPERATIONS')
        @selections = []
        @recipe = recipe
        @index = -1
        @lines = []
        [@recipe.operations.size + 1, LINES].max.times { add_line }
      end

      def add_line
        @lines << new_line
      end

      def new_line
        @index += 1
        line = OperationLine.new(@index, @recipe)
        @layout.addLayout(line)
        connect(line, SIGNAL('changed( int )'), self, SLOT(:fetch_selections))
        line.open
        line
      end

      def fetch_selections
        @selections = @lines.map(&:selection).reject do |field, _|
          field == FieldCombo::FIRSTLINE.to_sym
        end
      end

      def update_recipe
        @recipe.operations = @selections
        @recipe.add_extra_fields(@selections.map(&:first))
        add_line if @lines.size == @selections.size
      end

      def build_panel
        indx = 0
        @recipe.operations.each do |field, index|
          @lines[indx].build_with(field.to_s, index)
          indx += 1
        end
        (indx...@lines.size).to_a.each { |ind| @lines[ind].open }
        fetch_selections
      end
    end
  end
end
