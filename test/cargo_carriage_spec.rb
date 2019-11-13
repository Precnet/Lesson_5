require 'rspec'
require_relative '../cargo_carriage.rb'

describe 'CargoCarriage' do
  it 'should create cargo carriage' do
    carriage = CargoCarriage.new
    expect(carriage.type).to eq('cargo')
  end
end