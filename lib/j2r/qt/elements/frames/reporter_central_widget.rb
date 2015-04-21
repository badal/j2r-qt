#!/usr/bin/env ruby
# encoding: utf-8

# File: reporter_central_widget.rb
# Created:  10/06/12
#
# (c) Michel Demazure <michel@demazure.com>

# added 22/4/2015 for output protection (see save_and_show_layout.rb)
module JacintheReports
  module Recipes
    class Recipe
      attr_accessor :processed
    end
  end

  module GuiQt
    # central widget for reporter
    class ReporterCentralWidget < Qt::Widget
      SAMPLE_SIZE = 8

      include Signals
      slots :recipe_updated, :recipe_saved
      slots 'console_message (const QString&)', 'show_html (const QString&)', 'tab_changed (int)'
      signals 'status_message (const QString&)'

      # @return [Bool] whether the recipe need to be saved
      attr_reader :need_saving

      # @return [ReporterCentralWidget] new instance
      def initialize(initial_recipe_file)
        super()
        build_layout
        @recipe = Recipes::Recipe.empty
        @initial_recipe_file = initial_recipe_file
        recipe_saved
        @recipe.processed = false
        add_frames
      end

      def build_layout
        layout = Qt::VBoxLayout.new(self)
        @head_label = Qt::Label.new
        layout.add_widget(@head_label)
        @show_zone = Qt::TextEdit.new(Qt::Frame.new)
        @show_zone.read_only = true
        layout.add_widget(@show_zone)
        @tab_widget = Qt::TabWidget.new
        #   @tab_widget.tabPosition = qt::TabWidget::West
        @tab_widget.tabShape = Qt::TabWidget::Triangular
        layout.add_widget(@tab_widget)
      end

      # WARNING: not used
      def initial_load_recipe(recipe_file)
        @recipe = Recipes::Recipe.from_yaml_path(recipe_file)
        @tab_widget.setCurrentIndex(2)
        recipe_saved
        console_message "Maquette chargée depuis ''#{recipe_file}''"
      rescue StandardError
        console_message "Je n'ai pas pu charger '#{recipe_file}''"
      end

      def add_frames
        connect(@tab_widget, SIGNAL('currentChanged (int)'), self, SLOT('tab_changed (int)'))
        entry_frame = EntryFrame.new(@recipe)
        add_tab_frame(entry_frame, 'Fichier')
        data_frame = DataFrame.new(@recipe)
        add_tab_frame(data_frame, 'Sélectionner')
        [entry_frame, data_frame].each do |frame|
          connect(frame, SIGNAL(:recipe_saved), self, SLOT(:recipe_saved))
        end
        add_tab_frame(ExportFrame.new(@recipe), 'Exploiter')
        entry_frame.do_load_recipe(@initial_recipe_file) if @initial_recipe_file
      end

      # add and connect the frame
      # @param [Frame] frame frame to be added
      # @param [Object] text text for the tab
      def add_tab_frame(frame, text)
        @tab_widget.addTab(frame, text)
        connect(frame, SIGNAL(:recipe_updated), self, SLOT(:recipe_updated))
        show_connect(frame)
        connect(frame, SIGNAL('set_tab (int)'), @tab_widget, SLOT('setCurrentIndex (int)'))
        console_connect(frame)
      end

      # action when tab changes
      # @param [Integer] int no of the tab
      def tab_changed(int)
        @tab_widget.widget(int).build_panel
        recipe_updated
      end

      # recipe does not need to ba saved
      def recipe_saved
        @yaml = @recipe.to_yaml
        @need_saving = false
      end

      # update the shown sample and do bookkeeping
      def recipe_updated
        new_yaml = @recipe.to_yaml
        return if new_yaml == @yaml
        @need_saving = true
        @yaml = new_yaml
        table = @recipe.table_for_report
        show_sample(table)
      end

      # show a random sample of the table
      # @param [Table] table table to be shown
      def show_sample(table)
        table_size = table.size
        if table_size == 0
          @head_label.text = '<b>Maquette vide</b>'
        else
          @head_label.text = "<b>Taille de la maquette : #{table_size} lignes."
        end
        sample = '<h3>Echantillon de la maquette</h3>' + table.sample_for_html(SAMPLE_SIZE)
        show_html(sample)
      end

      # send the message to the console (overrides)
      # @param [String] msg message to transmit
      def console_message(msg)
        emit(status_message(msg.force_encoding('utf-8')))
      end

      # send the text to the show area (overrides)
      # @param [String] html text to show
      def show_html(html)
        @show_zone.setHtml(html.force_encoding('utf-8'))
      end
    end
  end
end
