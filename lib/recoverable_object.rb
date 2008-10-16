class RecoverableObject < ActiveRecord::Base
  belongs_to :parent, :foreign_key => 'parent_id', :class_name => 'RecoverableObject'
  has_many :children, :foreign_key => 'parent_id', :class_name => 'RecoverableObject'
  
  serialize :object_attributes
  
  def recover
    result = load_object
    return nil unless result
    children.each do |child| 
      child.recover
    end
    result.save
    result
  end
  
  def object=(object)
    self.object_type = object.class.name
    self.object_attributes = object.attributes
  end
  
  private
  
  # Create a new object by object type and then set all of the attributes
  # via setter methods to avoid restrictions on mass assignment.
  def load_object
    return nil unless object_type
    result = object_type.constantize.new
    object_attributes.each do |key, value|
      result.send("#{key}=", value)
    end
    result
  end
end