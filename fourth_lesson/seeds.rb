require_relative 'boot'

# Определение констант для автоматической загрузки их IRB
FIRST_CARGO = CargoTrain.new 123
SECOND_CARGO = CargoTrain.new 234

FIRST_PASSENGER = PassengerTrain.new 456
SECOND_PASSENGER = PassengerTrain.new 789

FIRST_STATION = Station.new 'Уральская'
SECOND_STATION = Station.new 'Алексеевская'

ROUTE = Route.new FIRST_STATION, SECOND_STATION