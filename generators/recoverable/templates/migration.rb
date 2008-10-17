class RecoverableObjectsMigration < ActiveRecord::Migration
  def self.up
    create_table :recoverable_objects do |t|
      t.text :object_hash
      t.timestamps
    end
  end
  
  def self.down
    drop_table :recoverable_objects
  end
end
