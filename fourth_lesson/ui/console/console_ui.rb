require_relative 'station_ui'
require_relative 'train_ui'
require_relative 'route_ui'
require_relative 'base_console_ui'

class ConsoleUI < BaseConsoleUI
  class << self
    def start
      greeting
      show_menu
    end
  
    private
    
    def greeting
      puts 'Привет! Это консольный интерфейс имитации ЖД взаимодейтвия!'
    end
  
    def show_menu
      loop do
        clear_console!
        
        puts 'Выберите один из вариантов из нижеприведённого списка и введите соответствующую ему значение'
        puts '1 - Создать станцию/станции'
        puts '2 - Просмотреть станции'
        puts '3 - Cоздать поезд/поезда'
        puts '4 - Создать маршруты'
        puts '5 - Управление поездом'
        puts "#{self::STOP_WORD} - выйти"

        command = gets.chomp

        break if stop_command_request command 
        command_menu_dispatcher command
      end
    end

    def command_menu_dispatcher(command)
      case command
      when '1' then StationConsoleUI.goto_create_station_mode
      when '2' then StationConsoleUI.goto_show_stations_mode
      when '3' then TrainConsoleUI.goto_create_train_mode
      when '4' then RouteConsoleUI.goto_create_route_mode
      when '5' then TrainConsoleUI.goto_choose_train_for_manage_mode
      else
        puts 'Упс, некорректный вариант! Попробуйте, пожалуйста, ещё!'
      end
    end
  end
end