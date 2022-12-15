# frozen_string_literal: true

require_relative "lib/color_hash/version"

Gem::Specification.new do |spec|
  spec.name = "color_hash"
  spec.version = ColorHash::VERSION
  spec.authors = ["Nicolas Bettenburg"]
  spec.email = ["nicbet@kuy.io"]

  spec.summary = "Generate a color based on the given string."
  spec.description = "Generate a color based on the given string (in the HSL color space)."
  spec.homepage = "https://github.com/kuyio/color_hash"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/kuyio/color_hash"
  spec.metadata["changelog_uri"] = "https://github.com/kuyio/color_hash/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:doc|bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
