#!/usr/bin/env ruby
# encoding: utf-8

# File: pretty_combo.rb
# Created: 10/06/12
#
# (c) Michel Demazure <michel@demazure.com>

module JacintheReports
  module GuiQt
    # common Jacinthe ComboBox model
    class PrettyCombo < Qt::ComboBox
      def initialize(size)
        super()
        self.enabled = false
        self.editable = true
        self.size_adjust_policy = Qt::ComboBox::AdjustToMinimumContentsLength
        self.minimum_contents_length = size
        self.frame = true
        set_fixed_size(sizeHint)
      end

      # WARNING keep camelCase !!!
      # noinspection RubyInstanceMethodNamingConvention
      def currentText # rubocop:disable MethodName
        super.force_encoding('utf-8')
      end

      def current_text
        currentText
      end

      def show_item(text)
        (0...count).to_a.each do |int|
          set_current_index(int) if item_text(int) == text
        end
      end

      def build_with_list(list, value = nil)
        clear
        addItems(list)
        indx = list.index(value) || 0
        set_current_index(indx)
      end
    end

    # common Jacinthe combo for choosing fields
    class FieldCombo < PrettyCombo
      FIRSTLINE = '__Choisir__'

      def initialize(recipe)
        super(30)
        self.enabled = true
        @recipe = recipe
      end

      # WARNING: return value for ColumnFrame
      def build_with(field = FIRSTLINE)
        clear
        field_list = @recipe.all_fields.map(&:to_s)
        field_list.select! { |name| name =~ /_id$/ } if field == :_id
        addItems([FIRSTLINE] + field_list)
        indx = field_list.index(field.to_s) || -1
        set_current_index(indx + 1)
        indx != -1
      end

      def no_field
        current_index == 0
      end
    end

    # common Jacinthe combo for choosing values
    class ValueCombo < PrettyCombo
      def initialize(recipe)
        super(30)
        self.enabled = false
        @recipe = recipe
      end

      def joker
        clear
        add_item(Recipes::JOKER)
        set_current_index(0)
      end

      def joker?
        current_text == Recipes::JOKER
      end

      def build_for(field)
        value_list = @recipe.possible_values(field.to_sym).map do |item|
          item.empty? ? Recipes::SQUARE : item
        end
        clear
        add_items([Recipes::JOKER] + value_list)
        self.enabled = true
      end

      def current_selection
        text = current_text
        case text
          when 'true'
            true
          when 'false'
            false
          else
            text
        end
      end
    end
  end
end
