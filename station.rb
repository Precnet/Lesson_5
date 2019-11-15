# frozen_string_literal: true

# station class
require_relative 'instance_counter.rb'

# station class
class Station
  include InstanceCounter

  attr_reader :name, :trains_at_station
  @@stations = []

  def self.all
    @@stations
  end

  def initialize(station_name)
    @name = check_station_name(station_name)
    @trains_at_station = []
    register_instance
    @@stations.push(self)
  end

  def train_arrived(new_train)
    @trains_at_station.push(new_train)
  end

  def send_train(train_number)
    error_message = "There is no train with number '#{train_number}' at station"
    raise ArgumentError, error_message unless train_at_station?(train_number)

    train_index = get_train_index_by(train_number)
    @trains_at_station.delete_at(train_index)
  end

  def trains_at_station_of_type(type)
    @trains_at_station.select { |train| train if train.type == type }.map(&:number)
  end

  def trains_at_station_by_type
    result = {}
    train_types = @trains_at_station.map(&:type)
    train_types.uniq.each { |type| result[type] = train_types.count(type) }
    result
  end

  private

  def check_station_name(name)
    nil_message = 'Station name can`t be nil!'
    type_message = 'Station name should be of String class!'
    empty_message = 'Station name can`t be empty!'
    long_message = 'Station name is too long! Should be <= 20 symbols.'
    raise ArgumentError, nil_message unless name
    raise ArgumentError, type_message unless name.is_a?(String)
    raise ArgumentError, empty_message unless name.length.positive?
    raise ArgumentError, long_message unless name.length <= 20

    name
  end

  def train_at_station?(train_number)
    @trains_at_station.map(&:number).include? train_number
  end

  def get_train_index_by(train_name)
    @trains_at_station.map(&:number).find_index(train_name)
  end
end
