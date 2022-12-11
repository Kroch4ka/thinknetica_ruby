require_relative 'modules/instance_counter'
require_relative 'errors/validation_error'

class Station
  include InstanceCounter
  
  attr_reader :name

  @@stations = []
  NAME_FORMAT = /^[а-я]+$/i

  def self.all
    @@stations
  end

  def initialize(name)
    @name = name
    @trains = []
    validate!
    @@stations << self
    self.register_instance
  end

  def add_train(train)
    @trains << train
  end

  # Не в attr_reader, так как массив нельзя присваивать,но можно изменять через <<
  # поэтому мы его замораживаем, чтобы и через << нельзя было изменить
  def trains
    @trains.freeze
  end

  def get_trains_by_type(type)
    @trains.select { |train| train.type == type }
  end

  def send_train(target_train)
    @trains = @trains.select { |train| !(target_train.equal? train) }
  end

  def valid?
    validate!
    true
  rescue
    false
  end

  private

  def validate!
    raise ValidationError.new('Некорректное имя! Должно содержать только кириллицу!') if NAME_FORMAT !~ @name
  end
end