#!/usr/bin/env ruby
# encoding: utf-8

# File: compare_frame.rb
# Created: 16/06/12
#
# (c) Michel Demazure <michel@demazure.com>

module JacintheReports
  module GuiQt
    # line for the compare line panel
    class CompareLine < Qt::HBoxLayout
      include Signals
      slots :ask_delete, :ask_modify
      signals 'delete (const QString&)', 'modify (const QString&)'

      def initialize(text = '')
        super()
        @macro = Qt::LineEdit.new(text)
        @macro.enabled = false
        add_widget(@macro)
        delete_button = Qt::PushButton.new(Icons.icon('standardbutton-cancel'), '')
        add_widget(delete_button)
        connect_button(delete_button, :ask_delete)
        modify_button = Qt::PushButton.new('Modifier')
        add_widget(modify_button)
        connect_button(modify_button, :ask_modify)
      end

      def ask_delete
        emit(delete(@macro.text))
        @macro.text = 'Supprimé'
      end

      def ask_modify
        emit(modify(@macro.text))
        @macro.text = 'En cours de modification'
      end
    end

    # compare line panel
    class CompareFrame < PrettyFrame
      signals 'delete (const QString&)'
      slots :field_changed, 'delete (const QString&)', 'modify (const QString&)'

      def initialize(recipe)
        super('COMPARATEURS')
        @recipe = recipe
        @lines = []
        @recipe.actions.each do |action|
          new_line(action) if action.first.to_sym == :compare
        end
        @layout.add_widget(Qt::Label.new('<b>Ajouter un comparateur</b>'))
        horizontal = Qt::HBoxLayout.new
        @layout.addLayout(horizontal)
        build_left(horizontal)
        build_center(horizontal)
        build_right(horizontal)
        horizontal.insertSpacing(1, 30)
        horizontal.addStretch
        @layout.addStretch
      end

      def build_left(horizontal)
        left = Qt::VBoxLayout.new
        horizontal.addLayout(left)
        left.add_widget(Qt::Label.new('Identification'))
        @identifications = (0..2).to_a.map do
          FieldCombo.new(@recipe).tap { |combo| left.add_widget(combo) }
        end
      end

      def build_center(horizontal)
        center = Qt::VBoxLayout.new
        horizontal.addLayout(center)
        center.add_widget(Qt::Label.new('Comparaison'))
        center.add_widget(Qt::Label.new('Champ'))
        center.add_widget(Qt::Label.new('Valeur présente'))
        center.add_widget(Qt::Label.new('Valeur absente'))
      end

      def build_right(horizontal)
        right = Qt::VBoxLayout.new
        horizontal.addLayout(right)
        right.add_widget(Qt::Label.new(''))
        @field = FieldCombo.new(@recipe)
        right.add_widget(@field)
        @value_in = ValueCombo.new(@recipe)
        right.add_widget(@value_in)
        @value_out = ValueCombo.new(@recipe)
        right.add_widget(@value_out)
        connect(@field, SIGNAL_ACTIVATED, self, SLOT(:field_changed))
      end

      def new_line(action)
        comp = CompareLine.new(action.join(' '))
        @lines << comp
        @layout.addLayout(comp)
        connect(comp, SIGNAL('delete (const QString&)'), self, SLOT('delete (const QString&)'))
        connect(comp, SIGNAL('modify (const QString&)'), self, SLOT('modify (const QString&)'))
      end

      def build_panel
        @deleted = []
        @identifications.each { |combo| combo.build_with(:_id) }
        @field.build_with
      end

      def field_changed
        return if @field.no_field
        field = @field.currentText.to_sym
        @value_in.build_for(field)
        @value_out.build_for(field)
      end

      def incomplete_selection
        @field.no_field || @identifications.all? { |combo| combo.no_field } ||
            @value_in.joker? || @value_out.joker?
      end

      def delete(string)
        @deleted << string
      end

      def modify(string)
        actions = @recipe.actions.delete_if { |action| action.join(' ') == string }
        @recipe.actions = actions
        _, *idents, field, value_out, value_in = *string.split
        @value_in.build_for(field)
        @value_out.build_for(field)
        @value_in.show_item(value_in)
        @value_out.show_item(value_out)
        @field.show_item(field)
        idents.zip(@identifications).each { |fld, ident| ident.show_item(fld) }
      end

      def do_delete
        actions = @recipe.actions
        actions.delete_if { |action| @deleted.include?(action.join(' ')) }
        @recipe.actions = actions
      end

      def update_recipe
        incomplete = incomplete_selection
        empty = @deleted.empty?
        return if incomplete && empty
        do_delete unless empty
        compare unless incomplete
      end

      def compare
        col = @field.currentText.to_sym
        identifications = @identifications.map do |combo|
          combo.currentText.to_sym unless combo.no_field
        end.compact.map(&:to_sym)
        value_out = @value_out.currentText
        value_in = @value_in.currentText
        @recipe.add_extra_fields([col] + identifications)
        @recipe.do_and_add(:compare, identifications, col, value_out, value_in)
      end
    end
  end
end
