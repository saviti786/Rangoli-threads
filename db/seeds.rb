# Clear existing data
Rails.logger.debug "Clearing existing data..."
OrderItem.destroy_all
Order.destroy_all
Product.destroy_all
Category.destroy_all
Page.destroy_all

# Seed provinces with correct Canadian tax rates
Rails.logger.debug "Seeding provinces..."
provinces_data = [
  { name: "Alberta", gst: 5.0, pst: 0.0, hst: 0.0 },
  { name: "British Columbia", gst: 5.0, pst: 7.0, hst: 0.0 },
  { name: "Manitoba", gst: 5.0, pst: 7.0, hst: 0.0 },
  { name: "New Brunswick", gst: 0.0, pst: 0.0, hst: 15.0 },
  { name: "Newfoundland and Labrador", gst: 0.0, pst: 0.0, hst: 15.0 },
  { name: "Northwest Territories", gst: 5.0, pst: 0.0, hst: 0.0 },
  { name: "Nova Scotia", gst: 0.0, pst: 0.0, hst: 15.0 },
  { name: "Nunavut", gst: 5.0, pst: 0.0, hst: 0.0 },
  { name: "Ontario", gst: 0.0, pst: 0.0, hst: 13.0 },
  { name: "Prince Edward Island", gst: 0.0, pst: 0.0, hst: 15.0 },
  { name: "Quebec", gst: 5.0, pst: 9.975, hst: 0.0 },
  { name: "Saskatchewan", gst: 5.0, pst: 6.0, hst: 0.0 },
  { name: "Yukon", gst: 5.0, pst: 0.0, hst: 0.0 }
]

provinces_data.each do |province_data|
  Province.find_or_create_by!(name: province_data[:name]) do |province|
    province.gst = province_data[:gst]
    province.pst = province_data[:pst]
    province.hst = province_data[:hst]
  end
end
Rails.logger.debug " Seeded #{Province.count} provinces"

# Seed Categories
Rails.logger.debug "Seeding categories..."
categories = [
  { name: "Women's Ethnic Wear" },
  { name: "Men's Ethnic Wear" },
  { name: "Accessories" },
  { name: "Bridal Collection" }
]

categories.each do |cat|
  Category.find_or_create_by!(name: cat[:name])
end
Rails.logger.debug " Seeded #{Category.count} categories"

# Seed Products with realistic Indian clothing data
Rails.logger.debug "Seeding products..."

# Women's Ethnic Wear - 40 products
women_category = Category.find_by(name: "Women's Ethnic Wear")
women_products = [
  { name: "Banarasi Silk Saree", base_price: 149.99, description_type: "saree" },
  { name: "Kanjivaram Silk Saree", base_price: 199.99, description_type: "saree" },
  { name: "Georgette Printed Saree", base_price: 79.99, description_type: "saree" },
  { name: "Cotton Salwar Kameez Set", base_price: 59.99, description_type: "salwar" },
  { name: "Anarkali Suit", base_price: 89.99, description_type: "anarkali" },
  { name: "Palazzo Suit Set", base_price: 69.99, description_type: "palazzo" },
  { name: "Embroidered Lehenga Choli", base_price: 299.99, description_type: "lehenga" },
  { name: "Silk Churidar Set", base_price: 79.99, description_type: "churidar" },
  { name: "Designer Kurti", base_price: 49.99, description_type: "kurti" },
  { name: "Straight Cut Salwar", base_price: 64.99, description_type: "salwar" }
]

descriptions = {
  "saree"    => "Elegant traditional saree featuring intricate designs and premium fabric. Perfect for weddings, festivals, and special occasions. Includes unstitched blouse piece.",
  "salwar"   => "Comfortable and stylish salwar kameez set with beautiful embroidery. Ideal for both casual and formal occasions. Set includes top, bottom, and dupatta.",
  "anarkali" => "Flowing Anarkali suit with delicate embellishments. Features a flattering silhouette perfect for parties and celebrations. Complete with matching dupatta.",
  "palazzo"  => "Modern palazzo suit combining traditional style with contemporary comfort. Features wide-leg pants and beautifully designed kurti with dupatta.",
  "lehenga"  => "Stunning lehenga choli set with intricate embroidery and sequin work. Perfect for weddings and grand celebrations. Includes choli, lehenga, and dupatta.",
  "churidar" => "Classic churidar suit in premium silk fabric. Features traditional patterns and comfortable fit. Complete three-piece set.",
  "kurti"    => "Versatile designer kurti suitable for everyday wear or special occasions. Features modern prints and comfortable fabric."
}

40.times do |i|
  template = women_products[i % women_products.length]
  Product.create!(
    name:        "#{template[:name]} #{Faker::Color.color_name.titleize}",
    description: descriptions[template[:description_type]],
    price:       template[:base_price] + rand(-20..50),
    stock:       rand(5..50),
    category:    women_category,
    on_sale:     [true, false, false, false].sample, # 25% chance of being on sale
    new_arrival: i < 10 # First 10 are new arrivals
  )
end

# Men's Ethnic Wear - 30 products
men_category = Category.find_by(name: "Men's Ethnic Wear")
men_products = [
  { name: "Silk Kurta Pajama", base_price: 89.99, description_type: "kurta" },
  { name: "Embroidered Sherwani", base_price: 249.99, description_type: "sherwani" },
  { name: "Cotton Pathani Suit", base_price: 69.99, description_type: "pathani" },
  { name: "Nehru Jacket Set", base_price: 129.99, description_type: "nehru" },
  { name: "Designer Kurta", base_price: 54.99, description_type: "kurta" }
]

men_descriptions = {
  "kurta"    => "Premium quality kurta pajama set perfect for festivals, weddings, and traditional events. Comfortable fit with elegant design.",
  "sherwani" => "Luxurious sherwani with intricate embroidery and embellishments. Ideal for weddings and grand celebrations. Comes with matching churidar.",
  "pathani"  => "Classic Pathani suit in comfortable cotton fabric. Perfect for casual and semi-formal occasions. Features traditional cut and modern styling.",
  "nehru"    => "Sophisticated Nehru jacket set with kurta and pajama. Perfect for parties and formal events. Contemporary design meets traditional elegance."
}

30.times do |i|
  template = men_products[i % men_products.length]
  Product.create!(
    name:        "#{template[:name]} #{Faker::Color.color_name.titleize}",
    description: men_descriptions[template[:description_type]],
    price:       template[:base_price] + rand(-15..40),
    stock:       rand(5..40),
    category:    men_category,
    on_sale:     [true, false, false, false].sample,
    new_arrival: i < 8
  )
end

# Accessories - 20 products
accessories_category = Category.find_by(name: "Accessories")
accessory_products = [
  { name: "Embroidered Dupatta", price: 29.99,
desc: "Beautiful embroidered dupatta to complement any ethnic outfit. Features delicate work and premium fabric." },
  { name: "Potli Bag", price: 34.99,
desc: "Traditional potli bag with intricate beadwork. Perfect accessory for weddings and parties." },
  { name: "Kundan Jewelry Set", price: 79.99,
desc: "Elegant Kundan jewelry set including necklace and earrings. Traditional design with contemporary appeal." },
  { name: "Silk Stole", price: 24.99,
desc: "Luxurious silk stole available in various colors. Perfect for adding elegance to any outfit." },
  { name: "Jhumka Earrings", price: 19.99,
desc: "Classic jhumka earrings with traditional design. Lightweight and comfortable for all-day wear." },
  { name: "Bangles Set", price: 14.99,
desc: "Colorful bangles set perfect for traditional occasions. Available in various designs and colors." },
  { name: "Bindi Pack", price: 9.99,
desc: "Assorted decorative bindis for special occasions. Multiple designs in one pack." }
]

20.times do |i|
  template = accessory_products[i % accessory_products.length]
  Product.create!(
    name:        "#{template[:name]} - #{Faker::Color.color_name.titleize}",
    description: template[:desc],
    price:       template[:price] + rand(-5..15),
    stock:       rand(10..100),
    category:    accessories_category,
    on_sale:     [true, false, false].sample,
    new_arrival: i < 5
  )
end

# Bridal Collection - 10 products
bridal_category = Category.find_by(name: "Bridal Collection")
bridal_products = [
  { name: "Bridal Lehenga Set", price: 799.99,
desc: "Exquisite bridal lehenga with heavy embroidery and embellishments. Features premium fabrics and intricate craftsmanship. Includes lehenga, choli, and dupatta." },
  { name: "Wedding Sherwani", price: 599.99,
desc: "Regal wedding sherwani with traditional embroidery. Perfect for grooms. Comes with matching churidar and dupatta." },
  { name: "Bridal Saree Collection", price: 449.99,
desc: "Stunning bridal saree with heavy border work and embellishments. Traditional yet contemporary design." },
  { name: "Designer Bridal Suit", price: 399.99,
desc: "Elegant bridal suit set with intricate embroidery. Perfect for wedding ceremonies and receptions." }
]

10.times do |i|
  template = bridal_products[i % bridal_products.length]
  Product.create!(
    name:        "#{template[:name]} #{i + 1}",
    description: template[:desc],
    price:       template[:price] + rand(-50..200),
    stock:       rand(2..10),
    category:    bridal_category,
    on_sale:     false, # Bridal items rarely on sale
    new_arrival: i < 3
  )
end

Rails.logger.debug " Seeded #{Product.count} products"

# Seed Pages
Rails.logger.debug "Seeding pages..."
Page.find_or_create_by!(slug: "about") do |page|
  page.title = "About Rangoli Threads"
  page.content = <<~CONTENT
    Welcome to Rangoli Threads, Winnipeg's premier destination for authentic Indian ethnic wear.

    Since 2018, we have been serving the local South Asian community and fashion enthusiasts with quality products and personalized service. Our carefully curated collection features traditional and contemporary Indian clothing including sarees, salwar kameez, lehengas, kurtas, sherwanis, and ethnic accessories.

    We maintain strong relationships with suppliers in India and Canada, ensuring authentic, high-quality products that celebrate the rich traditions of South Asian fashion.
  CONTENT
end

Page.find_or_create_by!(slug: "contact") do |page|
  page.title = "Contact Us"
  page.content = <<~CONTENT
    Get in touch with Rangoli Threads

    Location: Pembina Highway, Winnipeg, MB

    Hours:
    Monday - Saturday: 10:00 AM - 8:00 PM
    Sunday: 12:00 PM - 6:00 PM

    Phone: (204) 555-RANG
    Email: info@rangolithreads.ca

    Visit our store for personalized service and custom alterations!
  CONTENT
end

Rails.logger.debug " Seeded #{Page.count} pages"

Rails.logger.debug "\n Database seeded successfully!"
Rails.logger.debug "Summary:"
Rails.logger.debug "   - #{Province.count} provinces"
Rails.logger.debug "   - #{Category.count} categories"
Rails.logger.debug "   - #{Product.count} products"
Rails.logger.debug "   - #{Page.count} pages"
