# coding: utf-8
require File.join(Dir::pwd, 'test', 'helper.rb')
# require File.join(File.dirname(__FILE__), '..', 'helper')

class EasyModel::TestColumnForActiveModel < Test::Unit::TestCase

  def setup
    Time.zone = 'Hawaii'
    I18n.load_path = [File.join(File.dirname(__FILE__), 'ja.yml')]
    I18n.default_locale = :ja
    ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'test.sqlite3')
    ActiveRecord::Base.connection.execute('BEGIN')
    ActiveRecord::Base.connection.execute('DROP TABLE IF EXISTS users')
    ActiveRecord::Base.connection.execute('CREATE TABLE users (id INTEGER PRIMARY KEY)')
  end

  def teardown
    ActiveRecord::Base.connection.execute('ROLLBACK')
  end

  def new_model
    Class.new do
      include EasyModel::Column
      column :name, :string
      column :email, :string
      column :age, :integer
      def self.name; 'User'; end
    end
  end

  def test_initialize
    user = new_model.new(:name => 'taro', :email => 'taro@example.com', :age => 20)
    assert_equal 'taro', user.name
    assert_equal 'taro@example.com', user.email
    assert_equal 20, user.age
  end

  def test_easy_model_attribute_names_class_method
    assert_equal %w(name email age), new_model.easy_model_attribute_names
  end

  def test_easy_model_attribute_names_instance_method
    assert_equal %w(name email age), new_model.new.easy_model_attribute_names
  end

  def test_attribute_names_class_method
    assert_equal %w(name email age), new_model.attribute_names
  end

  def test_attribute_names_instance_method
    assert_equal %w(name email age), new_model.new.attribute_names
  end

  def test_easy_model_attributes
    attributes = {:name => 'taro', :email => 'taro@example.com', :age => 20}
    assert_equal attributes.stringify_keys, new_model.new(attributes).easy_model_attributes
  end

  def test_attributes
    attributes = {:name => 'taro', :email => 'taro@example.com', :age => 20}
    assert_equal attributes.stringify_keys, new_model.new(attributes).attributes
  end

  def test_attributes=
    object = new_model.new
    object.attributes = {:name => 'taro', :email => 'taro@example.com', :age => 20}
    assert_equal 'taro', object.name
    assert_equal 'taro@example.com', object.email
    assert_equal 20, object.age
  end

  def test_dirty
    object = new_model.new(:name => 'taro', :email => 'taro@example.com', :age => 20)
    assert_equal true, object.changed?
    assert_equal true, object.name_changed?
    assert_equal nil, object.name_was
    assert_equal [nil, 'taro'], object.name_change
    assert_equal true, object.email_changed?
    assert_equal nil, object.email_was
    assert_equal [nil, 'taro@example.com'], object.email_change
    assert_equal true, object.age_changed?
    assert_equal nil, object.age_was
    assert_equal [nil, 20], object.age_change

    object.send(:clear_changes_information)
    assert_equal false, object.changed?

    object.age = 21
    assert_equal true, object.changed?
    assert_equal false, object.name_changed?
    assert_equal 'taro', object.name_was
    assert_equal nil, object.name_change
    assert_equal false, object.email_changed?
    assert_equal 'taro@example.com', object.email_was
    assert_equal nil, object.email_change
    assert_equal true, object.age_changed?
    assert_equal 20, object.age_was
    assert_equal [20, 21], object.age_change
  end

  def test_i18n_scope
    model = new_model
    assert_equal :easy_model, model.i18n_scope
    assert_equal 'ユーザ', model.model_name.human
    assert_equal '名前', model.human_attribute_name(:name)
    assert_equal 'メールアドレス', model.human_attribute_name(:email)
    assert_equal '年齢', model.human_attribute_name(:age)
  end

  def test_persisted?
    assert_equal false, new_model.new.persisted?
  end

  def test_has_column_method
    model = new_model
    model.send(:column, :integer_column, :integer)
    assert model.protected_methods.include?(:column)

    object = model.new
    assert object.respond_to?(:integer_column)
    assert object.respond_to?(:integer_column=)
    assert object.respond_to?(:integer_column_before_type_cast)
  end

  def test_before_type_cast
    model = new_model
    model.send(:column, :integer_column, :integer)
    object = model.new

    object.integer_column = ''
    assert_nil object.integer_column
    assert_nil object.integer_column_before_type_cast

    object.integer_column = '777'
    assert_equal 777, object.integer_column
    assert_equal '777', object.integer_column_before_type_cast

    object.integer_column = true
    assert_equal 1, object.integer_column
    assert_equal true, object.integer_column_before_type_cast

    object.integer_column = false
    assert_equal 0, object.integer_column
    assert_equal false, object.integer_column_before_type_cast
  end

  def test_string_column
    model = new_model
    model.send(:column, :column_with_default, :string, :default => 'default value')
    model.send(:column, :column_without_default, :string)
    object = model.new

    # 未代入の場合にデフォルト値が取得できること.
    assert_equal 'default value', object.column_with_default
    assert_nil object.column_without_default

    # 代入した値が取得できること.
    object.column_with_default = 'other value'
    assert_equal 'other value', object.column_with_default
  end

  def test_text_column
    model = new_model
    model.send(:column, :column_with_default, :text, :default => 'default value')
    model.send(:column, :column_without_default, :text)
    object = model.new

    # 未代入の場合にデフォルト値が取得できること.
    assert_equal 'default value', object.column_with_default
    assert_nil object.column_without_default

    # 代入した値が取得できること.
    object.column_with_default = 'other value'
    assert_equal 'other value', object.column_with_default
  end

  def test_integer_column
    model = new_model
    model.send(:column, :column_with_default, :integer, :default => 777)
    model.send(:column, :column_without_default, :integer)
    object = model.new

    # 未代入の場合にデフォルト値が取得できること.
    assert_nil object.column_without_default
    assert_equal 777, object.column_with_default

    # 代入した値が取得できること.
    object.column_with_default = 123
    assert_equal 123, object.column_with_default

    # 値の変換が行われること.
    object.column_with_default = '789'
    assert_equal 789, object.column_with_default
  end

  def test_float_column
    model = new_model
    model.send(:column, :column_with_default, :float, :default => 1.5)
    model.send(:column, :column_without_default, :float)
    object = model.new

    # 未代入の場合にデフォルト値が取得できること.
    assert_nil object.column_without_default
    assert_equal 1.5, object.column_with_default

    # 代入した値が取得できること.
    object.column_with_default = 2.5
    assert_equal 2.5, object.column_with_default

    # 値の変換が行われること.
    object.column_with_default = '3.5'
    assert_equal 3.5, object.column_with_default
    object.column_with_default = 3
    assert_equal 3.0, object.column_with_default
  end

  def test_decimal_column
    model = new_model
    model.send(:column, :column_with_default, :decimal, :default => 1.5)
    model.send(:column, :column_without_default, :decimal)
    object = model.new

    # 未代入の場合にデフォルト値が取得できること.
    assert_nil object.column_without_default
    assert_equal 1.5, object.column_with_default

    # 代入した値が取得できること.
    object.column_with_default = 2.5
    assert_equal 2.5, object.column_with_default

    # 値の変換が行われること.
    object.column_with_default = '3.5'
    assert_equal 3.5, object.column_with_default
    object.column_with_default = 3
    assert_equal 3.0, object.column_with_default
  end

  def test_datetime_column
    model = new_model
    model.send(:column, :column_with_default, :datetime, :default => Time.zone.parse('2000-01-01 10:20:30'))
    model.send(:column, :column_without_default, :datetime)
    object = model.new

    # 未代入の場合にデフォルト値が取得できること.
    assert_nil object.column_without_default
    assert_equal Time.zone.parse('2000-01-01 10:20:30'), object.column_with_default

    # 代入した値が取得できること.
    object.column_with_default = Time.zone.parse('2000-02-01 10:20:30')
    assert_equal Time.zone.parse('2000-02-01 10:20:30'), object.column_with_default

    # 値の変換が行われること.
    object.column_with_default = Time.zone.parse('2000-03-01 10:20:30')
    assert_equal Time.zone.parse('2000-03-01 10:20:30'), object.column_with_default
  end

  def test_timestamp_column
    model = new_model
    model.send(:column, :column_with_default, :timestamp, :default => Time.zone.parse('2000-01-01 10:20:30'))
    model.send(:column, :column_without_default, :timestamp)
    object = model.new

    # 未代入の場合にデフォルト値が取得できること.
    assert_nil object.column_without_default
    assert_equal Time.zone.parse('2000-01-01 10:20:30'), object.column_with_default

    # 代入した値が取得できること.
    object.column_with_default = Time.zone.parse('2000-02-01 10:20:30')
    assert_equal Time.zone.parse('2000-02-01 10:20:30'), object.column_with_default

    # 値の変換が行われること.
    object.column_with_default = Time.zone.parse('2000-03-01 10:20:30')
    assert_equal Time.zone.parse('2000-03-01 10:20:30'), object.column_with_default
  end

  def test_time_column
    model = new_model
    model.send(:column, :column_with_default, :time, :default => Time.zone.parse('2000-01-01 10:20:30'))
    model.send(:column, :column_without_default, :time)
    object = model.new

    # 未代入の場合にデフォルト値が取得できること.
    assert_nil object.column_without_default
    assert_equal 10, object.column_with_default.hour
    assert_equal 20, object.column_with_default.min
    assert_equal 30, object.column_with_default.sec

    # 代入した値が取得できること.
    object.column_with_default = Time.zone.parse('2000-02-01 20:30:40')
    assert_equal 20, object.column_with_default.hour
    assert_equal 30, object.column_with_default.min
    assert_equal 40, object.column_with_default.sec
  end

  def test_date_column
    model = new_model
    model.send(:column, :column_with_default, :date, :default => Date.parse('2000-01-01'))
    model.send(:column, :column_without_default, :date)
    object = model.new

    # 未代入の場合にデフォルト値が取得できること.
    assert_nil object.column_without_default
    assert_equal Date.parse('2000-01-01'), object.column_with_default

    # 代入した値が取得できること.
    object.column_with_default = Date.parse('2000-02-01')
    assert_equal Date.parse('2000-02-01'), object.column_with_default

    # 値の変換が行われること.
    object.column_with_default = '2000-03-01'
    assert_equal Date.parse('2000-03-01'), object.column_with_default
  end

  def test_binary_column
    model = new_model
    model.send(:column, :column_with_default, :binary, :default => 'default value')
    model.send(:column, :column_without_default, :binary)
    object = model.new

    # 未代入の場合にデフォルト値が取得できること.
    assert_equal 'default value', object.column_with_default
    assert_nil object.column_without_default

    # 代入した値が取得できること.
    object.column_with_default = 'other value'
    assert_equal 'other value', object.column_with_default
  end

  def test_boolean_column
    model = new_model
    model.send(:column, :column_with_default, :boolean, :default => true)
    model.send(:column, :column_without_default, :boolean)
    object = model.new

    # 未代入の場合にデフォルト値が取得できること.
    assert_nil object.column_without_default
    assert_equal true, object.column_with_default

    # 代入した値が取得できること.
    object.column_with_default = false
    assert_equal false, object.column_with_default

    # 値の変換が行われること.
    object.column_with_default = 'true'
    assert_equal true, object.column_with_default
    object.column_with_default = 'false'
    assert_equal false, object.column_with_default
    object.column_with_default = '1'
    assert_equal true, object.column_with_default
    object.column_with_default = '0'
    assert_equal false, object.column_with_default
  end

end

