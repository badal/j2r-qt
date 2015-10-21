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
      MAX_SIZE = 800

      slots :purge, 'sort_column(int)', :save

      attr_accessor :state

      def initialize(table, parent)
        super(parent)
        @table = table
        @state = :saved
        rows = table.size - 1
        cols = table.first.size
        set_row_count(rows)
        set_column_count(cols)
        set_headers
        fill_with(table)
        set_sizes
      end

      def set_headers
        header_view = Qt::HeaderView.new(Qt::Horizontal)
        header_view.setClickable(true)
        setHorizontalHeader(header_view)
        connect(header_view, SIGNAL('sectionDoubleClicked(int)'),
                self, SLOT('sort_column(int)'))
      end

      def fill_with(table)
        labels = table.first
        first_labels = JacintheManagement::Selectors::Selector::FIRST_LABELS
        labels[0...first_labels.size] = first_labels
        setHorizontalHeaderLabels(labels)
        table.drop(1).each_with_index do |line, row|
          line.each_with_index do |item, col|
            set_item(row, col, Qt::TableWidgetItem.new(item))
          end
        end
      end

      def set_sizes
        w = column_count.times.reduce(50) do |acc, i|
          acc + columnWidth(i)
        end
        h = row_count.times.reduce(0) do |acc, i|
          acc + rowHeight(i)
        end
        set_minimum_width(w < MAX_SIZE ? w : MAX_SIZE)
        set_minimum_height(h < MAX_SIZE ? h : MAX_SIZE)
      end

      def purge
        selection_model = selectionModel
        list = selection_model.selected_rows.map(&:row)
        list.reverse.each do |row|
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

      signals :back, :accept

      QUIT_MSG = [
          'La modification que vous avez faite',
          'n\'a pas été acceptée'
      ]

      def initialize(table)
        super()
        self.window_title = 'Nettoyeur de table'

        @table = table

        layout = Qt::VBoxLayout.new(self)
        horiz = Qt::HBoxLayout.new
        layout.add_layout(horiz)
        purge_button = Qt::PushButton.new('Nettoyer', self)
        horiz.add_widget(purge_button)

        save_button = Qt::PushButton.new('Accepter le nettoyage et fermer', self)
        horiz.add_widget(save_button)

        @tbl = JTable.new(table, self)
        layout.add_widget(@tbl)

        connect(purge_button, SIGNAL_CLICKED, @tbl, SLOT(:purge))
        connect(save_button, SIGNAL_CLICKED) do
          @tbl.state = :saved
          emit(accept)
        end
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
