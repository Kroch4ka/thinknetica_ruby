# frozen_string_literal: true
require_relative 'base_ui'
require_relative 'wagon_ui'
require_relative '../trains/cargo_train'
require_relative '../trains/passenger_train'
require_relative '../errors/validation_error'

class TrainUI < BaseUI
  def self.create_train
    puts 'Введите номер поезда'
    print 'Номер: '
    number = gets.chomp
    puts 'Выберите тип поезда: '
    chosen_type = choose_variant(train_types.keys) { |type| train_types[type][:name] }
    puts 'Успешно!' if trains << train_types[chosen_type][:klass].new(number)
  rescue ValidationError => e
    puts e.message
    puts 'Заново!'
    retry
  end

  def self.set_route
    if trains.empty?
      puts 'На данный момент нет созданных поездов'
      return
    end
    if routes.empty?
      puts 'На данный момент не созданных маршрутов'
      return
    end

    train = choose_variant(trains, &:name)
    route = choose_variant(routes, &:to_s)

    puts 'Успешно' if (train.current_route = route)
  end

  def self.manage_train
    if trains.empty?
      puts 'Нет созданных поездов!'
      return
    end

    chosen_train = choose_variant(trains, &:number)
    action = choose_variant(manage_actions.keys)
    send(manage_actions[action], chosen_train)
  end

  def self.train_types
    {
      cargo: {
        name: 'Грузовой',
        klass: CargoTrain
      },
      passenger: {
        name: 'Пассажирский',
        klass: PassengerTrain
      }
    }
  end

  private_class_method def self.manage_wagon(train)
    chosen_wagon = choose_variant(train.wagons) { '' }
    WagonUI.manage_wagon chosen_wagon
  end

  private_class_method def self.add_wagon(train)
    wagon = WagonUI.create_wagon
    puts 'Успещно' if train.add_wagon wagon
  end

  private_class_method def self.unhook_wagon(train)
    puts 'Успешно' if train.unhook_wagon
  end

  private_class_method def self.drive_forward(train)
    route = train.send(:route)
    if route.nil?
      puts 'Данному поезду не установлен маршрут!'
      return
    end

    puts 'Успешно!' if train.drive_forward
  end

  private_class_method def self.drive_back(train)
    route = train.send(:route)
    if route.nil?
      puts 'Данному поезду не установлен маршрут!'
      return
    end

    puts 'Успешно!' if train.drive_back
  end

  private_class_method def self.show_wagons(train)
    if train.wagons.empty?
      puts 'На данный момент поезд вагонов не имеет.'
      return
    end
    draw_numbered_list(train.wagons) do |wagon|
      case wagon.class::TYPE
      when :cargo then WagonUI.detail_for_cargo_wagon wagon
      when :passenger then WagonUI.detail_for_passenger_wagon wagon
      else raise 'Что-то пошло не так('
      end
    end
  end

  private_class_method def self.manage_actions
    {
      'Добавить вагон' => :add_wagon,
      'Удалить вагон' => :unhook_wagon,
      'Управлять вагоном' => :manage_wagon,
      'Просмотреть информацию по вагонам' => :show_wagons,
      'Проехать вперёд' => :drive_forward,
      'Проехать назад' => :move_down
    }
  end
end
