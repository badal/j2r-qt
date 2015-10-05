#!/usr/bin/env ruby
# encoding: utf-8

# File: selectors.rb
# Created: 02/10/2015
#
# (c) Michel Demazure <michel@demazure.com>


# TODO: fix this call
require 'jacman/utils'

module JacintheManagement
  module Selectors
    @all = []

    def self.all
      @all
    end

    def self.<<(selector)
      @all << selector
    end

    Selector = Struct.new(:name, :description, :parameter_list)

    class Selector

      attr_reader :tiers_list
      # default

    end

    class SimpleQuery < Selector

      def initialize(name, description, query_file, parameter_list = [])
        super(name, description, parameter_list)
        # TODO; fix module
        @query = JacintheManagement::SQLFiles.script(query_file)
      end

      def command?
        false
      end

      def query_for(indx)
        if indx < 0
          @query
        else
          @query.gsub('PARAM', parameter_list[indx])
        end
      end

      def build_tiers_list(indx)
        query = query_for(indx)
        # TODO; fix module
        @tiers_list = JacintheManagement::Sql.answer_to_query(JACINTHE_MODE, query).drop(1)
        @tiers_list.size
      end

    end

    class Command < Selector
      def initialize(name, description, query_file, parameters = [])
        super(name, description, parameters)
        # TODO; fix module
        @query = JacintheManagement::SQLFiles.script(query_file)
      end

      def command?
        true
      end

      def execute
        JacintheManagement::Sql.answer_to_query(JACINTHE_MODE, @query).join('<P>')
      end
    end
  end
end


include JacintheManagement


sel1 = Selectors::SimpleQuery.new('Exemple simple', 'Exemple sans paramètres', 'essai_selector')
sel2 = Selectors::SimpleQuery.new('Requête à paramètres', 'Il faut choisir un paramètre', 'essai_param_selector', ['1005', '1010'])
sel4 = Selectors::SimpleQuery.new('Nouvelles adhésions', 'Choisir l\'annéee', 'nouvelles_adhesions_gratuites', ['2014', '2015'])
sel3 = Selectors::Command.new('Commande', 'texte essai', 'essai_selector')

=begin
def sel1.build_tiers_list(indx)
  @tiers_list = [14, 15, 16, 17, 383]
  @tiers_list.size
end

def sel2.build_tiers_list(indx)
  @tiers_list = [14, 15, 16, 17, 2014 +indx]
  @tiers_list.size
end
=end

def sel2.parameter_description(indx)
  "vous avez choisi le paramètre #{parameter_list[indx]}"
end

def sel3.command?
  true
end

def sel3.command_message
  "Vous pouvez lancer la commande par le bouton Exécuter avant ou après avoir créé le routage, ou encore ou ne pas la lancer"
end

def sel3.build_tiers_list(indx)
  @tiers_list = [14, 15, 16, 17, 383]
  @tiers_list.size
end

def sel4.parameter_description(indx)
  "vous avez choisi le paramètre #{parameter_list[indx]}"
end

Selectors<<sel1<<sel2<<sel4<<sel3


