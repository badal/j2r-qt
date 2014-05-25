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
  # data directory
  DATA = ENV["J2R_DATA"]

  # help directory
  HELP_DIR = File.expand_path('../help', File.dirname(__FILE__))
end

# for parallel gem development
require_relative '../../j2r-core/lib/j2r/core.rb'

# for global version
# require_relative 'j2r/core.rb'
