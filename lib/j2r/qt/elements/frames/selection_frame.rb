#!/usr/bin/env ruby
# encoding: utf-8

# File: selection_frame.rb
# Created: 2/10/15
#
# (c) Michel Demazure <michel@demazure.com>

module JacintheReports
  module GuiQt
    # selection panel
    class SelectionFrame < PrettyFrame
      slots :build_list, :execute
      signals :source_changed

      attr_accessor :selector

      def initialize
        @all_selectors = Selectors.all
        super('Sélection')
        set_color(YELLOW)
        build_top
        @layout.add_widget(HLine.new)
        build_bottom
        @layout.insertSpacing(8, 15)
        @layout.addStretch
        disable_all
      end

      CHOOSE = ['Choisir']

      def build_top
        names = @all_selectors.map(&:name)
        @criterion = selection_widget('Critère', CHOOSE + names)
        @parameter = selection_widget('Paramètre', [])
        connect(@criterion, SIGNAL_ACTIVATED) { choice_made }
        connect(@parameter, SIGNAL_ACTIVATED) { parameter_fixed }
      end

      def build_bottom
        @build_button = Qt::PushButton.new('Créer la sélection')
        @layout.add_widget(@build_button)
        connect_button(@build_button, :build_list)
        @execute_button = Qt::PushButton.new('Exécuter')
        @layout.add_widget(@execute_button)
        connect_button(@execute_button, :execute)
      end

      def disable_all
        [@parameter, @build_button, @execute_button].each do |item|
          item.enabled = false
        end
      end

      def choice_made
        indx = @criterion.current_index
        if indx == 0
          @selector = nil
          disable_all
        else
          @selector = @all_selectors[indx - 1]
          show_html(@selector.description)
          show_parameters
        end
      end

      def show_parameters
        parameters = @selector.parameter_list
        if parameters && ! parameters.empty?
          @parameter.build_with_list(CHOOSE + parameters)
          @parameter.enabled = true
          @build_button.enabled = false
        else
          @parameter.clear
          @parameter.enabled = false
          @build_button.enabled = true
        end
      end

      def parameter_fixed
        indx = @parameter.current_index
        if indx > 0
          show_html(@selector.parameter_description(indx - 1))
        end
        @build_button.enabled = true
      end

      def selection_widget(label, items)
        @layout.add_widget(Qt::Label.new(label))
        combo = PrettyCombo.new(20)
        combo.enabled = true
        #  combo.editable = false
        combo.addItems(items)
        @layout.add_widget(combo)
        combo
      end

      def build_list
        size = @selector.build_tiers_list(@parameter.current_index - 1)
        msg = size ? "Liste créée, #{size} tiers" : 'Pas de liste créée'
        console_message(msg)
        emit(source_changed)
        if @selector.command?
          show_html(@selector.command_message)
          @execute_button.enabled = true
        end
      end

      def execute
        # TODO: add return message
        @selector.execute
      end

      # FIXME: useless
      def check(message)
        if yield
          true
        else
          console_message(message)
          false
        end
      end
    end
  end
end
