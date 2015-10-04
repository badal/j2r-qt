#!/usr/bin/env ruby
# encoding: utf-8

# File: selector.rb
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

      # indx = numéro du paramètre, ou bien -2
      def build_tiers_list(indx)
        if indx < 0
          puts "no parameter"
        else
          puts parameter_list[indx]
        end
      end

      # default
      def command?
        false
      end
    end

    class SimpleQuery < Selector

      def initialize(name, description, query, parameters = [])
        super(name, description, parameters)
        @query = query
      end

    end

  end
end


include JacintheReports


sel = Selectors::Selector.new('essai', 'texte essai', ['2014', '2015'])

p sel

def sel.build_tiers_list(indx)
  @tiers_list = [14, 15, 16, 17, 383]
  @tiers_list.size
end

def sel.parameter_description(indx)
  "vous avez choisi le paramètre #{parameter_list[indx]}"
end

Selectors<<(sel)

Selectors<<(Selectors::Selector.new('essai deux', 'texte deux'))

