# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Categories
categories = Category.create!([
  { name: "Sarees" },
  { name: "Salwar Kameez" },
  { name: "Lehengas" },
  { name: "Kurtas" }
])

# Products
products = [
  { name: "Silk Saree", description: "Beautiful traditional silk saree", price: 199.99, stock: 10, category: categories[0] },
  { name: "Cotton Salwar", description: "Comfortable cotton salwar kameez", price: 89.99, stock: 15, category: categories[1] },
  { name: "Bridal Lehenga", description: "Elegant bridal lehenga with embroidery", price: 499.99, stock: 5, category: categories[2] }
]

products.each do |product_attrs|
  Product.create!(product_attrs)
end

puts "Created #{Category.count} categories and #{Product.count} products"
