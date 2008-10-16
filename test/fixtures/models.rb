class Publication < ActiveRecord::Base
  has_many :articles, :dependent => :destroy
end

class Article < ActiveRecord::Base
  acts_as_recoverable
  
  has_many :comments, :dependent => :destroy
  has_many :authors
end

class Author < ActiveRecord::Base
  belongs_to :article
end

class Comment < ActiveRecord::Base
  belongs_to :article
  has_many :ratings, :dependent => :destroy
end

class Rating < ActiveRecord::Base
  belongs_to :comment
end