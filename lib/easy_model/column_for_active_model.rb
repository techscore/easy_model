# coding: utf-8

require 'active_model'
require 'active_record'

#
# テーブルに存在しないカラムを定義する機能を提供する.
#
# ==== 詳細
# attr_accessor による属性定義とは異なり, データ型及びデフォルト値を指定することが可能.
#
module EasyModel::ColumnForActiveModel

  def self.included(base)
    base.send(:include, ActiveModel::Model)
    base.send(:include, ActiveModel::Dirty)
    base.send(:include, ActiveModel::Serializers::Xml)
    base.send(:include, ActiveRecord::AttributeAssignment)
    base.extend(EasyModel::ColumnForActiveModel::ClassMethods)
  end

  #
  # 属性名の配列.
  #
  # ==== 戻り値
  # EasyModel::ColumnForActiveModel::ClassMethods#column で定義した属性名を文字列配列として返す.
  #
  def easy_model_attribute_names
    self.class.easy_model_attribute_names
  end
  alias_method :attribute_names, :easy_model_attribute_names

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
  alias_method :attributes, :easy_model_attributes

  #
  # 属性の変更情報をリセットする.
  #
  # ==== 詳細
  # 属性の変更情報をリセットすると, #changed? は false を返すようになる.
  #
  def reset_changes
    @previously_changed = {}
    @changed_attributes = {}
  end

end

module EasyModel::ColumnForActiveModel::ClassMethods

  #
  # #column メソッドで定義した属性名.
  #
  # ==== 戻り値
  # #column メソッドで定義した属性名 String の配列として返す.
  #
  def easy_model_attribute_names
    (@easy_model_attribute_names || []).dup
  end
  alias_method :attribute_names, :easy_model_attribute_names

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
    cast_type = "ActiveRecord::Type::#{type.to_s.capitalize}"
    cast_type = "ActiveRecord::Type::DateTime" if type.to_s == "datetime"
    cast_type = "ActiveRecord::Type::Time" if type.to_s == "timestamp"

    define_attribute_method(name)
    (@easy_model_attribute_names ||= []) << name.to_s

    ActiveRecord::ConnectionAdapters::Column.new(name, options[:default], cast_type.classify.constantize.new, type, true).tap do |column|
      define_method("#{name}=") do |value|
        value = nil if column.number? and value.kind_of?(String) and value.blank?
        return if value == send(name)
        send("#{name}_will_change!")
        instance_variable_set("@#{name}_before_type_cast", value)
        instance_variable_set("@#{name}", column.cast_type.type_cast_from_user(value))
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

