# coding: utf-8
$:.push File.expand_path("../lib", __FILE__)
require 'walletone/version'

Gem::Specification.new do |s|
  s.name = "walletone"
  s.version = Walletone::VERSION
  s.authors = ["Danil Pismenny", "Yuri Artemev"]
  s.email = ["danil@brandymint.ru", "i@artemeff.com"]
  s.homepage = "https://github.com/BrandyMint/walletone"
  s.summary       = %q{walleton.com Checkout client}
  s.description   = %q{Клиент для приема оплаты через walletone.com}
  s.licenses = ['MIT']

  s.files = %w(README.md LICENSE walletone.gemspec)
  s.files += Dir.glob("lib/**/*.rb")
  s.files += Dir.glob("spec/**/*")
  s.require_paths = ['lib']
  s.test_files = Dir.glob("spec/**/*")

  s.add_dependency 'virtus', '~> 1.0.5'
  s.add_dependency 'rack',   '~> 1.6'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '~> 3.2.0'
  s.add_development_dependency 'ffaker', '>= 2.0.0'
  s.add_development_dependency 'fabrication', '~> 2.12.2'
  s.add_development_dependency "pry"
  s.add_development_dependency "pry-nav"
  s.add_development_dependency "webmock"
  s.add_development_dependency "guard"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency 'guard-ctags-bundler'
  s.add_development_dependency 'yard'
end
