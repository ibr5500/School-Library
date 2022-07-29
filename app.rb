require './person'
require './book'
require './rental'
require './teacher'
require './student'

class App
  def initialize
    @rentals = []
    @books = []
    @people = []
  end

  def choices_list
    choices = ['1 - List all book',
               '2 - List all People',
               '3 - Create a person',
               '4 - Create a book',
               '5 - Create a rental',
               '6 - List all rentals for a given person id',
               '7 - Exit']

    choices.each { |c| puts c.to_s }
  end

  def choose(choice)
    case choice
    when 1
      list_books
    when 2
      list_people
    when 3
      create_person
    when 4
      create_book
    when 5
      create_rental
    when 6
      list_rentals
    when 7
      puts
      puts 'Thank you for using this app!'
    else
      puts 'Please insert a number from 1 to 7.'
      choices_list
    end
  end

  def run
    puts 'Welcome to the School Library App!'
    puts
    choice = ''
    while choice != 7
      puts 'Please choose an option by entrering a number: '
      choices_list
      choice = gets.chomp.to_i
      choose(choice)
      puts
    end
  end

  def list_books
    if @books.empty?
      puts
      puts 'Books list is empty, but you can add a book'
      return
    end
    @books.each { |book| puts "Title: '#{book.title}', Author: #{book.author}" }
  end

  def list_people
    if @people.empty?
      puts 'People list is empty'
      return
    end
    @people.each do |person|
      puts "[#{person.class.name}] ID: '#{person.id}', Name: #{person.name}, Age: #{person.age}"
    end
  end

  def create_person
    puts 'Do you want to create a student(1) or a teacher(2)? [input the number]'
    ans = gets.chomp.to_i

    puts 'Please input a number 1 for Student or 2 for Teacher.' if ans != 1 || ans != 2
    while [1, 2].include?(ans)
      case ans
      when 1
        create_student
        break
      when 2
        create_teacher
        break
      end
    end
  end

  def create_student
    print 'Age: '
    age = gets.chomp.to_i

    while age < 1
      print 'Please enter a valid age: '
      age = gets.chomp.to_i
    end

    print 'Name: '
    name = gets.chomp.capitalize
    while name == ''
      print 'Please enter a name: '
      name = gets.chomp.capitalize
    end

    print 'Has parent permission? (Y/N)'
    permission = gets.chomp.upcase
    case permission
    when 'Y'
      permission = true
    when 'N'
      permission = false
    end

    student = Student.new(age, nil, name, parent_permission: permission)
    @people.push(student)
    puts 'Person created successfully'
  end

  def create_teacher
    print 'Age: '
    age = gets.chomp.to_i
    while age < 1
      print 'Please enter a valid age: '
      age = gets.chomp.to_i
    end

    print 'Name: '
    name = gets.chomp.capitalize
    while name == ''
      print 'Please enter a name: '
      name = gets.chomp.capitalize
    end

    print 'Specialization: '
    specialization = gets.chomp

    teacher = Teacher.new(age, specialization, name)
    @people.push(teacher)
    puts 'Person created successfully'
  end

  def create_book
    print 'Book title: '
    title = gets.chomp.capitalize
    while title == ''
      print 'Book title: '
      title = gets.chomp.capitalize
    end

    print 'Book author: '
    author = gets.chomp.capitalize
    while author == ''
      print 'Book author: '
      author = gets.chomp.capitalize
    end

    book = Book.new(title, author)
    @books.push(book)
    puts 'Book Created successfully'
  end

  def create_rental
    if @books.empty?
      puts 'Sorry there are no books avalibales'
      return
    end
    puts 'Select a book from the follwoing list by number'
    @books.each_with_index { |book, index| puts "#{index}) Title: #{book.title}, Author: #{book.author}" }
    rented_book = gets.chomp.to_i

    puts 'Select a person from the follwoing list by number (not id)'
    if @people.empty?
      print 'Sorry you have to create a person first'
      return
    end
    @people.each_with_index do |person, index|
      puts "#{index}) [#{person.class}] Name: #{person.name}, ID: #{person.id}, Age: #{person.age}"
    end
    renter = gets.chomp.to_i

    print 'Date: '
    date = gets.chomp

    rent_info = Rental.new(date, @people[renter], @books[rented_book])
    @rentals.push(rent_info)
    puts 'Rental created successfully'
  end

  def list_rentals
    if @rentals.empty?
      puts 'There are no rentals'
      return
    end
    print 'ID of person: '
    person_id = gets.chomp.to_i

    puts 'Rentals:'
    @rentals.each do |rent|
      puts "Date: #{rent.date}, Book: #{rent.book.title}, Author: #{rent.book.author}" if rent.person.id == person_id
    end
  end
end
