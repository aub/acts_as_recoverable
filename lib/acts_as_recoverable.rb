require 'ruby-debug'

module Patch
  module Acts
    module Recoverable
      
      def acts_as_recoverable
        return if self.included_modules.include?(InstanceMethods)
        
        include InstanceMethods
      end
      
      module InstanceMethods
        def self.included(base)
          base.class_eval do
            before_destroy :create_recoverable_object_for
          end
        end

        def create_recoverable_object_for(object = self, results = {})
          RecoverableObject.create(:object => object)
        end

        def destroy!
          def self.create_recoverable_object_for; end # is there a cleaner way to do this?
          destroy
        end
      end
    end
  end
end
