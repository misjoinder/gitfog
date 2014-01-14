Gem::Specification.new do |s|
  s.name        = 'gitfog'
  s.version     = '0.0.4'
  s.date        = '2014-01-15'
  s.executables << 'gitfog'
  s.summary     = "Camouflage git commit and push times"
  s.description = "Camouflage git commit and push times, disable regular git commands"
  s.authors     = ["Msjoinder"]
  s.email       = 'msjoinder@gmail.com'
  s.files       = ["lib/gitfog.rb","bin/gitfog","README.md"]
  s.homepage    = 'https://github.com/msjoinder/gitfog'
  s.license       = 'GPLv3+'

  s.add_runtime_dependency("commander", "~> 4.1.5")
  s.add_runtime_dependency("highline", "~> 1.6.20")
  s.add_runtime_dependency("fileutils", "~> 0.7")
  s.add_runtime_dependency("git", "~> 1.2.6")
end
