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

    attr_reader :name, :text, :parameter_list, :tiers_list
    def initialize(name, text, parameter_list = [])
      @name = name
      @text = text
      @parameter_list = parameter_list
      @tiers_list = nil
    end

    def build_tiers_list

    end

  end
end

include JacintheReports

Selector.add('essai', 'texte essai', ['2014', '2015'])
Selector.add('essai2', 'texte deux')

sel = Selector.all[0]


def sel.build_tiers_list
  @tiers_list = [14, 15]
  17
end

