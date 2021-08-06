# frozen_string_literal: true

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
  rescue StandardError
    false
  end

  protected

  def validate!
    validate_type!
  end

  def validate_type!
    raise 'Длина названия типа вагона меньше 4 символов' if type.length < 4
  end
end
