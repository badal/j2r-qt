#!/usr/bin/env ruby
# encoding: utf-8

# File: data_frame.rb
# Created: 21/06/12
#
# (c) Michel Demazure <michel@demazure.com>

module JacintheReports
  module GuiQt
    # main fram for recipe data management
    class DataFrame < PrettyFrame
      slots :left_dialog, :center_dialog, :right_dialog
      slots :below_left_dialog, :below_center_dialog, :save_recipe
      signals :recipe_saved

      def initialize(recipe)
        super('MAQUETTE')
        set_color(GREEN)
        @recipe = recipe
        @table = Qt::Label.new
        @layout.add_widget(@table)
        @layout.add_widget(Qt::Label.new('<b>Sélection des lignes</b>'))
        build_line_panel
        @layout.add_widget(HLine.new)
        @layout.add_widget(Qt::Label.new('<b>Sélection des colonnes</b>'))
        build_column_panel
        @layout.addStretch
        connect_signals
      end

      def build_line_panel
        horizontal = Qt::HBoxLayout.new
        @layout.addLayout(horizontal)
        @left = PanelFrame.new
        @center = PanelFrame.new
        @right = PanelFrame.new
        horizontal.addLayout(@left)
        horizontal.add_widget(VLine.new)
        horizontal.addLayout(@center)
        horizontal.add_widget(VLine.new)
        horizontal.addLayout(@right)
        horizontal.addStretch
      end

      def build_column_panel
        horizontal = Qt::HBoxLayout.new
        @layout.addLayout(horizontal)
        @below_left = PanelFrame.new
        @below_center = PanelFrame.new
        horizontal.addLayout(@below_left)
        horizontal.add_widget(VLine.new)
        horizontal.addLayout(@below_center)
        horizontal.add_widget(VLine.new)
        button = Qt::PushButton.new(
            Icons.icon('standardbutton-save'),
            'Enregistrer les modifications dans la maquette')
        horizontal.addStretch
        horizontal.add_widget(button)
        horizontal.addStretch
        connect_button(button, :save_recipe)
      end

      def connect_signals
        signal = SIGNAL(:modify)
        connect(@left, signal, self, SLOT(:left_dialog))
        connect(@center, signal, self, SLOT(:center_dialog))
        connect(@right, signal, self, SLOT(:right_dialog))
        connect(@below_left, signal, self, SLOT(:below_left_dialog))
        connect(@below_center, signal, self, SLOT(:below_center_dialog))
      end

      def common_dialog(frame, color, text, action)
        frame.set_color(color)
        frame.build_panel
        dia = Dialog.new(frame, text)
        save_recipe_elements
        if dia.exec == 1
          frame.update_recipe
          emit(recipe_updated)
          Array(action).each { |act| send act }
        else
          restore_recipe_elements
        end
      end

      def save_recipe_elements
        @saved_recipe_elements = @recipe.to_hash
      end

      def restore_recipe_elements
        @recipe.fill_from_hash @saved_recipe_elements
      end

      def left_dialog
        common_dialog(FilterFrame.new(@recipe), '#EFF',
                      'Modifier les filtres', [:left_update, :below_center_update])
      end

      def center_dialog
        common_dialog(SortFrame.new(@recipe), '#FFE4E1',
                      'Modifier les tris', :center_update)
      end

      def right_dialog
        common_dialog(CompareFrame.new(@recipe), '#EFE',
                      'Modifier les comparateurs', [:right_update, :below_center_update])
      end

      def below_left_dialog
        common_dialog(ColumnFrame.new(@recipe), '#EEF',
                      'Modifier les colonnes d\'affichage', :below_left_update)
      end

      def below_center_dialog
        common_dialog(OperationFrame.new(@recipe), '#EEF',
                      'Modifier les opérations', :below_center_update)
      end

      def build_panel
        @table.text = "<b>Table : </b> #{@recipe.db_table}"
        left_update
        center_update
        right_update
        below_left_update
        below_center_update
      end

      def left_update
        html = '<h4>Filtres</h4><ul>'
        html += @recipe.filters.map do |field, value, bool|
          verb = bool ? 'Garder' : 'Ôter'
          "<li> #{verb} #{field} = #{value} </li>"
        end.join("\n")
        @left.update_content(html)
      end

      def center_update
        html = '<h4>Tris</h4><ul>'
        html += @recipe.sorts.map do |field, flag|
          "<li>#{field} : tri #{flag ? 'direct' : 'inverse'}</li>"
        end.join("\n")
        html += '</ul>'
        @center.update_content(html)
      end

      def right_update
        html = '<h4>Comparateurs</h4><ul>'
        html += @recipe.actions.map do |action|
          "<li>#{action.join(' ')}</li>"
        end.join("\n")
        html += '</ul>'
        @right.update_content(html)
      end

      def below_left_update
        html = '<h4>Colonnes à afficher</h4><ul>'
        html += @recipe.columns.map do |field, value|
          "<li>#{field} => #{value}</li>"
        end.join("\n")
        html += '</ul>'
        @below_left.update_content(html)
      end

      def below_center_update
        html = '<h4>Colonnes à traiter</h4><ul>'
        html += @recipe.operations.map do |field, index|
          oper = Recipes::Operation.new(field, index)
          res = oper.act_on(@recipe.table_for_field([field]))
          "<li>#{oper.name} : #{res}</li>"
        end.join("\n")
        html += '</ul>'
        @below_center.update_content(html)
      end

      def save_recipe
        filename = @recipe.filename || File.join(User.recipes, @recipe.db_table.to_s + '.yaml')
        path = Dialog.ask_save_file(self, filename)
        if path
          File.open(path.force_encoding('utf-8'), 'w:utf-8') { |file| file.puts @recipe.to_yaml }
          console_message 'Maquette enregistrée'
          emit(recipe_saved)
        else
          console_message 'Annulé'
        end
      end
    end
  end
end

__END__
