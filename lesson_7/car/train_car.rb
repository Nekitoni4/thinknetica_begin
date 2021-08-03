require_relative '../modules/manufacture_company'

class TrainCar

  include ManufactureCompany

  attr_reader :type

  def initialize(type)
    @type = type
    validate!
  end

  def valid?(type)
    validate type
    true
  rescue
    false
  end

  protected

  def validate!
    validate_type!
  end

  def validate_type!
    raise 'Длина названия типа вагона меньше 10 символов' if self.type.length < 4
  end
end