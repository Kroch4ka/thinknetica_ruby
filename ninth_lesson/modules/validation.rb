# frozen_string_literal: true
require_relative '../errors/validation_error'

module Validation
  def self.included(klass)
    klass.extend ClassMethods
    super klass
  end

  def validate!
    self.class.send(:validators).each do |validator|
      variable_value = instance_variable_get("@#{validator.attr}")
      validator.validation_pipe.each do |callback|
        callback.call variable_value
      end
    end
  end

  def valid?
    validate!
    true
  rescue ValidationError
    false
  end

  module ClassMethods
    def validate(attr, type, *options)
      case type
      when :presence then validitify(attr, presence_validation_callback)
      when :format then validitify(attr, format_validation_callback(options.first))
      when :type then validitify(attr, type_validation_callback(options.first))
      else raise 'Undefined type!'
      end
    end

    private

    # Попробовал замыкания, работают как в JS))
    def presence_validation_callback()
      ->(value) { raise ValidationError, 'Should be not nil or not empty string' if value.nil? || (value.empty? if value.is_a? String) }
    end

    def format_validation_callback(format)
      ->(value) { raise ValidationError, "Should be format: #{format}" if format !~ value }
    end

    def type_validation_callback(type)
      ->(value) { raise ValidationError, "Incorrect type, should be: #{type}" unless value.is_a? type }
    end

    Validator = Struct.new(:attr, :validation_pipe)
    def validitify(attr, validation_callback)
      validator = find_validator(attr)
      validator ? validator.validation_pipe << validation_callback : validators << Validator.new(attr, [] << validation_callback)
    end

    def validators
      @validators ||= []
    end

    def find_validator(attr)
      validators.find { |validator| validator.attr == attr }
    end
  end
end