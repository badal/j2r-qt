#!/usr/bin/env ruby
# encoding: utf-8

# File: auditor_qt.rb
# Created: 18/06/12
#
# (c) Michel Demazure <michel@demazure.com>

require_relative 'version.rb'
require 'j2r/jaccess'
require 'j2r/core'

J2R.for_user do
  J2R.logger.info('start auditor')
  require_relative('j2r/Qt/auditor_main.rb')
  J2R::GuiQt::AuditorMain.run
  J2R.logger.info('stop auditor')
end
