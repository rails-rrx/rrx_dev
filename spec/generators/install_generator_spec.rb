# frozen_string_literal: true
require 'generator_spec'
require 'generators/rrx_dev/install_generator'
require 'pathname'

RSpec.describe RrxDev::InstallGenerator, type: :generator do
  destination File.expand_path('../tmp/test_app', __dir__)

  let(:project_type) { :app }

  before do
    root = Pathname(destination_root)
    root.rmtree if root.exist?
    root.mkpath

    root.join('blah.gemspec').write('My gemspec!') if project_type == :gem
  end

  shared_examples 'install' do
    it 'generates the correct files' do
      is_gem = project_type == :gem

      run_generator

      expect(destination_root).to have_structure {
        file '.editorconfig'
        file '.rubocop.yml'
        file '.rspec'

        directory 'config' do
          directory 'environments' do
            file 'development.rb'
            file 'test.rb'
            file 'production.rb'
          end
        end

        directory 'spec' do
          directory 'factories'
          directory 'support'
          directory 'models'
          directory 'requests'
          file 'spec_helper.rb'
          no_file 'rails_helper.rb'
        end

        if is_gem
          directory 'spec/dummy' do
            directory 'config'
            directory 'app'
          end
        end
      }
    end
  end

  context 'application' do
    include_examples 'install'
  end

  context 'gem' do
    let(:project_type) { :gem }
    include_examples 'install'
  end
end
