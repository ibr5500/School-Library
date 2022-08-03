require './person'
require './book'
require './rental'
require './teacher'
require './student'
require 'json'

# rubocop:disable Metrics/ClassLength
class Library
  def initialize
    @rentals = []
    @books = []
    @people = []
    load_data
    load_reantals
  end

  # rubocop:disable Metrics/CyclomaticComplexity
  def choose(input)
    case input
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
      save_data
      exit
    else
      puts 'Choose a number between 1 to 7'
    end
  end
  # rubocop:enable Metrics/CyclomaticComplexity

  # rubocop:disable Metrics/PerceivedComplexity
  def load_data
    if File.empty?('books.json')
      puts 'List is empty'
    else
      books = JSON.parse(File.read('books.json'))
      books.each do |book|
        @books.push(Book.new(book['Title'], book['Author']))
      end
    end

    if File.empty?('people.json')
      puts 'List is empty'
    else
      people = JSON.parse(File.read('people.json'))
      people.each do |person|
        if person['Class'] == 'Student'
          @people.push(Student.new(person['Age'], person['Name'], person['parent_permission']))
        else
          @people.push(Teacher.new(person['Age'], person['spec'], person['Name']))
        end
      end
    end
  end
  # rubocop:enable Metrics/PerceivedComplexity

  def load_reantals
    if File.empty?('rentals.json') || !File.exist?('rentals.json')
      puts 'List is empty'
    else
      rentals = JSON.parse(File.read('rentals.json'))
      rentals.each do |rent|
        @rentals.push(Rental.new(rent['date'],
                                 @books.select { |book| book.title == rent['Book'] }[0],
                                 @people.select { |person| person.name == rent['Name'] }[0]))
      end
    end
  end

  def list_books
    puts 'Books list is empty, but you can add a book' if @books.empty?
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

  # rubocop:disable Metrics/MethodLength
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

    print 'Has parent permission? (Y/N) '
    permission = gets.chomp.upcase
    case permission
    when 'Y'
      permission = true
    when 'N'
      permission = false
    else
      print 'Please enter Y for Yes or N for No: '
      permission = gets.chomp.upcase
    end

    @people.push(Student.new(age, name, parent_permission: permission))
    puts 'Person created successfully'
    puts
  end
  # rubocop:enable Metrics/MethodLength

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
    puts
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
    puts
  end

  # rubocop:disable Metrics/MethodLength
  def create_rental
    if @books.empty?
      puts 'Sorry there are no books avalibales'
      return
    end
    puts 'Select a book from the follwoing list by number'
    @books.each_with_index { |book, index| puts "#{index}) Title: #{book.title}, Author: #{book.author}" }
    rented_book = gets.chomp.to_i
    # rubocop:disable Lint/UnreachableLoop
    while @books[rented_book].nil?
      print 'Please select a book by index: '
      rented_book = gets.chomp.to_i
      break
    end
    # rubocop:enable Lint/UnreachableLoop

    if @people.empty?
      puts 'Sorry you have to create a person first'
      return
    else
      puts 'Select a person from the follwoing list by number (not id)'
    end
    @people.each_with_index do |person, index|
      puts "#{index}) [#{person.class}] - Name: #{person.name}, ID: #{person.id}, Age: #{person.age}"
    end
    renter = gets.chomp.to_i
    # rubocop:disable Lint/UnreachableLoop
    while @people[renter].nil?
      print 'Please select a person by index: '
      renter = gets.chomp.to_i
      break
    end
    # rubocop:enable Lint/UnreachableLoop

    print 'Date: [YYYY-MM-DD] '
    date = gets.chomp

    rent_info = Rental.new(date, @people[renter], @books[rented_book])
    @rentals.push(rent_info)
    puts 'Rental created successfully'
  end
  # rubocop:enable Metrics/MethodLength

  def list_rentals
    @people.each { |person| puts "[#{person.class}] ID: #{person.id}, Name: #{person.name}" }

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

  def save_data
    books = []
    people = []
    rents = []

    @books.each do |book|
      books.push({ Title: book.title, Author: book.author })
    end

    @people.each do |person|
      if person.is_a? Student
        people.push({ Class: person.class, classroom: person.classroom, Name: person.name, Age: person.age })
      else
        people.push({ Class: person.class, Name: person.name, Age: person.age })
      end
    end

    @rentals.each do |rent|
      rents.push({ date: rent.date, Book: rent.book.title, Name: rent.person.name })
    end

    File.write('books.json', JSON.generate(books))
    File.write('people.json', JSON.generate(people))
    File.write('rentals.json', JSON.generate(rents))
  end
end
# rubocop:enable Metrics/ClassLength
