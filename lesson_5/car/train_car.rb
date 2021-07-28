require_relative '../modules/manufacture_company'

class TrainCar

  include ManufactureCompany

  attr_reader :type

  def initialize(type)
    @type = type
  end
end