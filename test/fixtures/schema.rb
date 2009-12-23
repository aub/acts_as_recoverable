ActiveRecord::Schema.define(:version => 1) do

  create_table :publications, :force => true do |t|
    t.string :name
    t.timestamps
  end
  
  create_table :articles, :force => true do |t|
    t.string :name
    t.timestamps
  end

  create_table :authors, :force => true do |t|
    t.string :name
    t.references :article
    t.timestamps
  end

  create_table :comments, :force => true do |t|
    t.text :content
    t.references :article
    t.timestamps
  end
  
  create_table :ratings, :force => true do |t|
    t.integer :value
    t.references :comment
    t.timestamps
  end

  create_table :listings, :force => true do |t|
    t.string :name
    t.timestamps
  end

  create_table :locations, :force => true do |t|
    t.string :address
    t.timestamps
  end

  create_table :listings_locations, :force => true, :id => false do |t|
    t.references :listing, :location
    t.timestamps
  end
  
  create_table :recoverable_objects, :force => true do |t|
    t.text :object_hash
    t.timestamps
  end
end
