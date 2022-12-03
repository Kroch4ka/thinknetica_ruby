require_relative './train'

class Station
  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = []
  end

  def add_train(train)
    @trains << train
  end

  def get_trains_by_type(type)

    @trains.select { |train| train.type == type }
  end

  def send_train(target_train)
    @trains = @trains.select { |train| !(target_train.equal? train) }
  end
end