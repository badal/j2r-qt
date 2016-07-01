#!/usr/bin/env ruby
# encoding: utf-8

# File: ip_editor.rb
# Created: 29/06/2016
#
# (c) Michel Demazure <michel@demazure.com>
module JacintheReports
  module GuiQt
    class SpecialEditor < Qt::TextEdit
      # slots :save
      attr_accessor :state

      def initialize(ip_list, parent)
        super(parent)
        resize(400, 600)
        @ip_table = ip_list
        @state = :saved
        document = Qt::TextDocument.new
        setDocument(document)
        @cursor = Qt::TextCursor.new(document)
        fill_with(ip_list.before, ip_list.line, ip_list.after)
        connect(self, SIGNAL(:textChanged)) { @state = :changed }
      end

      def fill_with(before, line, after)
        insert_plain_text(before.join("\n"))
        cur_beg = @cursor.position
        insert_plain_text("\n#{line}\n")
        cur_end = @cursor.position
        insert_plain_text(after.join("\n"))

        @cursor.set_position(cur_beg, Qt::TextCursor::MoveAnchor)
        @cursor.set_position(cur_end, Qt::TextCursor::KeepAnchor)
        fmt = Qt::TextCharFormat.new
        color = '#0FF'
        brush = Qt::Brush.new(Qt::Color.new(color), Qt::SolidPattern)
        fmt.set_background(brush)
        @cursor.setCharFormat(fmt)
        @cursor.set_position(cur_end)

        setTextCursor(@cursor)
        ensureCursorVisible
      end

      def saved
        @state = :saved
      end
    end

    class IPEditor < Qt::Widget
      include Signals

      signals :back, :accept

      QUIT_MSG = [
        'La modification que vous avez faite',
        'n\'a pas été acceptée'
      ]

      attr_reader :text
      def initialize(ip_list, parent)
        super()
        set_geometry(parent.parent.x + 200, parent.parent.y, 400, 600)
        #   pos(Qt::Point.new(100,100))
        resize(400, 600)
        self.window_title = 'Nettoyeur de liste de plages'
        layout = Qt::VBoxLayout.new(self)
        horiz = Qt::HBoxLayout.new
        layout.add_layout(horiz)
        horiz.add_widget(Qt::Label.new("Plages du Tiers #{ip_list.tiers_id}"))
        save_button = Qt::PushButton.new('Accepter les modifications et fermer', self)
        horiz.add_widget(save_button)
        horiz.add_stretch
        @editor = SpecialEditor.new(ip_list, self)
        layout.add_widget(@editor)
        connect(save_button, SIGNAL_CLICKED) do
          @editor.saved
          @text = @editor.to_plain_text
          emit(accept)
        end
      end

      # WARNING needs camelCase form !!!
      # noinspection RubyInstanceMethodNamingConvention
      def closeEvent(event)
        case @editor.state
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
