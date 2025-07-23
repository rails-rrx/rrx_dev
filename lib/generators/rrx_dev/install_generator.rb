# frozen_string_literal: true

module RrxDev
  class InstallGenerator < Rails::Generators::Base
    GEM_SPEC_APP_NAME = 'dummy'
    GEM_SPEC_APP_ROOT = 'spec/dummy'

    source_root File.expand_path('templates', __dir__)

    def install_rules
      copy_file 'editorconfig', '.editorconfig'
      copy_file 'rubocop.yml', '.rubocop.yml'
    end

    def install_environment
      directory 'config'
    end

    def install_rspec
      copy_file 'rspec', '.rspec'
      empty_directory 'spec/factories'
      empty_directory 'spec/support'
      empty_directory 'spec/models'
      empty_directory 'spec/requests'
      copy_file 'spec/spec_helper.rb'
      remove_file 'spec/rails_helper.rb'

      # # Override rails_helper and make sure it loads the Rails environment for the app
      # # or the gem's spec dummy app
      # copy_file 'spec/rails_helper.rb' do |content|
      #   content.sub '../config/environment', "../#{app_config}/environment"
      # end
    end

    def install_spec_app
      return unless gem?

      in_root do
        unless app_path.exist?
          inside('spec') do
            run 'rails new --api -G --skip-docker -M --skip-active-job --skip-bootsnap -C -A -J -T -B dummy'
          end
          %w[development test production].each do |environment|
            remove_file app_environments.join("#{environment}.rb")
          end
        end
      end
    end

    private

    def project_path
      @project_path ||= Pathname(destination_root).freeze
    end

    def app_path
      @app_path ||= (gem? ? project_path.join(GEM_SPEC_APP_ROOT) : project_path).freeze
    end

    def app_config
      @app_config ||= app_path.join('config').freeze
    end

    def app_environments
      @app_environments ||= app_config.join('environments')
    end

    def gem?
      target_type == :gem
    end

    def app?
      target_type == :app
    end

    def target_type
      @target_type ||= begin
                         if project_path.glob('*.gemspec').any?
                           :gem
                         else
                           :app
                         end
                       end
    end
  end
end
