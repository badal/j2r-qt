#!/usr/bin/env ruby
# encoding: utf-8

# File: entry_frame.rb
# Created: 10/06/12
#
# (c) Michel Demazure <michel@demazure.com>

module JacintheReports
  module GuiQt
    # entry frame for the reporter GUI
    class EntryFrame < PrettyFrame
      INVITE_TABLE = 'Choisir la table'

      # Tables used by the reporter, read from the config file
      SOURCES = J2R.load_config(SOURCES_CONFIG_FILE)

      TABLES = [INVITE_TABLE] + SOURCES

      slots :exploit_recipe, :modify_recipe, :new_recipe, :promote_recipe
      signals :recipe_saved

      def initialize(recipe)
        super('FICHIERS')
        set_color(GREEN)
        @recipe = recipe
        @layout.addStretch
        horizontal = Qt::HBoxLayout.new
        @layout.addLayout(horizontal)
        horizontal.addStretch
        form = Qt::FormLayout.new
        horizontal.addLayout(form)
        build_form(form)
        horizontal.addStretch
        @layout.addStretch
      end

      def build_form(form)
        open_icon = Icons.icon('standardbutton-open')
        form.addRow(Qt::Label.new('<b>Choisissez une utilisation :</b>'))
        open_button = Qt::PushButton.new(open_icon, ' Ouvrir')
        connect_button(open_button, :exploit_recipe)
        form.addRow(Qt::Label.new('Charger une maquette pour l\'exploiter'), open_button)
        modify_button = Qt::PushButton.new(open_icon, ' Ouvrir')
        connect_button(modify_button, :modify_recipe)
        form.addRow(Qt::Label.new('Charger une maquette pour la modifier'), modify_button)
        @entry = build_entry
        form.addRow(Qt::Label.new('Créer une nouvelle maquette'), @entry)
        promote_button = Qt::PushButton.new(open_icon, 'Ouvrir')
        form.addRow(Qt::Label.new(''), Qt::Label.new(''))
        form.addRow(Qt::Label.new('Convertir une maquette de Jacinthe rose'), promote_button)
        connect_button(promote_button, :promote_recipe)
      end

      def build_entry
        entry = PrettyCombo.new(20)
        entry.addItems(TABLES)
        entry.enabled = true
        connect(entry, SIGNAL_ACTIVATED) { load_table }
        entry
      end

      def load_recipe
        filename = Qt::FileDialog.getOpenFileName(self,
                                                  'Charger une maquette',
                                                  User.recipes,
                                                  '*.yaml')
        do_load_recipe(filename) if filename
      end

      def do_load_recipe(filename)
        J2R.logger.info("loading #{filename}")
        filename = filename.encode('utf-8')
        yml = File.read(filename, encoding: 'utf-8')
        @recipe.fill_from_yaml(yml)
        @recipe.filename = filename
        emit(recipe_updated)
        emit(recipe_saved)
        @recipe.processed = false
        console_message "Maquette chargée depuis '#{filename}'"
      rescue => err
        J2R.logger.error(err.message)
        console_message "Je n'ai pas pu charger la maquette"
      end

      def exploit_recipe
        load_recipe
        emit(set_tab(2))
      end

      def modify_recipe
        load_recipe
        emit(set_tab(1))
      end

      def load_table
        table = @entry.currentText
        return if table == INVITE_TABLE
        @recipe.clear_with_new_table(table.to_sym)
        emit(recipe_updated)
        console_message 'Nouvelle maquette'
        emit(set_tab(1))
      end

      def promote_recipe
        require_relative '../../recipes/recipe_converter.rb'
        filename = Qt::FileDialog.getOpenFileName(self,
                                                  'Charger une maquette',
                                                  User.recipes,
                                                  '*.json')
        do_promote_recipe(filename) if filename
      end

      def do_promote_recipe(filename)
        J2R.logger.info("converting #{filename}")
        filename = filename.force_encoding('utf-8')
        json = File.read(filename, encoding: 'utf-8')
        hsh = Recipes::RecipeConverter.hash_from_json(json)
        @recipe.fill_from_hash(hsh)
        emit(recipe_updated)
        console_message "Maquette convertie depuis #{filename}"
      rescue
        console_message 'Erreur à la conversion'
      end
    end
  end
end
