require 'rspec'
require_relative '../cargo_carriage.rb'

describe 'CargoCarriage' do
  before(:all) do
    @carriage = CargoCarriage.new
  end
  it 'should create cargo carriage' do
    expect(@carriage.type).to eq('cargo')
  end
  it 'should have manufacturer name' do
    @carriage.set_manufacturer_name('Train inc.')
    expect(@carriage.get_manufacturer_name).to eq('Train inc.')
  end
end