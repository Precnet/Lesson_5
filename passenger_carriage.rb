require_relative 'manufacturer.rb'
require_relative 'carriage.rb'

class PassengerCarriage < Carriage
  CARRIAGE_TYPE = 'passenger'

  attr_reader :type, :number

  def initialize(carriage_number = generate_carriage_number(NUMBER_LENGTH))
    @type = CARRIAGE_TYPE
    @number = carriage_number
  end
end
