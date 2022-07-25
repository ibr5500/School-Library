class Person
  attr_reader :id # we need only getter
  attr_accessor :name, :age # we need to get and set

  def initialize(age, name = 'Unknown', parent_permission: true)
    @id = Random.rand(1..1000)
    @name = name
    @age = age
    @parent_permission = parent_permission
  end

  def of_age?
    @age >= 18
  end
  private :of_age?

  def can_use_services?
    of_age? || @parent_permission
  end
  public :can_use_services?
end

person = Person.new(17, 'Anja')
puts person.can_use_services?
