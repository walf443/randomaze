require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rake/testtask'
require 'rake/packagetask'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/contrib/rubyforgepublisher'
require 'rake/contrib/sshpublisher'
require 'fileutils'
include FileUtils

load File.join(File.dirname(__FILE__), 'tasks', 'basic_config.rake')

NAME              = "randomaze"
DESCRIPTION       = <<-"END_DESCRIPTION"
random object maker framework.
END_DESCRIPTION
BIN_FILES         = %w(  )
VERS              = "0.0.1"

EXTRA_RDOC_FILES = []
HECKLE_ROOT_MODULES = ["Randomaze"]

SPEC = Gem::Specification.new do |s|
	s.name              = NAME
	s.version           = VERS
	s.platform          = Gem::Platform::RUBY
	s.has_rdoc          = true
	s.extra_rdoc_files  = DEFAULT_EXTRA_RDOC_FILES + EXTRA_RDOC_FILES
	s.rdoc_options     += RDOC_OPTS + ['--title', "#{NAME} documentation"]
	s.summary           = DESCRIPTION
	s.description       = DESCRIPTION
	s.author            = AUTHOR
	s.email             = EMAIL
	s.homepage          = HOMEPATH
	s.executables       = BIN_FILES
	s.rubyforge_project = RUBYFORGE_PROJECT
	s.bindir            = "bin"
	s.require_path      = "lib"
	s.autorequire       = ""
	s.test_files        = Dir["spec/*_spec.rb"]

	#s.add_dependency('activesupport', '>=1.3.1')
	#s.required_ruby_version = '>= 1.8.2'

	s.files = PKG_FILES + EXTRA_RDOC_FILES
	s.extensions = EXTENSIONS
end

def racc_gen target
  racc_file = target.gsub(/\.tab\.rb$/, '.y')
  file target => [ racc_file ] do
    system("racc", racc_file, "-o", target)
  end

  desc 'geenerate ruby file from racc'
  task :racc_convert => [ target ] do
  end
end

racc_gen 'lib/randomaze/string/template_parser.tab.rb'

import File.join(File.dirname(__FILE__), 'tasks', 'basic_tasks.rake')

task :spec => [ :racc_convert ]
