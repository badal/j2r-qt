#!/usr/bin/env ruby
# encoding: utf-8

# File: auditor_qt.rb
# Created: 18/06/12
#
# (c) Michel Demazure <michel@demazure.com>

require_relative 'version.rb'

J2R.for_user do
  J2R.logger.info('start auditor')
  require_relative('elements/auditor_main.rb')
  J2R::GuiQt::AuditorMain.run
  J2R.logger.info('stop auditor')
end
