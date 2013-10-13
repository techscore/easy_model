# coding: utf-8

require File.join(File.dirname(__FILE__), '..', 'helper')

class EasyModel::TestSearchForm < Test::Unit::TestCase

  def test_persisted?
    model = Class.new(EasyModel::SearchForm) do
      def scoped
        delegatee = Class.new do
          def method_missing(method_name, *arguments)
            "#{method_name} called"
          end
        end
        delegatee.new
      end
    end
    object = model.new

    assert_equal 'all called', object.all
    assert_equal 'order called', object.order
    assert_equal 'count called', object.count
    assert_equal 'to_xml called', object.to_xml
  end

  def test_scoped
    assert_raise(NotImplementedError) do
      Class.new(EasyModel::SearchForm).new.scoped
    end
  end

end

