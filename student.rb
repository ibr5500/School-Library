require './person'

class Student < Person
  attr_accessor :classroom

  def initialize(age, classroom, name = 'Unknown', parent_permission: true)
    super(age, name, parent_permission: parent_permission)
    @classroom = classroom
  end

  def play_hooky
    "¯\(ツ)/¯"
  end

  def add_classroom
    @classroom = classroom
    classroom.students.push(self) unless classroom.students.include?(self)
  end
end

std = Student.new(16, 'History', 'Michal')
p std.can_use_services?
