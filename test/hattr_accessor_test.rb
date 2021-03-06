require 'test/unit'
require File.dirname(__FILE__) + '/../lib/hattr_accessor'

class CustomField
  hattr_accessor :name, :type, :type => :string, :attribute => :configuration
  hattr_accessor :unit, :reference, :attribute => :configuration
  hattr_accessor :offset, :type => :integer, :attribute => :configuration
  hattr_accessor :amount, :type => :float, :attribute => :configuration
  hattr_accessor :required, :type => :boolean, :attribute => :configuration2
  
  def configuration2
    @configuration2 ||= { :some_default_reader_value => true }
  end
  
  def configuration2=(value)
    @configuration2 = value.merge(:some_default_writer_value => true)
  end
end

class HattrAccessorTest < Test::Unit::TestCase
  
  def setup
    @custom_field = CustomField.new
  end
  
  def test_configuration_should_be_a_hash_by_default
    assert_equal({}, @custom_field.configuration)
  end
  
  def test_should_set_name
    @custom_field.name = 'Date'
    assert_equal({ :name => 'Date' }, @custom_field.configuration)
  end
  
  def test_should_get_name
    @custom_field.name = 'Date'
    assert_equal 'Date', @custom_field.name
  end
  
  def test_should_type_cast_name_as_string
    assert_equal '', @custom_field.name
  end
  
  def test_should_set_and_get_an_attribute_named_type
    @custom_field.type = 'Date'
    assert_equal 'Date', @custom_field.type
  end
  
  def test_should_set_unit
    @custom_field.unit = 'days'
    assert_equal({ :unit => 'days' }, @custom_field.configuration)
  end
  
  def test_should_get_unit
    @custom_field.unit = 'days'
    assert_equal 'days', @custom_field.unit
  end
  
  def test_should_set_reference
    @custom_field.reference = 'from_now'
    assert_equal({ :reference => 'from_now' }, @custom_field.configuration)
  end
  
  def test_should_get_reference
    @custom_field.reference = 'from_now'
    assert_equal 'from_now', @custom_field.reference
  end
  
  def test_should_set_offset
    @custom_field.offset = 1
    assert_equal({ :offset => 1 }, @custom_field.configuration)
  end
  
  def test_should_get_offset
    @custom_field.offset = 1
    assert_equal 1, @custom_field.offset
  end
  
  def test_should_type_cast_offset_as_integer
    @custom_field.offset = '1'
    assert_equal 1, @custom_field.offset
  end
  
  def test_should_set_amount
    @custom_field.amount = 1.0
    assert_equal({ :amount => 1.0 }, @custom_field.configuration)
  end
  
  def test_should_get_amount
    @custom_field.amount = 1.0
    assert_equal 1.0, @custom_field.amount
  end
  
  def test_should_type_cast_amount_as_float
    @custom_field.amount = '1'
    assert_equal 1.0, @custom_field.amount
    
    @custom_field.amount = 1
    assert_equal 1.0, @custom_field.amount
  end
  
  def test_should_set_required_in_configuration2
    @custom_field.required = true
    assert_equal true, @custom_field.configuration2[:required]
  end
  
  def test_should_get_required
    @custom_field.required = true
    assert_equal true, @custom_field.required
  end
  
  def test_should_type_cast_required_as_boolean
    assert_equal false, @custom_field.required
    
    @custom_field.required = false
    assert_equal false, @custom_field.required
    
    @custom_field.required = 0
    assert_equal false, @custom_field.required
    
    @custom_field.required = '0'
    assert_equal false, @custom_field.required
    
    @custom_field.required = true
    assert_equal true, @custom_field.required
    
    @custom_field.required = 1
    assert_equal true, @custom_field.required
    
    @custom_field.required = '1'
    assert_equal true, @custom_field.required
    
    @custom_field.required = ''
    assert_equal false, @custom_field.required
  end
  
  def test_should_raise_exception_if_attribute_option_is_not_passed
    assert_raises Huberry::HattrAccessor::MissingAttributeError do
      CustomField.hattr_accessor :test
    end
  end
  
  def test_should_not_overwrite_existing_reader
    assert_equal true, @custom_field.configuration2[:some_default_reader_value]
  end
  
  def test_should_not_overwrite_existing_writer
    @custom_field.configuration2 = {}
    assert_equal true, @custom_field.configuration2[:some_default_writer_value]
  end
  
end