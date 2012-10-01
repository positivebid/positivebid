
# force load existing stuff
Ardes::ResourcesController::Helper

module Ardes
  module ResourcesController
    module Helper

      def simple_form_for_resource(*args, &block)
        options = args.extract_options!
        resource = args[0] || self.resource
        simple_form_for(resource, form_for_resource_options(resource, resource_name, options), &block)
      end

    end
  end
end

