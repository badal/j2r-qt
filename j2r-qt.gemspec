# encoding: utf-8

dir = File.dirname(__FILE__)
$LOAD_PATH.unshift(dir) unless $LOAD_PATH.include?(dir)

require 'lib/j2r/qt/version.rb'

Gem::Specification.new do |s|
  s.name = 'j2r-qt'
  s.version = JacintheReports::VERSION
  s.has_rdoc = true
  s.extra_rdoc_files = %w(README.md LICENSE)
  s.summary = 'Jacinthe Reports GUI'
  s.description = 'Reporter for Jacinthe'
  s.author = 'Michel Demazure'
  s.email = 'michel@demazure.com'
 # s.add_runtime_dependency 'qtbindings'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'yard'
  s.homepage = 'http://github.com/badal/j2r-qt'
  s.license = 'MIT'
  s.files = %w(LICENSE README.md HISTORY.md MANIFEST Rakefile) + Dir.glob('{lib,spec}/**/*')
  s.require_path = 'lib'
end
