require "on_change/version"

module OnChange
  extend ActiveSupport::Concern
  included do
    alias_method_chain :write_attribute, :callbacks
  end
  def run_attribute_change_callbacks(attr_name, *args)
    on_change_callbacks = self.class.on_change_callbacks
    on_change_callbacks.has_key?(attr_name.to_s) && on_change_callbacks[attr_name.to_s].each do |callback|
      callback.is_a?(Proc) ? callback.call(self,attr_name,*args) : send(callback, attr_name, *args)
    end
  end

  def write_attribute_with_callbacks(attr_name, value)
    run_attribute_change_callbacks(attr_name, read_attribute(attr_name), value)
    write_attribute_without_callbacks(attr_name, value)
  end

  module ClassMethods
    def on_change_callbacks
      @on_change_callbacks ||= {}
    end
    def subscribe_attribute_changes(*args, &block)
      callback = block_given? ? block : args.pop
      args.each do |attr|
        on_change_callbacks[attr.to_s] ||= []
        on_change_callbacks[attr.to_s] << callback
      end

    end
    def on_change(*args, &block)
      subscribe_attribute_changes(*args, &block)
    end
  end
end

class ActiveRecord::Base
  include OnChange
end
