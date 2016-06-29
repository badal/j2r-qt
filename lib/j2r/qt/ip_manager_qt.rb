#!/usr/bin/env ruby
# encoding: utf-8

# File: ip_manager_qt.rb
# Created: 30/06/2016
#
# (c) Michel Demazure <michel@demazure.com>

require_relative 'version.rb'

J2R.for_user do
  J2R.logger.info('start ip manager')
  require_relative('elements/ip_manager_main.rb')
  J2R::GuiQt::IPManagerMain.run
  J2R.logger.info('stop ip manager')
end
