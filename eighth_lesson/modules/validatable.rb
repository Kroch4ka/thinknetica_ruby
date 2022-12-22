# frozen_string_literal: true
require_relative '../errors/validation_error'
module Validatable
  def self.included(klass)
    klass.extend ClassMethods
    super klass
  end

  def validate
    @errors = self.class.meta.filter do |validator|
      validator.pattern !~ instance_variable_get("@#{validator.variable}").to_s
    end.map(&:error_message)
  end

  def validate!
    self.class.meta.each do |validator|
      variable_value = instance_variable_get("@#{validator.variable}").to_s
      if validator.pattern !~ variable_value
        raise ValidationError, "#{validator.error_message}.Given: #{variable_value}."
      end
    end
  end

  def valid?
    @errors.empty?
  end

  def errors
    @errors ||= []
  end

  # Пока принимаеются только регулярные выражения в качестве проверки
  module ClassMethods
    Validator = Struct.new(:variable, :pattern, :error_message)
    def check(variable, pattern, error_message = "#{variable} does match pattern: #{pattern}")
      meta unless meta
      @meta << Validator.new(variable, pattern, error_message)
    end

    def meta
      @meta ||= []
    end
  end
end
