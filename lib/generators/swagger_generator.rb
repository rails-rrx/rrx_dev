require_relative 'base'

module RrxDev
  class SwaggerGenerator < Base
    def generate!
      copy_new_file 'spec/swagger_helper.rb'
      copy_new_file 'config/initializers/api_docs.rb'
      empty_directory 'spec/integration'
    end
  end
end
