#!/usr/bin/env ruby
# encoding: utf-8

# File: parametrizer_frame.rb
# Created: 12/06/12
#
# (c) Michel Demazure <michel@demazure.com>

require 'forwardable'

module JacintheReports
  module GuiQt
    # layout for filling parameter values of reporter
    class ParametrizerFrame < Qt::FormLayout
      ITEMS = OperationLine::ITEMS

      extend Forwardable
      include Signals

      signals :do_operations, :no_operations
      slots :value_changed

      def initialize(recipe)
        super()
        self.vertical_spacing = 0
        @recipe = recipe
        @runner = Recipes::Runner.new(recipe)
      end

      def_delegators :@recipe, :all_fields, :db_table, :columns, :exporting
      def_delegators :@runner, :table_for_report, :table_for_bundle, :build_table, :tiers_list

      def build_panel
        clear
        build_parameter_part
        build_operation_part
      end

      def build_parameter_part
        @values = []
        @parameters = []
        @recipe.filters.each do |parameter, value, bool|
          next unless value == Recipes::JOKER
          verb = bool ? 'Garder' : 'Ôter'
          value = build_parameter_row(" #{verb} : #{parameter}", parameter)
          @parameters << parameter
          @values << value
        end
      end

      def build_parameter_row(text, parameter)
        label = Qt::Label.new(text)
        value = ValueCombo.new(30)
        value_list = [Recipes::JOKER] + @recipe.possible_values(parameter)
        value.addItems(value_list)
        value.enabled = true
        connect(value, SIGNAL_ACTIVATED, self, SLOT(:value_changed))
        addRow(label, value)
        value
      end

      def build_operation_part
        @choices = []
        @recipe.operations.each do |field, indx|
          @choices << build_operation_row(field, indx)
        end
      end

      def build_operation_row(field, indx)
        label = Qt::Label.new("#{field} => #{ITEMS[indx]} : ?")
        choice = Qt::ComboBox.new
        choice.size_adjust_policy = Qt::ComboBox::AdjustToMinimumContentsLength
        choice.minimum_contents_length = 3
        choice.set_fixed_size(choice.sizeHint)
        choice.add_items(%w(non oui))
        connect(choice, SIGNAL_ACTIVATED, self, SLOT(:value_changed))
        add_row(label, choice)
        choice
      end

      def value_changed
        hsh = {}
        @parameters.zip(@values) do |parameter, value|
          hsh[parameter] = value.current_selection
        end
        @runner.parameter_values = hsh
        opers = @recipe.operations.zip(@choices).map do |oper, choice|
          Recipes::Operation.new(*oper) if  choice.current_index > 0
        end.compact
        @runner.operations = opers
        opers.empty? ? emit(no_operations) : emit(do_operations)
      end

      def clear
        (0...count).each do |indx|
          itemAt(indx).widget.hide
        end
      end
    end
  end
end
