# frozen_string_literal: true

require_relative '../modules/manufacture_company'
require_relative '../modules/validation'
require_relative '../modules/accessors'

class TrainCar
  include ManufactureCompany
  include Accessors
  include Validation

  validate :type, :presence
  attr_reader :type

  def initialize(type)
    @type = type
  end
end
