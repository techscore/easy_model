# coding: utf-8

class EasyModel::Base

  include EasyModel::Column

  def self.inherited(base)
    $stderr.puts 'DEPRECATED: EasyModel::Base is deprecated. Instead to include EasyModel::Column.'
  end

end

