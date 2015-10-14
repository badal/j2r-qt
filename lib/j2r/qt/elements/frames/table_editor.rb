# 00!/usr/bin/env ruby
# encoding: utf-8

# File: table_editorrb
# Created: 14/10/15
#
# (c) Michel Demazure <michel@demazure.com>

module JacintheReports
  module GuiQt
    # line for sort panel

    class JTable < Qt::TableWidget
      slots :purge, 'sort_column(int)', :save

      def initialize(table, parent)
        super(parent)
        set_headers
        rows = table.size
        cols = table.first.size
        set_row_count(rows)
        set_column_count(cols)
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
        table.each_with_index do |line, row|
          line.each_with_index do |item, col|
            itm = Qt::TableWidgetItem.new(item)
            set_item(row, col, itm)
          end
        end
      end
      #
      # def add_checkboxes(column)
      #   @checkboxes = []
      #   row_count.times.each do |row|
      #     @checkboxes[row] = Qt::CheckBox.new
      #     set_cell_widget(row, column, @checkboxes[row])
      #   end
      #   resizeColumnToContents(column)
      # end

      def set_sizes
        w = column_count.times.reduce(50) do |acc, i|
          acc + columnWidth(i)
        end
        h = row_count.times.reduce(0) do |acc, i|
          acc + rowHeight(i)
        end
        set_minimum_width(w < 600 ? w : 600)
        set_minimum_height(h < 600 ? h : 600)
      end

      def purge
        selection_model = selectionModel
        list = selection_model.selected_rows.map(&:row)
        list.reverse_each { |i| remove_row(i) }
      end

      def sort_column(int)
        sortByColumn(int, Qt::AscendingOrder)
      end

      def save
        puts "save"
      end
   end

    class TableEditor < Qt::Widget
      include Signals

      def initialize(table)
        super()
        self.window_title = 'Editeur de table'

        layout = Qt::VBoxLayout.new(self)
        horiz = Qt::HBoxLayout.new
        layout.add_layout(horiz)

        purge_button = Qt::PushButton.new('nettoyer', self)
        horiz.add_widget(purge_button)

        save_button = Qt::PushButton.new('Enregistrer', self)
        horiz.add_widget(save_button)

        tbl = JTable.new(table, self)

        layout.add_widget(tbl)

        connect(purge_button, SIGNAL_CLICKED, tbl, SLOT(:purge))
        connect(save_button, SIGNAL_CLICKED, tbl, SLOT(:save))
      end
    end
  end
end
