require './book'

class Rental
  attr_reader :book, :person
  attr_accessor :date

  def initialize(date, person, book)
    @date = date

    @book = book
    book.rentals.push(self)

    @person = person
    person.rentals.push(self)
  end
end
