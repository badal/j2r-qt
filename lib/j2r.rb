#!/usr/bin/env ruby
# encoding: utf-8
#
# File: j2r.rb
# Created: 16 January 2012
#
# (c) Michel Demazure <michel@demazure.com>

require_relative 'version.rb'

# GUIs for Jacinthe
module JacintheReports
  # copyright
  COPYRIGHT = "\u00A9 Michel Demazure & Kenji Lefevre"

  # help directory
  HELP_DIR = File.expand_path('../help', File.dirname(__FILE__))
end

require 'j2r/jaccess'
require 'j2r/core'
