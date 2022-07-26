require './nameable'

class Decorator < Nameable
  attr_accessor :name

  def initialize(name)
    @nameable = name
    super()
  end

  def correct_name
    @nameable.correct_name
  end
end
