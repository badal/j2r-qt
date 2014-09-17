#!/usr/bin/env ruby
# encoding: utf-8

# File: reporter_qt.rb
# Created: 18/06/12
#
# (c) Michel Demazure <michel@demazure.com>

require_relative 'version.rb'

J2R.for_user do
  J2R.logger.info('start reporter')
  require_relative('elements/reporter_main.rb')
  J2R::GuiQt::ReporterMain.run
  J2R.logger.info('stop reporter')
end
