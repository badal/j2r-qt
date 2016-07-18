#!/usr/bin/env ruby
# encoding: utf-8

# File: ip_manager_central_widget.rb
# Created: 26 june 2016
#
# (c) Michel Demazure <michel@demazure.com>

# script methods for Jacinthe Management
module JacintheReports
  module GuiQt
    # Central widget for IP ranges management
    class IPManagerCentralWidget < Qt::Widget
      include Signals
      # version of the ip_manager
      VERSION = '0.1.0'
      # "About" specific message

      SIGNAL_EDITING_FINISHED = SIGNAL('editingFinished()')
      SIGNAL_COMBO_ACTIVATED = SIGNAL('activated(const QString&)')
      SIGNAL_CLICKED = SIGNAL(:clicked)

      def initialize
        super()
        @layout = Qt::VBoxLayout.new(self)
        build_layout
        load_ip_table
      end

      # @return [[Integer] * 4] geometry of mother window
      def geometry
        if Utils.on_mac?
          [100, 100, 600, 650]
        else
          [100, 100, 400, 500]
        end
      end

      # @return [String] name of manager specialty
      def subtitle
        'Management des plages IP'
      end

      # @return [Array<String>] about message
      def about
        [subtitle] + ABOUT
      end

      # build the layout
      def build_layout
        build_query_line
        build_edit_choice_line
        build_report_area
        @layout.add_stretch
      end

      # build the corresponding part
      def build_query_line
        box = Qt::HBoxLayout.new
        @layout.add_layout(box)
        box.add_widget(Qt::Label.new('Plage à chercher : '))
        @query = Qt::LineEdit.new('')
        box.add_widget(@query)
        connect(@query, SIGNAL(:returnPressed)) { ask_find(@query.text) }
      end

      def build_edit_choice_line
        box = Qt::HBoxLayout.new
        @layout.add_layout(box)
        box.add_widget(Qt::Label.new('Editer :'))
        @edit_choice = Qt::ComboBox.new
        box.add_widget(@edit_choice)
        connect(@edit_choice, SIGNAL_COMBO_ACTIVATED) do
          @ip_list = @result[@edit_choice.current_index]
          start_edit
        end
      end

      # build the corresponding part
      def build_report_area
        @report = Qt::TextEdit.new('')
        @layout.add_widget(@report)
        @report.read_only = true
      end

      def load_ip_table
        @table = JacintheManagement::IP::IPTable.load
        report @table.report
        @table.invalid_report.each { |line| error line }
      end

      def ask_find(str)
        if JacintheManagement::IP::IPRange.new(str).valid?
          do_search(str)
        else
          report '----'
          error("plage #{str} non valide")
        end
      end

      def do_search(str)
        @result = @table.find(str)
        report "----\n#{str} : " + presentation(@result)
        @edit_choice.count.times { @edit_choice.remove_item(0) }
        build_edit_choice unless @result.empty?
      end

      def build_edit_choice
        @edit_choice.add_items(@result.map(&:report))
        @edit_choice.set_size_adjust_policy(0)
      end

      def start_edit(content = @ip_list)
        report "----\nEdition de la table du Tiers #{@ip_list.tiers_id}"
        @editor = IPEditor.new(content, self)
        connect(@editor, SIGNAL(:back)) { restore_selected }
        connect(@editor, SIGNAL(:accept)) { selected_changed }
        @editor.show
      end

      def restore_selected
      end

      def selected_changed
        new_table = JacintheManagement::IP::IPRangeList.load_from_string(@editor.text)
        @editor.close
        error_table = new_table.check
        if error_table
          manage_error(error_table)
        else
          do_save(new_table)
        end
      end

      def do_save(new_table)
        answer= new_table.save(@ip_list.tiers_id)
        if answer
          report("Modification effectuée pour le tiers #{@ip_list.tiers_id}")
          load_ip_table
        else
          error("Erreur SQL, modification non faite")
        end
      end

      def manage_error(error_table)
        error 'Table incorrecte !'
        error_table.tiers_id = @ip_list.tiers_id
        start_edit(error_table)
      end

      def presentation(result)
        return 'pas de solution' if result.empty?
        (["#{result.size} solutions"] + result.map(&:report)).join("\n")
      end

      # show an report message
      # @param [String] message message to show
      def report(message)
        @report.append(message.to_s)
      end

      # show an error message
      # @param [String] message message to show
      def error(message)
        @report.append('<font color=red><b>' 'ERREUR</b> : </font> ' + message)
      end

      # WARNING: overrides the common one, useless in this case
      def update_values
      end

      # HTML help file
      #   HELP_FILE = File.expand_path('manager.html/#coll', Core::HELP_DIR)

      # Slot: open the help file
      def help
        return
        url = Qt::Url.new("file:///#{HELP_FILE}")
        p url
        Qt::DesktopServices.openUrl(url)
      end
    end
  end
end
