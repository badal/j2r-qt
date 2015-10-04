#!/usr/bin/env ruby
# encoding: utf-8

# File: selector.rb
# Created: 02/10/2015
#
# (c) Michel Demazure <michel@demazure.com>
module JacintheReports

  class Selector
    @all = []

    def self.all
      @all
    end

    def self.add(*args)
      @all << new(*args)
    end

    attr_reader :name, :description, :parameter_list
    def initialize(name, description, parameter_list = [])
      @name = name
      @description = description
      @parameter_list = parameter_list
    end

    # indx = numéro du paramètre, ou bien -2
    def build_tiers_list(indx)
      puts @parameter_list[indx]
      nil
    end

    def command?
      false
    end
  end
end

include JacintheReports

Selector.add('essai', 'texte essai', ['2014', '2015'])
Selector.add('essai2', 'texte deux')

sel = Selector.all[0]


def sel.build_tiers_list(indx)
  puts @parameter_list[indx]
  @tiers_list = [14, 15, 16, 17, 383]
  @tiers_list.size
end

