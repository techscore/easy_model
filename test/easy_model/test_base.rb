# coding: utf-8

require File.join(File.dirname(__FILE__), '..', 'helper')

class EasyModel::TestBase < Test::Unit::TestCase

  def test_initialize
    model = Class.new(EasyModel::Base)
    model.send(:column, :name, :string)
    model.send(:column, :email, :string)
    model.send(:column, :age, :integer)

    object = model.new(:name => 'taro', :email => 'taro@example.com', :age => 20)
    assert_equal 'taro', object.name
    assert_equal 'taro@example.com', object.email
    assert_equal 20, object.age
  end

  def test_attributes=
    model = Class.new(EasyModel::Base)
    model.send(:column, :name, :string)
    model.send(:column, :email, :string)
    model.send(:column, :age, :integer)

    object = model.new
    object.attributes = {:name => 'taro', :email => 'taro@example.com', :age => 20}
    assert_equal 'taro', object.name
    assert_equal 'taro@example.com', object.email
    assert_equal 20, object.age
  end

  def test_persisted?
    model = Class.new(EasyModel::Base)
    object = model.new
    assert_equal false, object.persisted?
  end

end

