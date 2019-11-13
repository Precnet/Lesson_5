require 'rspec'
require_relative '../main.rb'

describe 'UserInterface' do
  before(:all) do
    @ui = UserInterface.new
    @ud = UserData.new
    @ua = UserActions.new(@ud)
    @ui.create_menu_item('Show existing stations', -> { @ua.show_existing_stations })
    @ui.create_menu_item('Create new station', -> (station) { @ua.create_station station})
    @ui.create_menu_item('Create new route', -> (first, last, number=nil) {@ua.create_route(first, last, number)})
    @ui.create_menu_item('Add station to route', -> (route, station) {@ua.add_station_to_route(route, station)})
    @ui.create_menu_item('Remove station from route', -> (route, station) {@ua.remove_station_from_route(route, station)})
    @ui.create_menu_item('Add route to train', -> (route, train) { @ua.add_route_to_train(route, train) })
    @ui.create_menu_item('Create new passenger train', -> (number=nil) { @ua.create_passenger_train number})
    @ui.create_menu_item('Create new cargo train', -> (number=nil) { @ua.create_cargo_train number})
    @ui.create_menu_item('Show existing trains', -> { @ua.show_existing_trains })
    @ui.create_menu_item('Add carriage to train', -> (train_number) { @ua.add_carriage_to_train(train_number) })
    @ui.create_menu_item('Remove carriage from train', -> (train_number, carriage_number) { @ua.remove_carriage_from_train(train_number, carriage_number) })
    @ui.create_menu_item('Move train forward', -> (train_number) { @ua.move_train_forward(train_number) })
    @ui.create_menu_item('Move train backward', -> (train_number) { @ua.move_train_backward(train_number) })
    @ui.create_menu_item('Show trains at station', -> (station_name) { @ua.show_trains_at_station(station_name) })
  end
  context 'creating and selecting new menu items' do
    it 'should show all created stations' do
      message_1 = "There are no stations.\n"
      expect { @ui.select_menu_item('Show existing stations') }.to output(message_1).to_stdout
      @ui.select_menu_item('Create new station', 'one')
      message_2 = "There are next stations:\none\n"
      expect { @ui.select_menu_item('Show existing stations') }.to output(message_2).to_stdout
      @ui.select_menu_item('Create new station', 'two')
      @ui.select_menu_item('Create new station', 'three')
      message_3 = "There are next stations:\none, two, three\n"
      expect { @ui.select_menu_item('Show existing stations') }.to output(message_3).to_stdout
    end
    it 'should add new stations' do
      message = "Created station: test\n"
      expect { @ui.select_menu_item('Create new station', 'test') }.to output(message).to_stdout
    end
    it 'should create new trains' do
      expect { @ui.select_menu_item('Show existing trains') }.to output("There are no trains.\n").to_stdout
      message_1 = "New passenger train created. Its number is: test\n"
      expect { @ui.select_menu_item('Create new passenger train', 'test') }.to output(message_1).to_stdout
      message_2 = "New cargo train created. Its number is: 1234\n"
      expect { @ui.select_menu_item('Create new cargo train', '1234') }.to output(message_2).to_stdout
      @ui.select_menu_item('Create new cargo train', '4321')
      @ui.select_menu_item('Show existing trains')
      message_3 = "There are next passenger trains: test()\nThere are next cargo trains: 1234(),4321()\n"
      expect { @ui.select_menu_item('Show existing trains') }.to output(message_3).to_stdout
    end
  end
  context 'route management' do
    it 'should create new routes' do
      @ui.select_menu_item('Create new station', 'first')
      @ui.select_menu_item('Create new station', 'last')
      message = "Route 'test' created\n"
      expect { @ui.select_menu_item('Create new route', ['first', 'last', 'test']) }.to output(message).to_stdout
      expect(@ud.routes.length).to eq(1)
      @ui.select_menu_item('Create new route', ['last', 'first'])
      expect(@ud.routes.length).to eq(2)
    end
    it 'should add stations to routes' do
      @ui.select_menu_item('Create new station', 'new_1')
      route_name = @ud.routes.keys.first
      station_name = @ud.stations.keys.last
      expect { @ui.select_menu_item('Add station to route', [route_name, 'new_1']).to raise_error(ArgumentError) }
      expect { @ui.select_menu_item('Add station to route', ['some_route', station_name]).to raise_error(ArgumentError) }
      message = "Station #{station_name} were added to route #{route_name}\n"
      expect { @ui.select_menu_item('Add station to route', [route_name, station_name]) }.to output(message).to_stdout
      expect(@ud.routes[route_name].stations.length).to eq(3)
      expect(@ud.routes[route_name].stations[-2]).to eq('new_1')
    end
    it 'should delete stations from route' do
      @ui.select_menu_item('Create new station', 'middle_1')
      @ui.select_menu_item('Create new station', 'middle_2')
      route_name = @ud.routes.keys.first
      @ui.select_menu_item('Add station to route', [route_name, 'middle_1'])
      @ui.select_menu_item('Add station to route', [route_name, 'middle_2'])
      expect(@ud.routes[route_name].stations.length).to eq(5)
      expect { @ui.select_menu_item('Remove station from route', [route_name, 'new_2']) }.to raise_error(ArgumentError)
      expect { @ui.select_menu_item('Remove station from route', ['route_name', 'new_1']) }.to raise_error(ArgumentError)
      message = "Station 'new_1' were removed from route '#{route_name}'\n"
      expect { @ui.select_menu_item('Remove station from route', [route_name, 'new_1']) }.to output(message).to_stdout
      expect(@ud.routes[route_name].stations.length).to eq(4)
      @ui.select_menu_item('Remove station from route', [route_name, 'middle_1'])
      @ui.select_menu_item('Remove station from route', [route_name, 'middle_2'])
      expect(@ud.routes[route_name].stations.length).to eq(2)
    end
    it 'should add route to train' do
      @ui.create_menu_item('Create new passenger train', -> (number=nil) { @ua.create_passenger_train number})
      @ui.select_menu_item('Create new passenger train', 'passenger_train')
      route_name = @ud.routes.keys.first
      train_name = @ud.trains.keys.first
      expect { @ui.select_menu_item('Add route to train', [route_name, 'some_train']) }.to raise_error(ArgumentError)
      message = "Train '#{train_name}' is following route '#{route_name}' now\n"
      expect { @ui.select_menu_item('Add route to train', [route_name, train_name]) }.to output(message).to_stdout
    end
  end
  context 'carriage management' do
    it 'should add carriage to train' do
      message_passenger = "Passenger carriage was added to train 'test'\n"
      expect(@ud.trains['test'].number_of_carriages).to eq(0)
      expect { @ui.select_menu_item('Add carriage to train', 'test')}.to output(message_passenger).to_stdout
      expect(@ud.trains['test'].number_of_carriages).to eq(1)
      expect { @ui.select_menu_item('Add carriage to train', 'test')}.to output(message_passenger).to_stdout
      message_cargo = "Cargo carriage was added to train '1234'\n"
      expect { @ui.select_menu_item('Add carriage to train', '1234')}.to output(message_cargo).to_stdout
    end
    it 'should remove carriage from train' do
      expect { @ui.select_menu_item('Remove carriage from train', ['test', 'smth']) }.to raise_error(ArgumentError)
      carriage_number = @ud.trains['test'].carriages[0].number
      message = "Carriage '#{carriage_number}' was removed from train 'test'\n"
      expect(@ud.trains['test'].number_of_carriages).to eq(2)
      expect { @ui.select_menu_item('Remove carriage from train', ['test', carriage_number]) }.to output(message).to_stdout
      expect(@ud.trains['test'].number_of_carriages).to eq(1)
    end
  end
  context 'train movement' do
    it 'should move train forward and backward' do
      message_forward = "Train had arrived at next station! Current station is last\n"
      expect { @ui.select_menu_item('Move train forward', 'test') }.to output(message_forward).to_stdout
      route_name = @ud.trains['test'].route.number
      @ui.select_menu_item('Add station to route', [route_name, 'middle_1'])
      message_backward = "Train had arrived at previous station! Current station is middle_1\n"
      puts @ud.trains
      expect { @ui.select_menu_item('Move train backward', 'test') }.to output(message_backward).to_stdout
    end
  end
  context 'displaying trains at station' do
    it 'should correctly display trains at station' do
      message_1 = "There are next trains at station 'middle_1':\nPassenger trains: [\"test\"]\nCargo trains: []\n"
      expect { @ui.select_menu_item('Show trains at station', 'middle_1') }.to output(message_1).to_stdout
      @ui.select_menu_item('Move train forward', 'test')
      message_2 = "There are next trains at station 'middle_1':\nPassenger trains: []\nCargo trains: []\n"
      expect { @ui.select_menu_item('Show trains at station', 'middle_1') }.to output(message_2).to_stdout
      @ui.select_menu_item('Move train backward', 'test')
      expect { @ui.select_menu_item('Show trains at station', 'middle_1') }.to output(message_1).to_stdout
    end
  end
end
