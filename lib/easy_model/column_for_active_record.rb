# coding: utf-8

require 'active_record'

#
# テーブルに存在しないカラムを定義する機能を提供する.
#
# ==== 詳細
# attr_accessor による属性定義とは異なり, データ型及びデフォルト値を指定することが可能.
#
module EasyModel::ColumnForActiveRecord

  def self.included(base)
    base.extend(EasyModel::ColumnForActiveRecord::ClassMethods)
  end

  #
  # 属性名の配列.
  #
  # ==== 戻り値
  # EasyModel::ColumnForActiveRecord::ClassMethods#column で定義した属性名を文字列配列として返す.
  #
  def easy_model_attribute_names
    self.class.easy_model_attribute_names
  end

  #
  # 属性名と値を保持するハッシュ.
  #
  # ==== 戻り値
  # {属性名 => 値} であるハッシュ.
  #
  def easy_model_attributes
    self.class.easy_model_attribute_names.reduce({}) do |map, name|
      map.tap{map[name] = send(name)}
    end
  end

end

module EasyModel::ColumnForActiveRecord::ClassMethods

  #
  # #column メソッドで定義した属性名.
  #
  # ==== 戻り値
  # #column メソッドで定義した属性名 String の配列として返す.
  #
  def easy_model_attribute_names
    (@easy_model_attribute_names || []).dup
  end

  #
  # ロケールファイルからルックアップするときのキー.
  #
  def i18n_scope
    :easy_model
  end

  protected

  #
  # テーブルに存在しないカラムを定義する.
  #
  # ==== 引数
  # name:: カラム名.
  # type:: データ型.
  # options [:default]:: デフォルト値. 省略した場合は nil.
  #
  # ==== 戻り値
  # 定義したカラムを表す ActiveRecord::ConnectionAdapters::Column オブジェクト.
  #
  def column(name, type, options={})
    (@easy_model_attribute_names ||= []) << name.to_s

    ActiveRecord::ConnectionAdapters::Column.new(name, options[:default], type, true).tap do |column|
      define_method("#{name}=") do |value|
        value = nil if column.number? and value.kind_of?(String) and value.blank?
        return if value == send(name)
        instance_variable_set("@#{name}_before_type_cast", value)
        instance_variable_set("@#{name}", column.type_cast(value))
      end
      define_method("#{name}_before_type_cast") do
        instance_variable_set("@#{name}_before_type_cast", column.default) unless instance_variable_defined?("@#{name}_before_type_cast")
        instance_variable_get("@#{name}_before_type_cast")
      end
      define_method(name) do
        instance_variable_set("@#{name}", column.default) unless instance_variable_defined?("@#{name}")
        instance_variable_get("@#{name}")
      end
    end
  end

end

