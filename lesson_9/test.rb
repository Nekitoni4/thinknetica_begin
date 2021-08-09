# require_relative '../lesson_9/modules/accessors'
#
# class A
#   include Accessors
#
#   strong_attr_accessor :a, String
#
#   def initialize
#     @a = 1
#     @b = 2
#     @c = 3
#   end
#
# end
#
# a = A.new
#
# a.a = 1

require_relative '../lesson_9/modules/validation'

class TestValidate
  include Validation

  validate :name, :presence
  validate :format, :type, Integer
  validate :type, :format, /^[a-z]+$/

  def initialize
    @name = 123
    @format = 454
    @type = "1234"
  end
end

test = TestValidate.new

test.validate!