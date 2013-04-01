require 'json'
class Jsonizer < Module
  def initialize *attributes
    @attributes = attributes
    define_as_json
    define_to_json
  end

  def included mod
    raise ArgumentError, "Cannot jsonize anonymous classes. They cannot be restored." unless mod.name
    mod.extend(class_methods_module @attributes)
  end

private

  def define_as_json
    attributes = @attributes
    define_method :as_json do |*|
      hash = {'json_class' => self.class.name}
      attributes.each do |attribute|
        hash[attribute.to_s] = self.send(attribute.to_sym)
      end
      hash
    end
  end

  def define_to_json
    define_method :to_json do |*|
      as_json.to_json
    end
  end

  def class_methods_module attributes
    Module.new do
      define_method :json_create do |values|
        params = attributes.map {|attribute| values[attribute.to_s]}
        new(*params)
      end
    end
  end
end
