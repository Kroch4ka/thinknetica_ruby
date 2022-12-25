module Accessors
  def attr_accessor_with_history(*attrs)
    library
    generate_attr_getters attrs
    generate_attr_setters_with_history attrs
    generate_history_attr_values_viewers attrs
  end

  private

  def generate_attr_getters(attrs)
    attrs.each do |attr|
      define_method(attr.to_sym) do
        instance_variable_get("@#{attr}")
      end
    end
  end

  def generate_attr_setters_with_history(attrs)
    attrs.each do |attr|
      define_method("#{attr}=".to_sym) do |val|
        self.class.send(:historify, attr, val)
        instance_variable_set("@#{attr}", val)
      end
    end
  end

  def generate_history_attr_values_viewers(attrs)
    attrs.each do |attr|
      define_method("#{attr}_history") do
        self.class.send(:find_history_in_library, attr)&.values
      end
    end
  end

  History = Struct.new(:attr, :values)
  def historify(attr, val)
    target_history = find_history_in_library attr
    target_history ? target_history.values << val : library << History.new(attr, [] << val)
  end

  def find_history_in_library(attr)
    library.find { |history| history.attr == attr }
  end

  def library
    @library ||= []
  end
end