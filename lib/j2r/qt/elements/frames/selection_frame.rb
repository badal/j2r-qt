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
      slots :build_list
      signals :list_changed

      attr_accessor :selector

      def initialize

        @all_selectors = Selector.all
        super('Sélection')

        set_color(YELLOW)
        build_top
        @layout.add_widget(HLine.new)
        build_bottom
        @layout.insertSpacing(8, 15)
        @layout.addStretch
        #  enable_choices(false)
      end

      CHOOSE = ['Choisir']

      def build_top
        names = @all_selectors.map(&:name)
        @criterion = selection_widget('Critère', CHOOSE + names)
        @parameter_one = selection_widget('Paramètre 1', [])
        @parameter_two = selection_widget('Paramètre 2', [])
        # @state = selection_widget('Etat', ETATS)
        # @zone = selection_widget('Zone', ZONES)
        connect(@criterion, SIGNAL_ACTIVATED) { choice_made }
        connect(@parameter_one, SIGNAL_ACTIVATED) { parameter_fixed(1) }
        connect(@parameter_two, SIGNAL_ACTIVATED) { parameter_fixed(2) }
      end

      def build_bottom
        @button = Qt::PushButton.new('Créer')
        @layout.add_widget(@button)
        connect_button(@button, :build_list)
      end

      def choice_made
        @selector = @all_selectors[@criterion.current_index - 1]
        show_html(@selector.text)
        show_parameters
      end

      def show_parameters
        parameters = @selector.parameter_list
        return if parameters.empty?
        @parameter_one.build_with_list(CHOOSE + parameters)
      end

      def parameter_fixed(indx)
        show_html(@parameter_one.current_text)
      end

      def selection_widget(label, items)
        @layout.add_widget(Qt::Label.new(label))
        combo = PrettyCombo.new(20)
        combo.enabled = true
        combo.editable = false
        combo.addItems(items)
        @layout.add_widget(combo)
        combo
      end

      def build_list
        return unless check_criterion
        return unless check_parameter
        size = @selector.build_tiers_list
        msg = size ? "Liste crée, #{size} tiers" : 'Pas de liste créée'
        console_message(msg)
        emit(list_changed)
      end

      def check_criterion
        if @selector
          true
        else
          console_message('Choisir un critère')
          false
        end
      end

      def check_parameter
        count = @parameter_one.count
        if count == 0 || @parameter_one.current_index > 0
          true
        else
          console_message('Choisir un paramètre')
          false
        end
      end

    end
  end
end
__END__
      def build_bottom
        @format = selection_widget('Format', MAILING_FORMATS)
        buttons = Qt::HBoxLayout.new
        @layout.addLayout(buttons)
        @save_list = Qt::PushButton.new(Icons.icon('standardbutton-save'), 'Enregistrer ')
        buttons.add_widget(@save_list)
        @show_list = Qt::PushButton.new(Icons.icon('standardbutton-open'), 'Ouvrir')
        buttons.add_widget(@show_list)
        connect_button(@save_list, :save_list)
        connect_button(@show_list, :show_list)
      end

      def enable_choices(bool)
        [@save_list, @show_list, @format].each do |widget|
          widget.enabled = bool
        end
      end

      # @param [Array] tiers_list list of tiers_id
      # @return [Array<J2R::VueAdresse>] list of vue_adresse records
      def address_list(tiers_list)
        params = { usage: USAGES.index(@usage.currentText) + 1,
                   etat_tiers: ETATS.index(@state.currentText) + 1,
                   zone: ZONES.index(@zone.currentText) }
        Jaccess::MailingList.new(tiers_list, params)
      end

      def build_output_list
        tiers_list = @source.tiers_list
        if tiers_list
          @mailing_list = address_list(tiers_list)
          console_message "Listes : #{tiers_list.size} tiers, #{@mailing_list.size} adresse(s)"
          show_html(@mailing_list.show_table.sample_for_html(5))
          enable_choices(true)
        else
          console_message 'Pas de liste de tiers'
          enable_choices(false)
        end
      end

      def output_from(mailing_list)
        pattern = @format.currentText
        processor = MAILING_PROCESSORS[pattern]
        mailing_list.send(processor).map { |line| line.join(J2R::CSV_SEPARATOR) }
      end

      def if_content
        content = output_from(@mailing_list)
        if content && content.size != 0
          console_message "Liste de mailing : #{content.size} adresse(s)"
          yield content
        elsif content
          console_message 'Liste de mailing vide'
        else
          console_message 'Pas de liste de mailing'
        end
      end

      def save_list
        if_content do |content|
          name = 'routage' + Reports::CommonFormatters.time_stamp + '.csv'
          filename = File.join(User.lists, name)
          path = Dialog.ask_save_file(self, filename)
          message = path ? J2R.to_csv_file(path, content) : 'Annulé'
          console_message message
        end
      end

      def show_list
        if_content do |content|
          coding = J2R.system_csv_encoding
          path = J2R.to_temp_file('.csv', content, coding)
          J2R.open_file_command(path)
        end
      end
    end
  end
end
