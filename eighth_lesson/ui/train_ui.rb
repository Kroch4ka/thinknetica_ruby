# frozen_string_literal: true
require_relative 'base_ui'
require_relative '../trains/cargo_train'
require_relative '../trains/passenger_train'
require_relative '../wagons/cargo_wagon'
require_relative '../wagons/passenger_wagon'

class TrainUI < BaseUI
  def self.create_train
    puts 'Вы в режиме создания поезда!'
    puts 'Введите номер поезда'
    print 'Номер: '
    number = gets.chomp.to_i
    puts 'Выберите тип поезда: '
    chosen_type = choose_variant(train_types.keys) { |type| train_types[type][:name] }
    puts 'Успешно!' if train_types[chosen_type][:klass].new number
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
    send(action, chosen_train)
  end

  def self.add_wagon(train)
    available_wagon_types = train.class::ALLOWED_WAGON_TYPES.intersection(wagon_types.keys)
    chosen_wagon_type = choose_variant(available_wagon_types) { |type| wagon_types[type][:name] }
    wagon = wagon_types[chosen_wagon_type][:klass].new
    puts 'Успешно' if train.add_wagon wagon
  end

  def self.unhook_wagon(train)
    puts 'Успешно' if train.unhook_wagon
  end

  def self.drive_forward(train)
    route = train.send(:route)
    if route.nil?
      puts 'Данному поезду не установлен маршрут!'
      return
    end

    puts 'Успешно!' if train.drive_forward
  end

  def self.drive_back(train)
    route = train.send(:route)
    if route.nil?
      puts 'Данному поезду не установлен маршрут!'
      return
    end

    puts 'Успешно!' if train.drive_back
  end

  private_class_method def self.manage_actions
    {
      'Добавить вагон' => :add_wagon,
      'Удалить вагон' => :unhook_wagon,
      'Проехать вперёд' => :drive_forward,
      'Проехать назад' => :move_down
    }
  end

  private_class_method def self.wagon_types
    {
      cargo: {
        name: 'Грузовой',
        klass: CargoWagon
      },
      passenger: {
        name: 'Пассажирский',
        klass: PassengerWagon
      }
    }
  end

  private_class_method def self.train_types
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
end
