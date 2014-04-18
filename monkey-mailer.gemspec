# encoding: utf-8
$:.push File.expand_path("../lib", __FILE__)
require "monkey-mailer/version"

Gem::Specification.new do |spec|
  spec.name          = "monkey-mailer"
  spec.authors       = ["Lautaro Orazi", "Federico Saravia Barrantes"]
  spec.email         = ["fedesaravia+monkey-mailer@gmail.com"]
  spec.description   = %q{Ruby email queueing system with priority handling}
  spec.summary       = %q{Ruby email queueing system with priority handling}
  spec.homepage      = "https://github.com/fsaravia/monkey-mailer/"
  spec.version       = MonkeyMailer::VERSION
  spec.license       = "UNLICENSE"

  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- spec/*`.split("\n")
  spec.require_paths = ["lib"]

  spec.add_dependency 'clap', '~> 1.0', '>= 1.0.0'
  spec.add_dependency 'fallen', '~> 0.0', '>= 0.0.3'
  spec.add_dependency 'mail', '~> 2.4','>= 2.4.4'
  spec.add_development_dependency 'rspec', '~> 2.12', '>= 2.12.0'
end
