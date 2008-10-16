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
