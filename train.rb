require_relative 'manufacturer.rb'
require_relative 'instance_counter.rb'

TRAIN_TYPES = %w[passenger cargo].freeze

# train class
class Train
  include Manufacturer
  include InstanceCounter

  attr_reader :number, :type, :current_speed, :current_station,
              :number_of_carriages, :route
  @@trains = []

  def initialize(type, number_of_carriages, number = generate_train_number(10))
    @number = number
    @number_of_carriages = check_number_of_carriages(number_of_carriages)
    @type = check_train_type(type)
    @current_speed = 0
    @current_station = nil
    @route = nil
    @@trains.push(self)
    register_instance
  end

  def self.find_train_by_number(number)
    result = @@trains.select { |train| train.number == number }
    result[0]
  end

  def increase_speed_by(number_of_km)
    @current_speed += number_of_km
    @current_speed = 120 if @current_speed > 120
    current_speed
  end

  def decrease_speed_by(number_of_km)
    @current_speed -= number_of_km
    @current_speed = 0 if @current_speed.negative?
    current_speed
  end

  def stop
    @current_speed = 0
  end

  def add_carriage
    moving_message = 'Can`t add new carriages while train is moving.'
    raise moving_message if @current_speed.nonzero?

    @number_of_carriages += 1
  end

  def remove_carriage
    no_carriages_message = 'There are no carriages to remove.'
    raise no_carriages_message unless @number_of_carriages.positive?

    @number_of_carriages -= 1
  end

  def define_route(route)
    @route = route
    @current_station = route.stations[0]
  end

  def move_forward
    check_route
    message = 'Train is already at it`s final station and can`t move further!'
    raise message unless next_station_available?

    @current_station = @route.stations[next_station_index]
  end

  def move_backward
    check_route
    message = 'Train is already at it`s first station and can`t move backward!'
    raise message unless previous_station_available?

    @current_station = @route.stations[previous_station_index]
  end

  def previous_station
    check_route
    no_station = 'Can`t get previous station for first station!'
    raise no_station unless previous_station_available?

    @route.stations[previous_station_index]
  end

  def next_station
    check_route
    no_station = 'Can`t get next station for last station!'
    raise no_station unless next_station_available?

    @route.stations[next_station_index]
  end

  private

  # should be private because there is no need to call it in descendants
  def generate_train_number(number_length)
    rand(36**number_length).to_s(36)
  end

  # should be private because descendants are created without any carriages
  def check_number_of_carriages(number)
    message = "Number of carriages should be positive Integer. Got: #{number}"
    raise ArgumentError, message unless number.is_a?(Integer) && number >= 0

    number
  end

  # should be private because descendants are created without train type selection
  def check_train_type(train_type)
    wrong_message = "Should be 'cargo' or 'passenger'. Got - '#{train_type}'"
    raise ArgumentError, wrong_message unless TRAIN_TYPES.include? train_type

    train_type
  end

  # should be private because there is no need to call it in descendants
  def check_route
    event_no_route = 'There are no route! You need to set route first.'
    raise event_no_route unless @route
  end

  # should be private because there is no need to call it in descendants
  def next_station_available?
    current_station_index != @route.stations.length - 1
  end

  # should be private because there is no need to call it in descendants
  def current_station_index
    @route.stations.find_index(@current_station)
  end

  # should be private because there is no need to call it in descendants
  def next_station_index
    current_station_index + 1
  end

  # should be private because there is no need to call it in descendants
  def previous_station_index
    current_station_index - 1
  end

  # should be private because there is no need to call it in descendants
  def previous_station_available?
    current_station_index != 0
  end

  def carriage_correct?(carriage)
    carriage.respond_to?(:type) && carriage.type == @type
  end
end
