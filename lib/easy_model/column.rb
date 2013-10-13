# coding: utf-8

require_relative 'column_for_active_model'
require_relative 'column_for_active_record'

#
# テーブルに存在しないカラムを定義する機能を提供する.
#
# ==== 詳細
# attr_accessor による属性定義とは異なり, データ型及びデフォルト値を指定することが可能.
#
module EasyModel::Column

  def self.included(base)
    if base < ActiveRecord::Base
      base.send(:include, EasyModel::ColumnForActiveRecord)
    else
      base.send(:include, EasyModel::ColumnForActiveModel)
    end
  end

end

