require 'rspec'
require_relative '../passenger_carriage.rb'

describe 'PassengerCarriage' do
  it 'should create passenger carriage' do
    carriage = PassengerCarriage.new
    expect(carriage.type).to eq('passenger')
  end
end