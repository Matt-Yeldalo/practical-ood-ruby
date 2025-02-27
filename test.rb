# frozen_string_literal: true

class Cat
  attr_reader :name, :age

  def initialize
    @name = 'assfuck'
    @age = 55

    yield_self
  end
end

Cat.new do |c|
  puts c.name
end
