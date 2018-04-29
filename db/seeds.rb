# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

category_list=[{name: "分類一"},{name: "分類二"}, {name: "分類三"}, {name: "分類四"}]
category_list.each do |c|
	Category.create(name: c[:name])
end

User.create(name:"Admin", email: "admin@example.com", password: "12345678", role: "admin")

puts"default Admin User and Category List"