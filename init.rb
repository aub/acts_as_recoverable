require File.join(File.dirname(__FILE__), 'lib', 'acts_as_recoverable')
require File.join(File.dirname(__FILE__), 'lib', 'recoverable_object')

ActiveRecord::Base.send(:extend, Patch::Acts::Recoverable)