#!/usr/bin/env ruby
# encoding: utf-8

# File: version.rb
# Created: 11/07/13
#
# (c) Michel Demazure <michel@demazure.com>

# Jacinthe GUIs
module JacintheReports
  # major version number
  MAJOR = 3
  # minor version number
  MINOR = 4
  # tiny version number
  TINY = '0'
  # version
  VERSION = [MAJOR, MINOR, TINY].join('.')

  # name of this version
  NAME = "Jacinthe violette #{VERSION}"
end

puts JacintheReports::NAME if __FILE__ == $PROGRAM_NAME
