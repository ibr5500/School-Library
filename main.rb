require './person'
require './rental'
require './book'
require './app'

class App
  def self.menu
    puts 'Welcome to the School Library App!'
    puts "\n"
    puts 'Please choose an option by entering a number: '

    choices = ['1 - List all book',
               '2 - List all People',
               '3 - Create a person',
               '4 - Create a book',
               '5 - Create a rental',
               '6 - List all rentals for a given person id',
               '7 - Exit']

    choices.each { |choice| puts choice.to_s }

    Integer(gets.chomp)
  end

  run = Library.new

  loop do
    case menu
    when 1
      run.list_books
    when 2
      run.list_people
    when 3
      run.create_person
    when 4
      run.create_book
    when 5
      run.create_rental
    when 6
      run.list_rentals
    when 7
      puts 'Thank you for using the app!'
      exit
    else
      puts 'Choose a number between 1 to 7'
    end
  end
end

def main
  App.new
end

main
