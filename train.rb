# require_relative 'Route'

TRAIN_TYPES = %w(passenger cargo)

class Train
  include Manufacturer

  attr_reader :number, :type, :current_speed, :current_station, :number_of_carriages, :route

  def initialize(train_type, number_of_carriages, train_number = generate_train_number(10))
    @number = train_number
    @number_of_carriages = check_number_of_carriages(number_of_carriages)
    @type = check_train_type(train_type)
    @current_speed = 0
    @current_station = nil
    @route = nil
  end

  def increase_speed_by(km)
    @current_speed += km
    if @current_speed > 120
      @current_speed = 120
      # puts "Train is at it`s maximum speed - 120km/h. It can`t safely increase it`s speed any more."
    end
    current_speed
  end

  def decrease_speed_by(km)
    @current_speed -= km
    if @current_speed < 0
      @current_speed = 0
      # puts "Train had already stopped. It can`t decrease it`s speed any more."
    end
    current_speed
  end

  def stop
    @current_speed = 0
  end

  def add_carriage
    raise RuntimeError, 'Can`t add new carriages while train is moving.' unless @current_speed == 0
    @number_of_carriages += 1
  end

  def remove_carriage
    raise RuntimeError, 'There are no carriages to remove.' unless @number_of_carriages > 0
    @number_of_carriages -= 1
  end

  def set_route(route)
    @route = route
    @current_station = route.stations[0]
  end

  def move_forward
    check_route
    event_no_next_station = 'Train is already at it`s final station and can`t move further!'
    raise event_no_next_station unless next_station_available?
    @current_station = @route.stations[next_station_index]
  end

  def move_backward
    check_route
    event_no_previous_station = 'Train is already at it`s first station and can`t move backward!'
    raise event_no_previous_station unless previous_station_available?
    @current_station = @route.stations[previous_station_index]
  end

  def get_previous_station
    check_route
    raise RuntimeError, 'Can`t get previous station for first station!' unless previous_station_available?
    @route.stations[previous_station_index]
  end

  def get_next_station
    check_route
    raise RuntimeError, 'Can`t get next station for last station!' unless next_station_available?
    @route.stations[next_station_index]
  end

  private

  # should be private because there is no need to call it in descendants
  def generate_train_number(number_length)
    # nice little magick with converting int to str with Base36
    rand(36 ** number_length).to_s(36)
  end

  # should be private because descendants are created without any carriages
  def check_number_of_carriages(number_of_carriages)
    event_wrong_number_carriages = "Number of carriages should be positive Integer. Got: #{number_of_carriages}"
    raise ArgumentError, event_wrong_number_carriages unless
        number_of_carriages.is_a?(Integer) && number_of_carriages >= 0
    number_of_carriages
  end

  # should be private because descendants are created without train type selection
  def check_train_type(train_type)
    event_wrong_train_type = "Wrong type of a train! Should be 'cargo' or 'passenger'. Got - '#{train_type}'"
    raise ArgumentError, event_wrong_train_type  unless TRAIN_TYPES.include? train_type
    train_type
  end

  # should be private because there is no need to call it in descendants
  def check_route
    event_no_route = 'There are no route! You need to set route first.'
    raise event_no_route unless @route
  end

  # should be private because there is no need to call it in descendants
  def next_station_available?
    last_station_index = @route.stations.length - 1
    current_station_index != last_station_index
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
