# coding: utf-8

require File.join(File.dirname(__FILE__), '..', 'helper')

class User < EasyModel::Base
  column :name, :string
  column :email, :string
  column :age, :integer
end

class EasyModel::TestBase < Test::Unit::TestCase

  def setup
    I18n.load_path = [File.join(File.dirname(__FILE__), 'ja.yml')]
    I18n.default_locale = :ja
  end

  def test_initialize
    user = User.new(:name => 'taro', :email => 'taro@example.com', :age => 20)
    assert_equal 'taro', user.name
    assert_equal 'taro@example.com', user.email
    assert_equal 20, user.age
  end

  def test_attributes=
    user = User.new
    user.attributes = {:name => 'taro', :email => 'taro@example.com', :age => 20}
    assert_equal 'taro', user.name
    assert_equal 'taro@example.com', user.email
    assert_equal 20, user.age
  end

  def test_i18n_scope
    assert_equal :easy_model, User.i18n_scope
    assert_equal 'ユーザ', User.model_name.human
    assert_equal '名前', User.human_attribute_name(:name)
    assert_equal 'メールアドレス', User.human_attribute_name(:email)
    assert_equal '年齢', User.human_attribute_name(:age)
  end

  def test_persisted?
    user = User.new
    assert_equal false, user.persisted?
  end

end

