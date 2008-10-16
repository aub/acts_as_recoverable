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
            alias_method_chain :destroy, :recoverable
          end
        end

        def destroy_with_recoverable
          create_recoverable_objects_for(self, nil)
          destroy_without_recoverable
        end

        def create_recoverable_objects_for(object, parent)
          parent_recoverable = RecoverableObject.create(:object => object, :parent => parent)

          object.class.reflections.each do |name, reflection|
            if reflection.options[:dependent] == :destroy
              Array(object.send(name)).each do |child|
                create_recoverable_objects_for(child, parent_recoverable) unless child.nil?
              end
            end
          end
        end
      end
    end
  end
end