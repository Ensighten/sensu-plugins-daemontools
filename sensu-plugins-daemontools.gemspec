lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'date'
require 'sensu-plugins-daemontools'
require 'sensu-plugins-daemontools'

Gem::Specification.new do |s|
  s.authors                = ['Ensighten']
  s.date                   = Date.today.to_s
  s.description            = 'This plugin provides sensu checks for daemontools services'
  s.email                  = '<infra@ensighten.com>'
  s.executables            = Dir.glob('bin/**/*.rb').map { |file| File.basename(file) }
  s.files                  = Dir.glob('{bin,lib}/**/*') + %w(LICENSE README.md CHANGELOG.md)
  s.homepage               = 'https://github.com/Ensighten/sensu-plugins-daemontools'
  s.license                = 'MIT'
  s.metadata               = { 'maintainer'         => 'ensighten',
                               'development_status' => 'active',
                               'production_status'  => 'unstable - testing recommended',
                               'release_draft'      => 'false',
                               'release_prerelease' => 'false' }
  s.name                   = 'sensu_plugins_daemontools'
  s.platform               = Gem::Platform::RUBY
  s.post_install_message   = 'You can use the embedded Ruby by setting EMBEDDED_RUBY=true in /etc/default/sensu'
  s.require_paths          = ['lib']
  s.required_ruby_version  = '>= 2.0.0'
  s.summary                = 'Sensu plugins for daemontools services'
  s.test_files             = s.files.grep(%r{^(test|spec|features)/})
  s.version                = SensuPluginsDaemontools::Version::VER_STRING

  s.add_runtime_dependency 'sensu-plugin', '~> 1.2'

  s.add_development_dependency 'bundler',                   '~> 1.7'
  s.add_development_dependency 'codeclimate-test-reporter', '~> 0.4'
  s.add_development_dependency 'github-markup',             '~> 1.3'
  s.add_development_dependency 'pry',                       '~> 0.10'
  s.add_development_dependency 'rake',                      '~> 10.0'
  s.add_development_dependency 'redcarpet',                 '~> 3.2'
  s.add_development_dependency 'rspec',                     '~> 3.1'
  s.add_development_dependency 'rubocop',                   '~> 0.40.0'
  s.add_development_dependency 'yard',                      '~> 0.8'
  s.add_development_dependency 'test-kitchen',              '~> 1.6'
  s.add_development_dependency 'kitchen-vagrant',           '~> 0.19'
  s.add_development_dependency 'kitchen-localhost',         '~> 0.3'
  s.add_development_dependency 'net-ssh',                   '~> 2.9'
  s.add_development_dependency 'json',                      '< 2.0.0'
end