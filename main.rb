require './person'
#require './capitalize_decorator'
#require './trimmer_decorator'
require './rental'
require './book'
require './app'

def main
  app = App.new
  app.run
end

p main
