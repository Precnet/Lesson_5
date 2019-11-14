require_relative 'instance_counter'

class Route
  include InstanceCounter

  attr_reader :stations, :number
  @@number_of_instances = 0

  def initialize(first_station, last_station, route_number=generate_route_number(5))
    @stations = [first_station, last_station]
    @number = route_number
    register_instance
  end

  def add_station(new_station)
    # check for duplication
    duplicate_station_message = 'Can`t add duplicate stations to the route!'
    raise ArgumentError, duplicate_station_message if @stations.find_index(new_station)
    @stations.insert(-2, new_station)
  end

  def delete_station(station)
    raise ArgumentError, "There is no station #{station} in current route!" unless @stations.include? station
    @stations.delete_at(@stations.find_index(station))
  end

  private

  def generate_route_number(number_length)
    rand(36 ** number_length).to_s(36)
  end
end
