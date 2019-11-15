require 'rspec'
require_relative '../passenger_carriage.rb'

describe 'PassengerCarriage' do
  before(:all) do
    @carriage = PassengerCarriage.new
  end
  it 'should create passenger carriage' do
    expect(@carriage.type).to eq('passenger')
  end
  it 'should have manufacturer name' do
    @carriage.manufacturer = 'Train inc.'
    expect(@carriage.manufacturer).to eq('Train inc.')
  end
end