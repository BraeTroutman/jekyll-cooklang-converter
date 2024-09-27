# frozen_string_literal: true

require_relative "lib/jekyll-cooklang-converter/version"

Gem::Specification.new do |spec|
  spec.name = "jekyll-cooklang-converter"
  spec.version = Jekyll::CooklangConverter::VERSION
  spec.authors = ["BraeTroutman"]
  spec.email = ["btroutma@redhat.com"]

  spec.summary = "A simple Jekyll Converter that maps .cook files to HTML"
  spec.homepage = "https://github.com/BraeTroutman/jekyll-cooklang-converter"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "jekyll", "~> 4.3", ">= 4.3.4"
  spec.add_dependency "cooklang_rb", "~> 0.2.0"

  # dev dependencies
  spec.add_development_dependency "rspec", "~> 3.2"
  spec.add_development_dependency "clash", "~> 2.3", ">= 2.3.1"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
