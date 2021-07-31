require_relative '../modules/manufacture_company'

class TrainCar

  include ManufactureCompany

  attr_reader :type

  def initialize(type)
    raise 'Передайте, пожалуйста, валидный тип вагона' unless valid?(type)
    @type = type
  end

  def valid?(type)
    validate type
    true
  rescue
    false
  end

  protected

  def validate(type)
    raise if type.length < 10
  end
end