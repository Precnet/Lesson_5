# Carriage
class Carriage
  include Manufacturer

  NUMBER_LENGTH = 5
  BASE_36 = 36
  CARRIAGE_TYPE = ''.freeze

  attr_reader :number, :type

  def initialize(carriage_number)
    @number = carriage_number
  end

  protected

  # this is a method for creating default name for carriage it should not
  # be used outside of object constructor
  def generate_carriage_number(number_length)
    CARRIAGE_TYPE + '_' + rand(BASE_36**number_length).to_s(BASE_36)
  end
end
