Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_embedded_videos'
  s.version     = '0.60.4'
  s.summary     = 'Add gem summary here'
  s.description = 'Add (optional) gem description here'
  s.required_ruby_version = '>= 1.8.7'

  s.author            = 'Jeremy Haile'
  s.email             = 'jhaile@gmail.com'
  s.homepage          = 'http://www.github.com/vitrue/spree_embedded_videos'
  s.rubyforge_project = 'spree-embedded-videos'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency('spree_core', '>= 0.60.4')
  s.add_dependency('ruby-oembed', '>= 0.8.5')
end
