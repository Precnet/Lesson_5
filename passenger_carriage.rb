require_relative 'manufacturer.rb'

class PassengerCarriage
  include Manufacturer

  NUMBER_LENGTH = 5
  BASE_36 = 36
  CARRIAGE_TYPE = 'passenger'

  attr_reader :type, :number

  def initialize(carriage_number = generate_carriage_number(NUMBER_LENGTH))
    @type = CARRIAGE_TYPE
    @number = carriage_number
  end

  private

  # this is a method for creating default name for carriage it should not be used outside of object constructor
  def generate_carriage_number(number_length)
    CARRIAGE_TYPE + '_' + rand(BASE_36 ** number_length).to_s(BASE_36)
  end
end
