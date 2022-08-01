require './person'
require './rental'
require './book'
require './app'

class App
  def initialize
    @run = Library.new
  end

  def menu
    choices = ['1 - List all book',
               '2 - List all People',
               '3 - Create a person',
               '4 - Create a book',
               '5 - Create a rental',
               '6 - List all rentals for a given person id',
               '7 - Exit']

    choices.each { |choice| puts choice.to_s }
  end

  def start
    puts 'Welcome to the School Library App!'
    puts "\n"
    puts 'Please choose an option by entering a number: '

    loop do
      menu
      user_choose = gets.chomp.to_i
      break if user_choose == 7

      @run.choose(user_choose)
    end
    puts 'Thank you for using the app!'
  end
end

def main
  App.new.start
end

main
