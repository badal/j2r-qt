#!/usr/bin/env ruby
# encoding: utf-8

# File: reporter_qt.rb
# Created: 18/06/12
#
# (c) Michel Demazure <michel@demazure.com>

require_relative 'version.rb'

module JacintheManagement
  SELECTOR_FILES_DIR = File.join(Core::SMF_SERVEUR, 'Jacinthe', 'Tools', 'Library', 'SelectorFiles')
  Selectors.add_from_directory(SELECTOR_FILES_DIR, '.sel')
end

J2R.for_user do
  J2R.logger.info('start selector')
  require_relative('elements/selector_main.rb')
  J2R::GuiQt::SelectorMain.run
  J2R.logger.info('stop selector')
end
