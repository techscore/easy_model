# coding: utf-8

require 'active_record'

#
# テーブルに存在しないカラムを定義する機能を提供する.
#
# ==== 詳細
# attr_accessor による属性定義とは異なり, データ型及びデフォルト値を指定することが可能.
#
module EasyModel::Column

  def self.included(base)
    base.extend(EasyModel::Column::ClassMethods)
  end

end

module EasyModel::Column::ClassMethods

  protected

  #
  # テーブルに存在しないカラムを定義する.
  #
  # ==== 引数
  # name::
  #   カラム名.
  #
  # type::
  #   データ型.
  #
  # options [:default]::
  #   デフォルト値.
  #   省略した場合は nil.
  #
  # ==== 戻り値
  # 定義したカラムを表す ActiveRecord::ConnectionAdapters::Column オブジェクト.
  #
  def column(name, type, options={})
    ActiveRecord::ConnectionAdapters::Column.new(name, options[:default], type, true).tap do |column|
      define_method("#{name}=") do |value|
        value = nil if column.number? and value.kind_of?(String) and value.blank?
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

