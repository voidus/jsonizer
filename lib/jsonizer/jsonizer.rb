require 'json'

# Defines all methods neccessary for JSON encoding through JSON[], JSON.dump and #to_json
class Jsonizer < Module

  # Initialize a Jsonizer to use the given attributes
  #
  # They will be used to define as_json, to_json and self.json_create
  #
  # @param [Array<Symbol>] attributes
  # @return [undefined]
  def initialize(*attributes)
    @attributes = attributes
    define_as_json
    define_to_json
  end

  # Include the equalizer instance into mod
  #
  # @param mod [Module]
  # @return [undefined]
  def included(mod)
    raise ArgumentError, 'Cannot jsonize anonymous classes. They cannot be restored.' unless mod.name
    mod.extend(class_methods_module)
  end

private

  # Define #as_json using @attributes that returns a hash that will be converted to json
  #
  # @return [undefined]
  def define_as_json
    attributes = @attributes
    define_method :as_json do |*|
      hash = { 'json_class' => self.class.name }
      attributes.each do |attribute|
        hash[attribute.to_s] = self.send(attribute.to_sym)
      end
      hash
    end
  end

  # Define to_json that converts #as_json to a json string
  #
  # @return [undefined]
  def define_to_json
    define_method :to_json do |*|
      as_json.to_json
    end
  end

  # Creates a module that defines #json_create using the given attributes.
  #
  # It will pass them as positional attributes to #new in the same order that they were given in Jsonizer.new
  #
  # @return [undefined]
  def class_methods_module
    attributes = @attributes
    Module.new do
      define_method :json_create do |values|
        params = attributes.map { |attribute| values[attribute.to_s] }
        new(*params)
      end
    end
  end
end
