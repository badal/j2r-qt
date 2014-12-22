#!/usr/bin/env ruby
# encoding: utf-8

# File: tiers_audit_frame.rb
# Created: 27/06/12
#
# (c) Michel Demazure <michel@demazure.com>

module JacintheReports
  module GuiQt
    # frame for the audit part of the auditer
    class TiersAuditFrame < PrettyFrame
      include Signals

      REGEXP = /^(\d+)/

      HINT_SLOT = 'hint_given(const QString&)'
      slots HINT_SLOT, :tiers_selected, :show_audit
      slots :new_list, :add_to_list, :load_list, :save_list, :return

      # @param [String] initial_hint string given
      def initialize(initial_hint = nil)
        super('TIERS')
        set_color(YELLOW)
        @layout.add_widget(Qt::Label.new('<b>Audit des tiers</b>'))
        build_audit_part
        @layout.add_widget(HLine.new)
        @layout.add_widget(Qt::Label.new('<b>Liste de tiers</b>'))
        build_list_part
        @layout.insert_spacing(7, 40)
        @layout.addStretch
        build_panel(initial_hint)
      end

      def build_audit_part
        @layout.add_widget(Qt::Label.new('Numéro ou fragment du nom'))
        @hint = Qt::LineEdit.new
        @hint.frame = true
        @hint.enabled = true
        @layout.add_widget(@hint)
        connect(@hint, SIGNAL('textChanged(const QString&)'), self, SLOT(HINT_SLOT))
        connect(@hint, SIGNAL('returnPressed()'), self, SLOT(:show_audit))
        @msg = Qt::Label.new
        @layout.add_widget(@msg)
        @select = PrettyCombo.new(30)
        @select.enabled = true
        @layout.add_widget(@select)
        connect(@select, SIGNAL_ACTIVATED, self, SLOT(:tiers_selected))
        audit_button = Qt::PushButton.new('Audit complet')
        connect_button(audit_button, :show_audit)
        @layout.add_widget(audit_button)
      end

      def build_list_part
        buttons = Qt::FormLayout.new
        @layout.addLayout(buttons)
        new_button = Qt::PushButton.new('Nouvelle liste')
        connect_button(new_button, :new_list)
        add_button = Qt::PushButton.new(' Ajouter à la liste')
        connect_button(add_button, :add_to_list)
        buttons.addRow(new_button, add_button)
        load_button = Qt::PushButton.new('Charger une liste')
        connect_button(load_button, :load_list)
        save_button = Qt::PushButton.new('Enregistrer la liste')
        connect_button(save_button, :save_list)
        buttons.addRow(load_button, save_button)
      end

      def build_panel(arg = nil)
        @hint.text = arg || ''
        hint_given(arg || '*')
        @list = []
      end

      def hint_given(hint)
        show_html('')
        @searcher ||= J2R::Audits::TiersSearcher.new
        @selection_list = @searcher.search(hint)
        @select.clear
        @select.addItems(@selection_list.map { |item| item[1] })
        size = @selection_list.size
        case size
        when 0
          @msg.text = 'Pas de solution'
        when 1
          tiers_selected
        else
          @msg.text = "Choisir parmi #{size}"
        end
      end

      def tiers_selected
        index = @select.current_index
        tiers = @selection_list[index]
        @tiers_name = tiers[1]
        @tiers_id = tiers[0].to_i
        @msg.text = "Tiers #{@tiers_id} sélectionné"
        show_html(@searcher.extract(@tiers_id))
      end

      def tiers_list
        @list.map { |line| line[REGEXP] }
      end

      def show_audit
        if @tiers_id
          @searcher.show_audit(@tiers_id)
          build_panel
        else
          console_message('Pas de tiers sélectionné')
        end
      end

      def new_list
        @list = []
        console_message('Liste vide')
      end

      def add_to_list
        if @tiers_id
          @list << "#{@tiers_id} #{@tiers_name}"
          @list = @list.uniq.sort
          console_message("#{@list.size} tiers sélectionné(s)")
        else
          console_message('Pas de tiers à ajouter')
        end
      end

      def load_list
        files = 'Fichiers textes (*.txt);;Ficheirs csv (*.csv)'
        filename = Qt::FileDialog.getOpenFileName(self, 'Charger une liste', User.lists, files)
        return unless filename
        filename = filename.force_encoding('utf-8')
        encoding = File.extname(filename) == '.csv' ? J2R.system_csv_encoding : 'utf-8'
        lines = File.readlines(filename, encoding: encoding)
        @list = lines.map do |line|
          line[REGEXP]
        end.compact.sort.uniq
        console_message "Liste chargée, #{@list.size} tiers"
      end

      def save_list
        filename = File.join(User.lists, 'list.txt')
        path = Dialog.ask_save_file(self, filename)
        if path
          File.open(path.force_encoding('utf-8'), 'w:utf-8') { |file| file.puts @list }
          console_message 'Liste enregistrée'
        else
          console_message 'Annulé'
        end
      end
    end
  end
end
