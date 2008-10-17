require File.join(File.dirname(__FILE__), 'test_helper')

class RecoverableObjectTest < Test::Unit::TestCase

  def teardown
    [Article, Comment, Publication, RecoverableObject, Rating, Comment, Listing, Location].each do |klass| 
      klass.all.each { |a| a.destroy }
    end
  end

  def test_should_be_initializable_from_an_object
    a = article(0, :name => 'woot')
    r = RecoverableObject.new(:object => a)
    assert_equal 'Article', r.object_hash[:type]
    assert_equal a.attributes, r.object_hash[:attributes]
  end

  def test_recovery_of_an_object
    a = article(0, :name => 'Yankees Lose')
    a.destroy
    ro = RecoverableObject.first
    recovered_article = ro.recover
    assert recovered_article.is_a?(Article)
    assert_equal 'Yankees Lose', recovered_article.name
  end

  def test_should_add_recoverable_objects_for_dependent_children
    a = article(4)
    a.destroy
    assert_equal 4, RecoverableObject.first.object_hash[:reflections][:comments].size
  end
  
  def test_should_recursively_add_recoverable_objects
    a = article(1)
    a.comments.first.ratings = [rating, rating]
    a.destroy
    assert_equal 2, RecoverableObject.first.object_hash[:reflections][:comments][0][:reflections][:ratings].size
  end
  
  def test_should_not_create_recoverable_objects_for_non_dependent_destroy_associations
    a = article(2)
    a.authors = [author, author]
    a.destroy
    assert_nil RecoverableObject.first.object_hash[:reflections][:authors]
  end  
  
  def test_should_recover_associated_objects
    a = article(3, :name => 'Economy Collapses')
    a.destroy
    assert_equal 0, Article.count + Comment.count
    ro = RecoverableObject.first
    assert_not_nil ro
    # recover! is required here because it will save the model, so it can
    # find its comments
    recovered_article = ro.recover!
    assert_equal 3, recovered_article.comments.size
  end

  def test_should_remove_the_recoverable_object_when_recovering_with_recover!
    a = article(3)
    a.destroy
    ro = RecoverableObject.first
    ro.recover!
    assert_equal 0, RecoverableObject.count
  end

  def test_should_not_save_when_calling_recover
    a = article(0)
    a.destroy
    ro = RecoverableObject.first
    a = ro.recover
    assert a.new_record?
  end
  
  def test_should_save_when_calling_recover!
    a = article(0)
    a.destroy
    ro = RecoverableObject.first
    a = ro.recover!
    assert !a.new_record?
  end
  
  def test_should_work_with_has_and_belongs_to_many
    l = listing(3)
    l.destroy
    ro = RecoverableObject.first
    l = ro.recover
    assert_equal 3, l.locations.size
  end
end