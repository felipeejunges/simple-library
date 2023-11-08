# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
def data(file_name)
  YAML.load_file(Rails.root.join("db/seeds/#{file_name}.yml"))
end

def users
  data('users').each do |u|
    user = User.find_or_create_by(id: u['id'], first_name: u['first_name'], last_name: u['last_name'], email: u['email'], role: u['role'])
    user.password = u['password']
    user.password_confirmation = u['password']
    user.save
  end
end

def books
  data('books').each do |b|
    book = Book.find_or_create_by(title: b['title'], isbn: b['isbn'], synopsis: b['synopsis'], series: b['series'], copies: b['copies'],
                                  language: b['language'], volume: b['volume'], pages: b['pages'])

    b['details'].each do |d|
      book.details.find_or_create_by(name: d['name'], description: d['description'])
    end
  end
end

users
books
