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
      # slots 'selected(int, int)'

      attr_accessor :state, :table
      attr_reader :estimated

      def initialize(table, parent)
        super(parent)
        @table = table
        @state = :saved
        set_row_count(table.row_count)
        set_column_count(table.column_count)
        fill_with(table)
        set_headers
        #  make_connection
      end

      # def make_connection
      #   connect(self, SIGNAL('cellClicked(int, int)'), self, SLOT('selected(int, int)'))
      # end
      #
      # def selected(row, col)
      #   puts "row: #{row}, col: #{col}, val: #{@table.rows[row][col]}, label: #{@labels[col]}"
      # end

      def fill_with(table)
        @labels = table.labels
        setHorizontalHeaderLabels(@labels)
        table.rows.each_with_index do |line, row|
          line.each_with_index do |content, col|
            set_item(row, col, non_editable_item(content))
          end
        end
      end

      def non_editable_item(content)
        item = Qt::TableWidgetItem.new(content)
        item.set_flags(item.flags & ~Qt::ItemIsEditable)
        item
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
        list.reverse_each { |row| remove_row(row) }
        fix_table
      end

      def sort_column(int)
        sortByColumn(int, Qt::AscendingOrder)
        fix_table
      end

      def saved
        @state = :saved
      end

      def fix_table
        rows = (0...row_count).to_a.map do |row|
          (0...column_count).to_a.map do |i|
            item(row, i).text.force_encoding('utf-8')
          end
        end
        @table = @table.fix_rows(rows)
        @state = :changed
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

      attr_reader :table
      def initialize(table)
        super()
        @table = table
        self.window_title = 'Nettoyeur de table'
        layout = Qt::VBoxLayout.new(self)
        purge_button, save_button = add_buttons(layout)
        @tbl = JTable.new(table, self)
        layout.add_widget(@tbl)
        fix_size
        connect(purge_button, SIGNAL_CLICKED, @tbl, SLOT(:purge))
        connect(save_button, SIGNAL_CLICKED) do
          @tbl.saved
          @table = @tbl.table
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
        [purge_button, save_button]
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
