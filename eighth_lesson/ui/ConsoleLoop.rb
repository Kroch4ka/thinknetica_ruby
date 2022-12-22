# frozen_string_literal: true
require_relative 'base_ui'
require_relative 'route_ui'
require_relative 'station_ui'
require_relative 'train_ui'
class ConsoleLoop < BaseUI
  def self.run
    loop do
      action = actions[choose_variant(actions.keys)]
      BaseUI.subclasses.filter { |klass| klass.respond_to? action }.pop&.send(action)
    end
  end

  private_class_method def self.actions
    {
      'Создать станцию' => :create_station,
      'Создать поезд' => :create_train,
      'Создать маршрут' => :create_route,
      'Управлять маршрутом' => :manage_routes,
      'Просмотреть информацию по станциям' => :show_stations,
      'Выйти' => :exit
    }
  end
end
