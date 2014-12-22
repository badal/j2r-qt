#!/usr/bin/env ruby
# encoding: utf-8

# File: model_data_frame.rb
# Created: 21/06/12
#
# (c) Michel Demazure <michel@demazure.com>

module JacintheReports
  module GuiQt
    # common model for column and sort lines
    class ModelDataLine < Qt::HBoxLayout
      include Signals
      slots :_up, :_down, :_erase, :_insert
      signals 'up( int )', 'down( int )', 'erase( int )', 'changed( int)', 'insert( int )'

      def initialize
        super()
        setContentsMargins(6, 1, 6, 1)
      end

      def build_buttons
        up = Qt::PushButton.new(Icons.icon('up'), '')
        add_widget(up)
        connect_button(up, :_up)
        down = Qt::PushButton.new(Icons.icon('down'), '')
        add_widget(down)
        connect_button(down, :_down)
        erase = Qt::PushButton.new(Icons.icon('standardbutton-cancel'), '')
        add_widget(erase)
        connect_button(erase, :_erase)
        insert = Qt::PushButton.new(Icons.from_file('add2_32.png'), '')
        add_widget(insert)
        connect_button(insert, :_insert)
        addStretch
      end

      def _up
        emit(up(@index))
      end

      def _down
        emit(down(@index))
      end

      def _erase
        emit(erase(@index))
      end

      def _insert
        emit(insert(@index))
      end

      def update_selection
        emit(changed(@index))
      end
    end

    # common model for srot and columns panels
    class ModelDataFrame < PrettyFrame
      SLOTS = ['up( int )', 'down( int )', 'erase( int )', 'changed( int )', 'insert (int )']
      slots(*SLOTS)

      def initialize(recipe, panel, label, lines)
        super(label)
        @panel = panel
        @recipe = recipe
        @lines = []
        @index = -1
        [lines, @panel.size + 1].max.times { add_line }
      end

      def add_line
        @index += 1
        line = new_line(@index)
        @layout.addLayout(line)
        @lines << line
        SLOTS.each do |slot|
          connect(line, SIGNAL(slot), self, SLOT(slot))
        end
      end

      def build_panel(panel = @panel)
        @lines.zip(panel) do |line, data|
          line.build_with_selection(*data)
        end
        update_recipe
      end

      def up(indx)
        build_panel(@panel.up(indx))
      end

      def down(indx)
        build_panel(@panel.down(indx))
      end

      def erase(indx)
        @panel.delete_at(indx)
        build_panel(@panel)
      end

      def insert(indx)
        add_line
        @panel[indx, 0] = [empty_panel_line]
        build_panel(@panel)
      end
    end
  end
end
