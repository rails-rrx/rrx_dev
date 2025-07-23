module RrxDev
  class SwaggerGenerator < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)

    def generate!
      copy_new_file 'spec/swagger_helper.rb'
      copy_new_file 'config/initializers/api_docs.rb'
      empty_directory 'spec/integration'
    end
  end
end
