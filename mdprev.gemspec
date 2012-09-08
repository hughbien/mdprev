Gem::Specification.new do |s|
  s.name        = 'mdprev'
  s.version     = '1.0.5'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Hugh Bien']
  s.email       = ['hugh@hughbien.com']
  s.homepage    = 'https://github.com/hughbien/mdprev'
  s.summary     = 'Styled preview of markdown files in browser'
  s.description = 'Run files through markdown processor and open in a browser.' +
                  '  Adds a default theme.  Works with wkhtmltopdf.'
 
  s.required_rubygems_version = '>= 1.3.6'
  s.add_dependency 'bluecloth'
  s.add_development_dependency 'minitest'
 
  s.files        = Dir.glob('*.{rb,.md}') + %w(mdprev)
  s.bindir       = '.'
  s.executables  = ['mdprev']
end
