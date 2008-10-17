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
            before_destroy :create_recoverable_objects_for
          end
        end

        def create_recoverable_objects_for(object = self, parent = nil)
          parent_recoverable = RecoverableObject.create(:object => object, :parent => parent)

          object.class.reflections.each do |name, reflection|
            if reflection.options[:dependent] == :destroy
              Array(object.send(name)).each do |child|
                create_recoverable_objects_for(child, parent_recoverable) unless child.nil?
              end
            end
          end
        end

        def destroy!
          def self.create_recoverable_objects_for; end # is there a cleaner way to do this?
          destroy
        end
      end
    end
  end
end
