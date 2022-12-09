require_relative 'modules/instance_counter'

class Station
  include InstanceCounter
  
  attr_reader :name

  @@stations = []

  def self.all
    @@stations
  end

  def initialize(name)
    @name = name
    @trains = []
    @@stations << self
    self.register_instance
  end

  def add_train(train)
    @trains << train
  end

  # Не в attr_reader, так как массив нельзя присваивать,но можно изменять через <<
  # поэтому мы его замараживаем, чтобы и через << нельзя было изменить
  def trains
    @trains.freeze
  end

  def get_trains_by_type(type)
    @trains.select { |train| train.type == type }
  end

  def send_train(target_train)
    @trains = @trains.select { |train| !(target_train.equal? train) }
  end
end