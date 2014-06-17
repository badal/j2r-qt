require 'rubygems/package_task'
require 'rdoc/task'
require 'yard'
require 'yard/rake/yardoc_task'

require 'rake/testtask'

require_relative 'lib/j2r/qt/version.rb'

spec = Gem::Specification.new do |s|
  s.name = 'j2r-qt'
  s.version = JacintheReports::VERSION
  s.has_rdoc = true
  s.extra_rdoc_files = %w(README.md LICENSE)
  s.summary = 'JacintheReports is a utility library to produce reports from the Jacinthe-DB database'
  s.description = 'To be replaced'
  s.author = 'Michel Demazure'
  s.email = 'michel@demazure.com'
  s.homepage = 'http://github.com/badal/j2r_qt'
  s.add_runtime_dependency 'mysql2'
  s.add_runtime_dependency 'sequel'
  s.add_runtime_dependency 'qtbindings'
  s.add_runtime_dependency 'j2r-core'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'yard'
  s.add_development_dependency 'simplecov'
  s.executables = %w(reporter auditor)
  s.files = %w(LICENSE README.md MANIFEST Rakefile) + Dir.glob('{bin,lib}/**/*')
  s.require_path = 'lib'
  s.license = 'MIT'
end

Gem::PackageTask.new(spec) do |p|
  p.package_dir = ENV['LOCAL_GEMS']
  p.gem_spec = spec
  p.need_tar = false
  p.need_zip = false
end

# noinspection RubyArgCount
RDoc::Task.new do |rdoc|
  files = %w(README.md TODO.md HISTORY.md LICENSE lib/**/*.rb)
  rdoc.rdoc_files.add(files)
  rdoc.main = 'README.md' # page to start on
  rdoc.title = 'Smf Docs'
  rdoc.rdoc_dir = 'doc/rdoc' # rdoc output folder
  rdoc.options << '--line-numbers'
end

YARD::Rake::YardocTask.new do |t|
  t.options += ['--title', "JacintheReports #{JacintheReports::VERSION} Documentation"]
  t.options += %w(--files LICENSE)
  t.options += %w(--files HISTORY.md)
  t.options += %w(--files TODO.md)
  t.options += %w(--verbose)
end

desc 'show not documented'
task :yard_not_documented do
  system 'yard stat --list-undoc'
end

Rake::TestTask.new do |t|
  t.libs.push 'lib'
  t.test_files = FileList['test/*_test.rb']
  t.verbose = true
end

desc 'build Manifest'
task :manifest do
  system ' mast -x .rubocop.yml -x metrics -x doc -x bat -x help -x coverage -x pkg -x "documentation v1" -x demo * > MANIFEST'
end

import('metrics.rake')
