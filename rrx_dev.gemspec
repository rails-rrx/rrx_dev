# frozen_string_literal: true

require_relative 'lib/rrx_dev/version'

Gem::Specification.new do |spec|
  spec.name = 'rrx_dev'
  spec.version = RrxDev::VERSION
  spec.authors = ['Dan Drew']
  spec.email = ['dan.drew@hotmail.com']

  spec.summary = 'Ruby on Rails core development support'
  # spec.description = "TODO: Write a longer description or delete this line."
  spec.homepage = 'https://github.com/dan-drew/rrx_dev'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.6.0'

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/dan-drew/rrx_dev'
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end

  spec.post_install_message = <<-DOC

    To complete project setup, please run:

      bundle exec rrx_dev_init

  DOC

  spec.bindir = 'exe'
  spec.executables = %w[rrx_dev_setup]
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', RrxDev::RAILS_VERSION
  spec.add_dependency 'active_record_query_trace'
  spec.add_dependency 'bootsnap'
  spec.add_dependency 'debug'
  spec.add_dependency 'factory_bot_rails'
  spec.add_dependency 'listen'
  spec.add_dependency 'railties', RrxDev::RAILS_VERSION
  spec.add_dependency 'rake', '>= 13.0'
  spec.add_dependency 'rspec', '>= 3.0'
  spec.add_dependency 'rspec-parameterized'
  spec.add_dependency 'rspec-rails'
  spec.add_dependency 'rswag-specs'
  spec.add_dependency 'rubocop', '>= 1.21'
  spec.add_dependency 'rubocop-rails'
  spec.add_dependency 'spring'
  spec.add_dependency 'thor'
end
