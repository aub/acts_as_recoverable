require File.join(File.dirname(__FILE__), 'test_helper')

class RecoverableObjectTest < Test::Unit::TestCase

  def teardown
    [Article, Comment, Publication, RecoverableObject, Rating, Comment].each do |klass| 
      klass.all.each { |a| a.destroy }
    end
  end

  def test_should_be_initializable_from_an_object
    a = article(0, :name => 'woot')
    r = RecoverableObject.new(:object => a)
    assert_equal 'Article', r.object_type
    assert_equal a.attributes, r.object_attributes
  end

  def test_should_have_self_referential_has_many
    ro1 = RecoverableObject.new
    ro2 = RecoverableObject.new
    ro3 = RecoverableObject.new
    
    ro1.children = [ro2, ro3]
    ro1.save
    ro1.reload
    assert_equal 2, ro1.children.size
    assert_equal ro1, ro2.parent
    assert_equal [ro2, ro3], ro1.children
  end
  
  def test_recovery_of_an_object
    a = article(0, :name => 'Yankees Lose')
    a.destroy
    ro = RecoverableObject.first
    recovered_article = ro.recover
    assert recovered_article.is_a?(Article)
    assert_equal 'Yankees Lose', recovered_article.name
  end
  
  def test_should_recover_associated_objects
    a = article(3, :name => 'Economy Collapses')
    a.destroy
    assert_equal 0, Article.count + Comment.count
    ro = RecoverableObject.find_by_parent_id(nil)
    assert_not_nil ro
    recovered_article = ro.recover
    assert_equal 3, recovered_article.comments.size
  end

end