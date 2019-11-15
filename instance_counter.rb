module InstanceCounter

  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def instances
      'ok 1'
    end
  end

  module InstanceMethods
    def register_instance
      p 'ok'
    end
  end
end

class Smth
  include InstanceCounter

  def initialize
    # @number_of_instances += 1
    register_instance
    # p @number_of_instances.class
  end
end

Smth.new
p Smth.instances
