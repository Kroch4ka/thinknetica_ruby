# frozen_string_literal: true
require_relative 'base_ui'
require_relative '../wagons/cargo_wagon'
require_relative '../wagons/passenger_wagon'
class WagonUI < BaseUI
  def self.create_wagon
    chosen_wagon_type = choose_variant(wagon_types.keys) { |type| wagon_types[type][:name] }
    type_name = wagon_types[chosen_wagon_type][:name]

    puts "Введите, пожалуйста, вместимость вагона типа: #{type_name}"

    total_volume = gets.to_i

    puts 'Успешно!'
    wagon_types[type_name][:klass].new(total_volume)
  end

  def self.manage_wagon(train)
    chosen_wagon = choose_variant(train.wagons.with_index) { |(_, index)| "Номер #{index + 1}" }
    chosen_action = choose_variant(manage_actions.keys)

    send(manage_actions[chosen_action], chosen_wagon)
  end

  def self.take_volume(wagon)

    case wagon.class::TYPE
    when :passenger then take_passenger_wagon_volume wagon
    when :cargo then take_cargo_wagon_volume wagon
    else raise 'Что-то пошло не так(('
    end
  end

  def self.detail_for_cargo_wagon(wagon)
    type = wagon_types[wagon.class::TYPE][:name]
    "Тип: #{type}. Кол-во свободных мест: #{wagon.free_volume}, занятых мест: #{wagon.occupied_volume}"
  end

  def self.detail_for_passenger_wagon(wagon)
    type = wagon_types[wagon.class::TYPE][:name]
    "Тип: #{type}. Кол-во свободного объёма: #{wagon.free_volume}, занято: #{wagon.occupied_volume}"
  end

  def self.wagon_types
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

  private_class_method def self.take_passenger_wagon_volume(wagon)
    if wagon.free_volume.zero?
      puts 'Все места заняты('
      return
    end

    puts 'Место успешно занято!' if wagon.take_volume
  end

  private_class_method def self.take_cargo_wagon_volume(wagon)
    if wagon.free_volume.zero?
      puts 'Весь объём занят'
      return
    end

    print 'Объём: '
    taken_volume = gets.chomp.to_i
    unless enough_space_for_fill? taken_volume
      puts "Недостаточно свободного места для заполнения выбранного вагона. Доступно: #{wagon.free_volume}"
      return
    end
    puts 'Объём успешно занят!' if wagon.take_volume
  end

  private_class_method def self.manage_actions
    {
      'Заполнить вагон' => :take_volume
    }
  end
end
