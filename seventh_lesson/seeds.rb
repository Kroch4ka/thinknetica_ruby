require_relative 'boot'

# определение констант для автоматической загрузки их IRB
FIRST_CARGO = CargoTrain.new '323-23'
SECOND_CARGO = CargoTrain.new '321-54'

FIRST_PASSENGER = PassengerTrain.new '345-32'
SECOND_PASSENGER = PassengerTrain.new '323-12'

FIRST_STATION = Station.new 'Уральская'
SECOND_STATION = Station.new 'Алексеевская'

ROUTE = Route.new FIRST_STATION, SECOND_STATION