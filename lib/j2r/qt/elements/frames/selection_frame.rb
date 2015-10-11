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
      slots :build_list, :show_list, :execute
      signals :source_changed

      attr_accessor :selector

      def initialize
        @all_selectors = JacintheManagement::Selectors.all
        super('Sélection')
        set_color(YELLOW)
        build_top
        @layout.add_widget(HLine.new)
        build_center
        @layout.add_widget(HLine.new)
        build_bottom
        @layout.addStretch
        disable_all
      end

      CHOOSE = ['Choisir']

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
      end

      def build_bottom
        @execute_button = Qt::PushButton.new("Exécuter")
        @layout.add_widget(@execute_button)
        connect_button(@execute_button, :execute)
      end

      def disable_all
        [@parameter, @years, @build_button, @show_button, @execute_button].each do |item|
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
          init_html(@selector.description + '<hr>')
          show_years
          show_parameters
        end
      end

      def show_years
        years = @selector.years
        if years
          @years.enabled = true
          @years.build_with_list(years)
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
         # append_html('Choisissez l\'année') if @selector.years
          ask_build
        end
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
        if @selector.years
          'Choisissez l\'année et la valeur du paramètre'
        else
          'Choisissez la valeur du paramètre'
        end
      end

      def ask_parameter
        @build_button.enabled = false
        @show_button.enabled = false
        @execute_button.enabled =false
        append_html(choice_text)
      end

      def ask_build
        indx = @parameter.current_index - 1
        year = @years.current_index
        append_html(@selector.creation_message(indx, year))
        @build_button.enabled = true
        @show_button.enabled = false
        @execute_button.enabled = false
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
        year = @years.current_text
        size = @selector.build_tiers_list(@parameter.current_index - 1, year)
        msg = (size ? "Liste créée, #{size} tiers" : 'Pas de liste créée')
        init_html("<hr><b>#{msg}</b>")
        @show_button.enabled = true
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
          append_html('Vous pouvez voir et/ou router')
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
        coding = J2R.system_csv_encoding
        content = @selector.tiers_list.map { |line| line.to_s.chomp.gsub("\t", J2R::CSV_SEPARATOR) }
        path = J2R.to_temp_file('.csv', content, coding)
        J2R.open_file_command(path)
      end

      def execute
        # TODO: add return message
        ret = @selector.execute
        append_html("<b>#{ret}</b>")
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
