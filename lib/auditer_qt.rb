#!/usr/bin/env ruby
# encoding: utf-8

# File: auditer_qt.rb
# Created: 18/06/12
#
# (c) Michel Demazure <michel@demazure.com>

require_relative 'version.rb'
require 'j2r/jaccess'
require 'j2r/core'

J2R.for_user do
  J2R.logger.info('start auditer')
  require_relative('j2r/Qt/auditer_main.rb')
  J2R::GuiQt::AuditerMain.run
  J2R.logger.info('stop auditer')
end
