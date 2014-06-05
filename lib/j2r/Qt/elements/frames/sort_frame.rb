#!/usr/bin/env ruby
# encoding: utf-8

# File: sort_frame.rb
# Created: 14/06/12
#
# (c) Michel Demazure <michel@demazure.com>

module JacintheReports
  module GuiQt
    # line for sort panel
    class SortLine < ModelDataLine
      ITEMS = %w(Aucun direct inverse)

      include Signals
      slots :field_changed, :sort_changed

      def initialize(index, recipe)
        super()
        @index = index
        @recipe = recipe
        @field = FieldCombo.new(@recipe)
        @sort = PrettyCombo.new(10)
        @sort.addItems(ITEMS)
        @command = nil
        add_widget(Qt::Label.new('Champ'))
        add_widget(@field)
        add_widget(Qt::Label.new('Tri à utiliser'))
        add_widget(@sort)
        connect(@field, SIGNAL_ACTIVATED, self, SLOT(:field_changed))
        connect(@sort, SIGNAL_ACTIVATED, self, SLOT(:sort_changed))
        build_buttons
        addStretch
      end

      def build_with_selection(field = FieldCombo::FIRSTLINE, direction = true)
        @field.build_with(field)
        init_sort(direction)
      end

      def init_sort(direct = true)
        if @field.no_field
          @sort.currentIndex = 0
          @sort.enabled = false
        else
          @sort.currentIndex = direct ? 1 : 2
          @sort.enabled = true
        end
      end

      def field_changed
        @sort.currentIndex = 0
        @sort.enabled = true
      end

      def sort_changed
        return if @field.currentIndex == 0 || @sort.currentIndex == 0
        update_selection
      end

      def command
        [@field.currentText.to_sym, @sort.currentIndex]
      end
    end

    # sort panel of reporter
    class SortFrame < ModelDataFrame
      LINES = 3

      def initialize(recipe)
        super(recipe, recipe.sorts, 'TRIS', LINES)
      end

      def new_line(indx)
        SortLine.new(indx, @recipe)
      end

      def empty_panel_line
        [FieldCombo::FIRSTLINE, 0]
      end

      def changed(*)
        update_recipe
      end

      def update_recipe
        @panel = @lines.map(&:command)
        sorts = {}
        @panel.each do |field, direction|
          next unless direction && direction != 0
          sorts[field.to_sym] = direction == 1
        end
        @recipe.sorts = sorts
        return unless @lines.size == sorts.size
        add_line
        build_panel
      end
    end
  end
end
