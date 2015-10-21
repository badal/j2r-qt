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
      slots :build_list, :show_list, :save_list, :execute
      signals :source_changed

      attr_accessor :selector

      def initialize
        @all_selectors = JacintheManagement::Selectors.all
        super('Sélection')
        set_color(YELLOW)
        build_top
        #  @layout.add_widget(HLine.new)
        build_center
        @layout.add_widget(HLine.new)
        build_bottom
        @layout.addStretch
        disable_all
      end

      CHOOSE = ['-- Choisir --']

      def build_top
        names = @all_selectors.map(&:name)
        @criterion = selection_widget('Critère', CHOOSE + names)
        @years = selection_widget('Année', [])
        @parameter = selection_widget('Paramètre', [])
        connect(@criterion, SIGNAL_ACTIVATED) { choice_made }
        connect(@years, SIGNAL_ACTIVATED) { year_fixed }
        connect(@parameter, SIGNAL_ACTIVATED) { parameter_fixed }
      end

      def build_center
        @build_button = Qt::PushButton.new('Créer la sélection')
        @layout.add_widget(@build_button)
        connect_button(@build_button, :build_list)
        @show_button = Qt::PushButton.new('Voir la sélection')
        @layout.add_widget(@show_button)
        connect_button(@show_button, :show_list)
        @save_button = Qt::PushButton.new('Enregistrer')
        @layout.add_widget(@save_button)
        connect_button(@save_button, :save_list)
      end

      def build_bottom
        @execute_button = Qt::PushButton.new('Exécuter')
        @layout.add_widget(@execute_button)
        connect_button(@execute_button, :execute)
      end

      def disable_all
        [@parameter, @years, @build_button, @show_button, @save_button, @execute_button].each do |item|
          item.enabled = false
        end
      end

      def selection_not_done
        @show_button.enabled = false
        @save_button.enabled = false
      end

      def selection_done
        @show_button.enabled = true
        @save_button.enabled = true
      end

      def choice_made
        indx = @criterion.current_index
        if indx == 0
          @selector = nil
          disable_all
        else
          @selector = @all_selectors[indx - 1]
          init_html(@selector.description.to_s + '<hr>')
          show_years
          show_parameters
        end
      end

      def show_years
        years = @selector.year_choice
        if years
          @years.enabled = true
          @years.build_with_list(years.map(&:to_s))
          indx = years.index { |item| item[Time.now.year.to_s] }
          @years.set_current_index(indx) if indx
        else
          @years.enabled = false
          @years.clear
        end
      end

      def show_parameters
        parameters = @selector.parameter_list
        if parameters && !parameters.empty?
          @parameter.build_with_list(CHOOSE + parameters.map(&:to_s))
          @parameter.enabled = true
          ask_parameter
        else
          @parameter.clear
          @parameter.enabled = false
          ask_build
        end
      end

      def values
        [@parameter.current_index - 1, @years.current_text]
      end

      def year_fixed
        ask_build if !@selector.parameter_list || @parameter.current_index > 0
      end

      def parameter_fixed
        indx = @parameter.current_index
        if indx <= 0
          ask_parameter
          return
        else
          ask_build
        end
      end

      def choice_text
        if @years.enabled
          'Choisissez l\'année et la valeur du paramètre'
        else
          'Choisissez la valeur du paramètre'
        end
      end

      def ask_parameter
        @build_button.enabled = false
        selection_not_done
        @execute_button.enabled = false
        append_html(choice_text)
      end

      def ask_build
        append_html(@selector.creation_message(values))
        @build_button.enabled = true
        selection_not_done
        @execute_button.enabled = false
      end

      def build_list
        size = @selector.build_tiers_list(values)
        if size == -1
          append_html('<b>Sélection vide.</b>')
         else
          msg = (size ? "Liste créée, #{size} tiers" : 'Pas de liste créée')
          init_html("<hr><b>#{msg}</b>")
          selection_built
        end
      end

      def selection_built
        @selected = @selector.tiers_list.map do |line|
          line.chomp.split("\t")
        end
        selection_done
        emit(source_changed)
        ask_route
      end

      def ask_route
        cmd = @selector.command_name
        if cmd
          @execute_button.enabled = true
          @execute_button.set_text(cmd)
          append_html(@selector.command_message)
        else
          @execute_button.enabled = false
          append_html('Vous pouvez voir(éditer) et/ou enregistrer et/ou router')
        end
      end

      # send the text to the show area (overrides)
      # @param [String] html text to show
      def init_html(html)
        @html = html
        show_html(html)
      end

      # send the text to the show area (append)
      # @param [String] html text to append
      def append_html(html)
        @html += '<br>' + html
        @html.gsub!(/<br><hr>|<hr><br>/, '<hr>')
        show_html(@html)
      end

      def show_list
        @initial = @selected.dup
        @editor = TableEditor.new(@selected)
        connect(@editor, SIGNAL(:back)) { restore_selected }
        connect(@editor, SIGNAL(:accept)) { selected_changed }
        @editor.show
      end

      def restore_selected
        @selected = @initial
      end

      def selected_changed
        size = @selected.size - 1
        msg = "Liste modifiée, #{size} tiers"
        init_html("<hr><b>#{msg}</b>")
        @selector.tiers_list = @selected.map do |line|
          ([line[0].to_i] + line[1..-1]).join("\t")
        end
        @editor.close
        ask_route
      end

      def output_content
        @selected.map do |line|
          line.join(CSV_SEPARATOR)
        end.join("\n")
      end

      def save_list
        name = 'selection-' + Reports::CommonFormatters.time_stamp + '.csv'
        filename = File.join(User.lists, name)
        path = Dialog.ask_save_file(self, filename)
        message = path ? J2R.to_csv_file(path, output_content) : 'Annulé'
        console_message message
      end

      def execute
        ret = @selector.execute(values)
        append_html("<b>#{ret}</b>")
      end
    end
  end
end
