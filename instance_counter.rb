module InstanceCounter

  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    @number_of_instances = 0
    def instances

    end
  end

  module InstanceMethods
    @@number_of_instances = 0
    def register_instance
      @@number_of_instances += 1
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

p Smth.new
p Smth.instances
