# coding: utf-8

require File.join(File.dirname(__FILE__), '..', 'helper')

class EasyModel::TestColumn < Test::Unit::TestCase

  def test_has_column_method
    model = Class.new
    model.send(:include, EasyModel::Column)
    assert model.protected_methods.include?(:column)
  end

  def test_string_column
    model = Class.new
    model.send(:include, EasyModel::Column)
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
    model = Class.new
    model.send(:include, EasyModel::Column)
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
    model = Class.new
    model.send(:include, EasyModel::Column)
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
    model = Class.new
    model.send(:include, EasyModel::Column)
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
    model = Class.new
    model.send(:include, EasyModel::Column)
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
    model = Class.new
    model.send(:include, EasyModel::Column)
    model.send(:column, :column_with_default, :datetime, :default => Time.parse('2000-01-01 10:20:30'))
    model.send(:column, :column_without_default, :datetime)
    object = model.new

    # 未代入の場合にデフォルト値が取得できること.
    assert_nil object.column_without_default
    assert_equal Time.parse('2000-01-01 10:20:30'), object.column_with_default

    # 代入した値が取得できること.
    object.column_with_default = Time.parse('2000-02-01 10:20:30')
    assert_equal Time.parse('2000-02-01 10:20:30'), object.column_with_default

    # 値の変換が行われること.
    object.column_with_default = '2000-03-01 10:20:30'
    assert_equal Time.parse('2000-03-01 10:20:30'), object.column_with_default
  end

  def test_timestamp_column
    model = Class.new
    model.send(:include, EasyModel::Column)
    model.send(:column, :column_with_default, :timestamp, :default => Time.parse('2000-01-01 10:20:30'))
    model.send(:column, :column_without_default, :timestamp)
    object = model.new

    # 未代入の場合にデフォルト値が取得できること.
    assert_nil object.column_without_default
    assert_equal Time.parse('2000-01-01 10:20:30'), object.column_with_default

    # 代入した値が取得できること.
    object.column_with_default = Time.parse('2000-02-01 10:20:30')
    assert_equal Time.parse('2000-02-01 10:20:30'), object.column_with_default

    # 値の変換が行われること.
    object.column_with_default = '2000-03-01 10:20:30'
    assert_equal Time.parse('2000-03-01 10:20:30'), object.column_with_default
  end

  def test_time_column
    model = Class.new
    model.send(:include, EasyModel::Column)
    model.send(:column, :column_with_default, :time, :default => Time.parse('2000-01-01 10:20:30'))
    model.send(:column, :column_without_default, :time)
    object = model.new

    # 未代入の場合にデフォルト値が取得できること.
    assert_nil object.column_without_default
    assert_equal 10, object.column_with_default.hour
    assert_equal 20, object.column_with_default.min
    assert_equal 30, object.column_with_default.sec

    # 代入した値が取得できること.
    object.column_with_default = Time.parse('2000-02-01 20:30:40')
    assert_equal 20, object.column_with_default.hour
    assert_equal 30, object.column_with_default.min
    assert_equal 40, object.column_with_default.sec
  end

  def test_date_column
    model = Class.new
    model.send(:include, EasyModel::Column)
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
    model = Class.new
    model.send(:include, EasyModel::Column)
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
    model = Class.new
    model.send(:include, EasyModel::Column)
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

