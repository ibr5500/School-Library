require './person'
require './rental'
require './book'
require './app'

def main
  app = App.new
  app.run
end

p main
