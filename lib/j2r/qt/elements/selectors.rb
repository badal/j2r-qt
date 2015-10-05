#!/usr/bin/env ruby
# encoding: utf-8

# File: selectors.rb
# Created: 02/10/2015
#
# (c) Michel Demazure <michel@demazure.com>
module JacintheReports
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

      # indx = numéro du paramètre, ou bien -2
      def build_tiers_list(indx)
        if indx < 0
          puts "no parameter"
        else
          puts parameter_list[indx]
        end
      end


    end

    class SimpleQuery < Selector

      def initialize(name, description, query = nil, parameters = [])
        super(name, description, parameters)
        @query = query
      end

      def command?
        false
      end


    end

  end
end


include JacintheReports


sel1 = Selectors::SimpleQuery.new('Exemple simple', 'Exemple sans paramètres')
sel2 = Selectors::SimpleQuery.new('Requête à paramètres', 'Il faut choisir un paramètre', nil, ['2014', '2015'])
sel3 = Selectors::Selector.new('Commande', 'texte essai')


def sel1.build_tiers_list(indx)
  @tiers_list = [14, 15, 16, 17, 383]
  @tiers_list.size
end

def sel2.build_tiers_list(indx)
  @tiers_list = [14, 15, 16, 17, 2014 +indx]
  @tiers_list.size
end

def sel2.parameter_description(indx)
  "vous avez choisi le paramètre #{parameter_list[indx]}"
end

def sel3.command?
  true
end

def sel3.command_message
  "Vous pouvez lancer la commande par le bouton Exécuter avant ou après avoir créé le routage, ou encore ou ne pas la lancer"
end

def sel3.execute
  "Command exécutée"
end

def sel3.build_tiers_list(indx)
  @tiers_list = [14, 15, 16, 17, 383]
  @tiers_list.size
end

Selectors<<sel1<<sel2<<sel3


