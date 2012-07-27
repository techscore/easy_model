# coding: utf-8

require 'active_model'

#
# テーブルに依存しないモデルの基本クラス.
#
class EasyModel::Base

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  include EasyModel::Column

  #
  # 指定された属性値で初期化する.
  #
  # ==== 引数
  # attributes::
  #   属性値を保持する Hash.
  #
  def initialize(attributes=nil)
    (attributes || {}).each do |name, value|
      send("#{name}=", value)
    end
  end

  #
  # オブジェクトが永続化されているか判定する.
  #
  # ==== 戻り値
  # DB に関連付かないモデルのため常に false.
  #
  def persisted?
    false
  end

end

