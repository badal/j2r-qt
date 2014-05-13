#!/usr/bin/env ruby
# encoding: utf-8
#
# File: spec_helper.rb
# Created: 16 January 2012
#
# (c) Michel Demazure <michel@demazure.com>

# require 'simplecov'
# SimpleCov.start

require_relative '../lib/j2r.rb'

require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/reporters'

MiniTest::Reporters.use!

include J2R
