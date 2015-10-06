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
      def initialize(name, description, query, parameter_list = [])
        super(name, description, parameter_list)
        # TODO; fix module
        @query = query.gsub(/\n/m, ' ').gsub(/\s+/, ' ')
      end

      #    JacintheManagement::SQLFiles.script(query_file)

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
      def initialize(name, description, parameters = [])
        super(name, description, parameters)
      end

      def command?
        true
      end

      def command_message
        'TO BE OVERRIDDEN'
      end

      def build_tiers_list(_indx)
        'TO BE OVERRIDDEN'
        0
      end

      def execute
        'TO BE OVERRIDDEN'
      end
    end
  end
end

include JacintheManagement

query1 = "CALL export_cadeau_init;
SELECT tiers_id, tiers_nom
FROM tiers
  LEFT JOIN vue_tiers_adhesion_locale_premiere_annee
            ON tiers_id=nouvel_adherent
  LEFT JOIN client_sage
            ON client_sage_client_final=tiers_id
  LEFT JOIN adhesion_locale
            ON adhesion_locale_client_sage=client_sage_id
WHERE
  annee=2015
  AND adhesion_locale_annee=2015
  AND adhesion_locale_type = 'GT'"

text1 = 'Nouvelles adhésions gratuites en 2015'

sel1 = Selectors::SimpleQuery.new('GT 2015 nouveaux', text1, query1)

Selectors << sel1

query2 = "CALL export_cadeau_init;
SELECT tiers_id, adhesion_locale_type
FROM tiers
  LEFT JOIN vue_tiers_adhesion_locale_premiere_annee
            ON tiers_id=nouvel_adherent
  LEFT JOIN client_sage
            ON client_sage_client_final=tiers_id
  LEFT JOIN adhesion_locale
            ON adhesion_locale_client_sage=client_sage_id
WHERE
  annee=PARAM
  AND adhesion_locale_annee=PARAM"

text2 = "Toutes les adhésions nouvelles d'une année<P>Choisir l'année"

sel2 = Selectors::SimpleQuery.new('Adhésions nouvelles', text2, query2, %w(2014 2015))

def sel2.parameter_description(indx)
  "vous avez choisi le paramètre #{parameter_list[indx]}"
end

Selectors << sel2

sel3 = Selectors::Command.new('Commande simulée', 'Démo pour l\'ergonomie')

def sel3.build_tiers_list(_indx)
  @tiers_list = [14, 15, 16, 17, 383]
  @tiers_list.size
end

def sel3.command_message
  'Vous pouvez lancer la commande par le bouton Exécuter avant ou après avoir créé le routage, ou encore ou ne pas la lancer'
end

def sel3.execute
  'Exécution simulée'
end

def sel3.build_tiers_list(_indx)
  @tiers_list = [14, 15, 16, 17, 383]
  @tiers_list.size
end

Selectors << sel3
