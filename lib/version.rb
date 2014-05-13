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
  MINOR = 0
  # tiny version number
  TINY = 'dev'
  # version
  VERSION = [MAJOR, MINOR, TINY].join('.')

  # author
  COPYRIGHT = "\u00A9 Michel Demazure 2011-2014"

  # name of this version
  NAME = "Jacinthe violette #{VERSION}"
end

if __FILE__ == $PROGRAM_NAME

  puts JacintheReports::NAME

end
