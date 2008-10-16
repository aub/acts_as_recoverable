require File.join(File.dirname(__FILE__), 'test_helper')

class ActsAsRecoverableTest < Test::Unit::TestCase
  
  def teardown
    [Article, Comment, Publication, RecoverableObject, Rating, Comment].each do |klass| 
      klass.all.each { |a| a.destroy }
    end
  end
  
  def test_factories
    a = article(2, :name => 'hackery')
    a.save
    a.reload
    assert_equal 2, a.comments.size
  end
  
  def test_should_be_removed_from_finds_when_destroyed
    a = article(2, :name => 'hack1')
    a.destroy
    assert_nil Article.find_by_name('hack1')
    assert_nil Comment.find_by_content('c1')
  end

  def test_should_be_added_to_recoverable_objects_when_destroyed
    a = article(0, :name => 'oooh')
    a.destroy
    assert_equal 1, RecoverableObject.all.size
  end
  
  def test_should_add_recoverable_objects_for_dependent_children
    a = article(4)
    a.destroy
    assert_equal 5, RecoverableObject.all.size
  end
  
  def test_should_recursively_add_recoverable_objects
    a = article(1)
    a.comments.first.ratings = [rating, rating]
    a.destroy
    assert_equal 4, RecoverableObject.all.size
  end
  
  def test_should_not_create_recoverable_objects_for_non_dependent_destroy_associations
    a = article(2)
    a.authors = [author, author]
    a.destroy
    assert_equal 3, RecoverableObject.all.size
  end  
end
