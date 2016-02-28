#!/usr/bin/env ruby
# encoding: utf-8

# File: mailing_frame.rb
# Created: 27/06/12
#
# (c) Michel Demazure <michel@demazure.com>

module JacintheReports
  module GuiQt
    # common mailing panel
    class MailingFrame < PrettyFrame
      USAGES = []
      J2R::UsageAdresse.each do |usg|
        USAGES[usg.id - 1] = usg.usage_adresse_nom
      end

      ETATS = []
      J2R::EtatTiers.each do |etat|
        ETATS[etat.id - 1] = etat.etat_tiers_nom
      end

      ZONES = ['Toutes zones']
      J2R::ZonePostePays.each do |zone|
        ZONES[zone.id] = zone.zone_poste_pays_nom
      end

      MAILING_PROCESSORS = { 'Adresses postales' => :postal_adresses,
                             'Adresses postales (AFNOR)' => :afnor_adresses,
                             'Adresses mail' => :email_adresses,
                             'Adresses sans mail' => :no_email_adresses,
                             'Liste non filtrée' => :simple_list }

      MAILING_FORMATS = MAILING_PROCESSORS.keys

      slots :build_output_list, :save_list, :show_list

      attr_accessor :source
      # source must answer  source.tiers_list
      def initialize(source)
        super('Routage')
        set_color(YELLOW)
        @source = source
        connect_enabling(source) if defined?(ParametrizerFrame) &&
                                    source.is_a?(JacintheReports::GuiQt::ParametrizerFrame)
        build_top
        @layout.add_widget(HLine.new)
        build_bottom
        @layout.insertSpacing(8, 15)
        @layout.addStretch
        enable_choices(false)
      end

      def build_top
        @usage = selection_widget('Usage', USAGES)
        @state = selection_widget('Etat', ETATS)
        @zone = selection_widget('Zone', ZONES)
        button = Qt::PushButton.new('Créer')
        connect_button(button, :build_output_list)
        @layout.add_widget(button)
      end

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
          name = 'routage-' + Reports::CommonFormatters.time_stamp + '.csv'
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
