require_relative '../lesson_9/modules/accessors'
require_relative '../lesson_9/modules/validation'

class A
  include Accessors

  strong_attr_accessor :a, String

  def initialize
    @a = 3
    @b = 2
    @c = 3
  end
end

class TestValidate
  include Validation

  validate :name, :presence
  validate :format, :type, Integer
  validate :type, :format, /^[a-z]+$/

  def initialize
    @name = 123
    @format = '123'
    @type = 'asdf'
  end
end

a = A.new
a.a = 3
test = TestValidate.new
test.validate!