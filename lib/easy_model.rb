# coding: utf-8

#
# データベースに依存しないモデルの基本クラスや, ActiveRecord と同じ型変換を行う属性定義メソッドを提供する.
#
module EasyModel

  %w(column base search_form).each do |name|
    require "easy_model/#{name}"
  end

end

