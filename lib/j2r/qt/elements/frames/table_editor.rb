#!/usr/bin/env ruby
# encoding: utf-8

# File: table_editor.rb
# Created: 14/10/15
#
# (c) Michel Demazure <michel@demazure.com>

module JacintheReports
  module GuiQt
    # ad-hoc editor for the selector tool
    class JTable < Qt::TableWidget

      slots :purge, 'sort_column(int)', :save

      attr_accessor :state
      attr_reader :estimated

      def initialize(table, parent)
        super(parent)
        @table = table
        @state = :saved
        set_row_count(table.size - 1)
        set_column_count(table.first.size)
        fill_with(table)
        set_headers
      end

      def fill_with(table)
        labels = table.first
        setHorizontalHeaderLabels(labels)
        table.drop(1).each_with_index do |line, row|
          line.each_with_index do |item, col|
            set_item(row, col, Qt::TableWidgetItem.new(item))
          end
        end
      end

      def set_headers
        horizontal_header = Qt::HeaderView.new(Qt::Horizontal)
        horizontal_header.setClickable(true)
        setHorizontalHeader(horizontal_header)
        connect(horizontal_header, SIGNAL('sectionDoubleClicked(int)'),
                self, SLOT('sort_column(int)'))
        horizontal_header.set_resize_mode(Qt::HeaderView::ResizeToContents)
        @estimated = horizontal_header.length + 5 * column_count
      end

      def purge
        selection_model = selectionModel
        list = selection_model.selected_rows.map(&:row)
        list.reverse_each do |row|
          deleted_line = (0...column_count).to_a.map do |i|
            item(row, i).text.force_encoding('utf-8')
          end
          @table.reject! { |line| line == deleted_line }
          remove_row(row)
        end
        @state = :changed
      end

      def sort_column(int)
        sortByColumn(int, Qt::AscendingOrder)
      end
    end

    class TableEditor < Qt::Widget
      include Signals

      MAX_WIDTH = 1200

      signals :back, :accept

      QUIT_MSG = [
          'La modification que vous avez faite',
          'n\'a pas été acceptée'
      ]

      def initialize(table)
        super()
        self.window_title = 'Nettoyeur de table'
        layout = Qt::VBoxLayout.new(self)
        purge_button, save_button = add_buttons(layout)
        @tbl = JTable.new(table, self)
        layout.add_widget(@tbl)
        fix_size
        connect(purge_button, SIGNAL_CLICKED, @tbl, SLOT(:purge))
        connect(save_button, SIGNAL_CLICKED) do
          @tbl.state = :saved
          emit(accept)
        end
      end

      def add_buttons(layout)
        horiz = Qt::HBoxLayout.new
        layout.add_layout(horiz)
        purge_button = Qt::PushButton.new('Effacer les ligne sélectionnées', self)
        horiz.add_widget(purge_button)
        save_button = Qt::PushButton.new('Accepter le nettoyage et fermer', self)
        horiz.add_widget(save_button)
        horiz.add_stretch
        return purge_button, save_button
      end

      def fix_size
        tbl_estimated = @tbl.estimated
        minimal = tbl_estimated < MAX_WIDTH ? tbl_estimated : MAX_WIDTH
        set_minimum_width(minimal)
        resize(@tbl.height, minimal)
      end

      # WARNING needs camelCase form !!!
      # noinspection RubyInstanceMethodNamingConvention
      def closeEvent(event) # rubocop:disable MethodName
        case @tbl.state
        when :saved
          return
        when :changed
          if Dialog.confirm(QUIT_MSG.join("\n"))
            emit(back)
            event.accept
          else
            event.ignore
          end
        end
      end
    end
  end
end
