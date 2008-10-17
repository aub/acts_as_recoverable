def article(num_comments, options={})
  result = Article.create({ 
    :name => 'test_article'}.merge(options))
  num_comments.times do |idx|
    result.comments << comment(:content => "#{idx}")
  end
  result.save
  result
end

def comment(options={})
  Comment.create({
    :content => 'flame comment' }.merge(options))
end

def rating(options={})
  Rating.create({
    :value => 1 }.merge(options))
end

def author(options={})
  Author.create({
    :name => 'Jack Handey' }.merge(options))    
end

def listing(num_locations, options={})
  result = Listing.create({ 
    :name => 'test_listing'}.merge(options))
  num_locations.times do |idx|
    result.locations << location(:address => "#{idx}")
  end
  result.save
  result
end

def location(options={})
  Location.create({
    :address => '1 Main St., Orange Park, FL' }.merge(options))    
end
