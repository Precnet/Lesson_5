require_relative 'instance_counter.rb'

class Station
  include InstanceCounter

  attr_reader :name, :trains_at_station
  @@number_of_instances = 0

  def self.all
    @@number_of_instances
  end

  def initialize(station_name)
    @name = check_station_name(station_name)
    @trains_at_station = []
    @@number_of_instances += 1
    register_instance
  end

  def train_arrived(new_train)
    @trains_at_station.push(new_train)
  end

  def send_train(train_number)
    error_message = "There is no train with number '#{train_number}' at station"
    raise ArgumentError, error_message unless train_at_station?(train_number)
    train_index =  get_train_index_by(train_number)
    @trains_at_station.delete_at(train_index)
  end

  def trains_at_station_of_type(train_type)
    @trains_at_station.select {|train| train if train.type == train_type}.map { |train| train.number}
  end

  def trains_at_station_by_type
    result = {}
    trains_at_station_types = @trains_at_station.map { |train| train.type}
    trains_at_station_types.uniq.each {|type| result[type] = trains_at_station_types.count(type)}
    result
  end

  private

  def check_station_name(name)
    raise ArgumentError, 'Station name can`t be nil!' unless name
    raise ArgumentError, 'Station name should be of String class!' unless name.is_a?(String)
    raise ArgumentError, 'Station name can`t be empty!' unless name.length > 0
    raise ArgumentError, 'Station name is too long! Should be <= 20 symbols.' unless name.length <= 20
    name
  end

  def train_at_station?(train_number)
    @trains_at_station.map { |train| train.number }.include? train_number
  end

  def get_train_index_by(train_name)
    @trains_at_station.map { |train| train.number }.find_index(train_name)
  end
end
