# coding: utf-8

#
# 検索フォームの基本クラス.
#
# ==== 詳細
# ActiveRecord::Relation と同じインタフェースのメソッドをインスタンスメソッドとして持つ.
# 派生クラスは ActiveRecord::Relation を返す scoped メソッドを定義しなければならない.
# scoped メソッドの戻り値には all や exists? などの処理が delegate される.
#
class EasyModel::SearchForm

  include EasyModel::Column

  # from active_record/querying.rb
  delegate :find, :first, :first!, :last, :last!, :all, :exists?, :any?, :many?, :to => :scoped
  delegate :first_or_create, :first_or_create!, :first_or_initialize, :to => :scoped
  delegate :destroy, :destroy_all, :delete, :delete_all, :update, :update_all, :to => :scoped
  delegate :find_each, :find_in_batches, :to => :scoped
  delegate :select, :group, :order, :except, :reorder, :limit, :offset, :joins,
           :where, :preload, :eager_load, :includes, :from, :lock, :readonly,
           :having, :create_with, :uniq, :to => :scoped
  delegate :count, :average, :minimum, :maximum, :sum, :calculate, :pluck, :to => :scoped

  # from active_record/relation/delegation.rb
  delegate :to_xml, :to_yaml, :length, :collect, :map, :each, :all?, :include?, :to_ary, :to => :scoped

  #
  # ActiveRecord::Relation を返す.
  #
  # ==== 詳細
  # このメソッドは派生クラスによって上書きされることを前提としている.
  #
  # ==== 戻り値
  # ActiveRecord::Relation.
  #
  def scoped
    raise NotImplementedError, 'Must define `scoped` method.'
  end

end

