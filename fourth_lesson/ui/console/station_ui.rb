require_relative '../../controller/station_controller'
require_relative 'base_console_ui'

class StationConsoleUI < BaseConsoleUI
  class << self
    def goto_create_station_mode
      puts 'Вы в режиме создания станций!'
      return if stop_command_request
  
      loop do
        puts 'Введите, пожалуйста, имя станции'
        print 'Имя: '
  
        station_name = gets.chomp
        
        if StationController.create_station(station_name)
          puts 'Успешно!'
        else
          puts 'Что-то пошло не так! Попробуйте, пожалуйста, ещё раз!'
        end
  
        break if stop_command_request
      end
    end

    def goto_show_stations_mode
      puts 'Вы в режиме просмотра станций!'
      return if stop_command_request

      loop do
        puts 'Выберите, пожалуйста, ту станцию, информацию о которой хотите просмотреть'
        stations = StationController.get_stations

        show_stations stations

        selected_station_serial_number = gets.chomp.to_i

        if validate_serial_number(stations, selected_station_serial_number)
          goto_current_station_show_mode(stations[selected_station_serial_number - 1])
        else
          puts 'Некорректный порядковый номер! Попробуйте, пожалуйста, ещё раз!'
        end

        break if stop_command_request
      end
    end

    def show_stations(stations)
      if stations.size == 0
        puts 'К сожалению, ещё нет созданных станций!'
        return
      end

      stations.each_with_index do |station, index|
        serial_number = index + 1
        puts "#{serial_number}) #{station.name}"
      end
    end

    def validate_name_station(name)
      if name.size == 0
        puts 'Имя не должно быть пустым'
        return false
      end

      true
    end

    private

    def goto_current_station_show_mode(station)
      puts "Имя станции: #{station.name}"
      puts "Количество поездов: #{station.trains.size}"
    end
  end
end