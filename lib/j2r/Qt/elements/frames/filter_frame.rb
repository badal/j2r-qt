#!/usr/bin/env ruby
# encoding: utf-8

# File: filter_frame.rb
# Created: 04/06/12
#
# (c) Michel Demazure <michel@demazure.com>

module JacintheReports
  module GuiQt
    # line for filter panel
    class FilterLine < Qt::HBoxLayout
      include Signals
      slots :field_changed, :update_selection, :keep, :no_keep, :erase_selection
      signals 'changed( int )'

      def initialize(index, recipe)
        super()
        @recipe = recipe
        @index = index
        setContentsMargins(6, 1, 6, 1)
        @fields = FieldCombo.new(@recipe)
        add_widget(@fields)
        add_and_connect_buttons
        @entry = ValueCombo.new(@recipe)
        add_widget(@entry)
        @erase = Qt::PushButton.new(Icons.icon('standardbutton-cancel'), '')
        add_widget(@erase)
        addStretch
        connect_signals
      end

      def add_and_connect_buttons
        group = Qt::ButtonGroup.new
        @select = Qt::RadioButton.new
        @select.text = 'Garder'
        @unselect = Qt::RadioButton.new
        @unselect.text = 'Ôter'
        [@select, @unselect].each do |button|
          group.add_button(button)
          add_widget(button)
          button.auto_exclusive = false
        end
      end

      def connect_signals
        connect_button(@select, :keep)
        connect_button(@unselect, :no_keep)
        connect(@fields, SIGNAL_ACTIVATED, self, SLOT(:field_changed))
        connect(@entry, SIGNAL_ACTIVATED, self, SLOT(:update_selection))
        connect_button(@erase, :erase_selection)
      end

      def field_changed
        if @fields.no_field
          erase_selection
        else
          update_selection # signaling for checking for duplication
          build_values
        end
      end

      def keep
        @keep = true
        build_values
      end

      def no_keep
        @keep = false
        build_values
      end

      def build_buttons
        @select.set_checked(@keep)
        @unselect.set_checked(!@keep)
      end

      def clear_entry
        @entry.clear
        update_selection
      end

      def open
        @entry.clear
        @entry.enabled = false
        @fields.build_with(FieldCombo::FIRSTLINE)
        @select.set_checked(false)
        @unselect.set_checked(false)
        @keep = false
      end

      def build_with(field = FieldCombo::FIRSTLINE, text = '', select = false)
        @keep = select
        build_buttons
        @entry.clear
        @entry.enabled = false
        ret = @fields.build_with(field) # side effect
        return unless ret
        @entry.addItem(text)
        @entry.enabled = true
      end

      def build_values
        return if @fields.no_field
        field = @fields.currentText
        # WARNING : next two lines because "possible_values", needs signaling
        @entry.joker
        update_selection
        build_buttons
        @entry.build_for(field)
        @entry.enabled = @select.checked || @unselect.checked
      end

      def erase_selection
        open
        update_selection
      end

      def update_selection
        emit(changed(@index))
      end

      def selection
        [@fields.currentText.to_sym, @entry.current_selection, @keep]
      end
    end

    # filter panel of reporter
    class FilterFrame < PrettyFrame
      LINES = 6

      slots 'changed( int )'

      def initialize(recipe)
        super('FILTRES')
        @recipe = recipe
        @index = -1
        @lines = []
        [@recipe.filters.size + 1, LINES].max.times { add_line }
      end

      def add_line
        @lines << new_line
      end

      def new_line
        @index += 1
        line = FilterLine.new(@index, @recipe)
        @layout.addLayout(line)
        connect(line, SIGNAL('changed( int )'), self, SLOT('changed( int )'))
        line.open
        line
      end

      def changed(indx)
        fetch_selections
        check ? update_recipe : @lines[indx].erase_selection
        update_recipe
        build_panel
      end

      def fetch_selections
        @selections = @lines.map(&:selection).reject do |line|
          line.first == FieldCombo::FIRSTLINE.to_sym
        end
      end

      def check
        positives = @selections.select { |line| line.last }.map(&:first).uniq
        sizes = positives.map do |positive|
          @selections.select { |line| line.first == positive }.size
        end
        sizes.all? { |size| size == 1 }
      end

      def update_recipe
        @recipe.filters = @selections
        add_line if @lines.size == @selections.size
      end

      def build_panel
        indx = 0
        @recipe.filters.each do |field, text, bool|
          @lines[indx].build_with(field.to_s, text.to_s, bool)
          indx += 1
        end
        (indx...@lines.size).to_a.each { |ind| @lines[ind].open }
        fetch_selections
      end
    end
  end
end
