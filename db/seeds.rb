# Seed provinces with correct Canadian tax rates
provinces_data = [
  { name: 'Alberta', gst: 5.0, pst: 0.0, hst: 0.0 },
  { name: 'British Columbia', gst: 5.0, pst: 7.0, hst: 0.0 },
  { name: 'Manitoba', gst: 5.0, pst: 7.0, hst: 0.0 },
  { name: 'New Brunswick', gst: 0.0, pst: 0.0, hst: 15.0 },
  { name: 'Newfoundland and Labrador', gst: 0.0, pst: 0.0, hst: 15.0 },
  { name: 'Northwest Territories', gst: 5.0, pst: 0.0, hst: 0.0 },
  { name: 'Nova Scotia', gst: 0.0, pst: 0.0, hst: 15.0 },
  { name: 'Nunavut', gst: 5.0, pst: 0.0, hst: 0.0 },
  { name: 'Ontario', gst: 0.0, pst: 0.0, hst: 13.0 },
  { name: 'Prince Edward Island', gst: 0.0, pst: 0.0, hst: 15.0 },
  { name: 'Quebec', gst: 5.0, pst: 9.975, hst: 0.0 },
  { name: 'Saskatchewan', gst: 5.0, pst: 6.0, hst: 0.0 },
  { name: 'Yukon', gst: 5.0, pst: 0.0, hst: 0.0 }
]

provinces_data.each do |province_data|
  Province.find_or_create_by!(name: province_data[:name]) do |province|
    province.gst = province_data[:gst]
    province.pst = province_data[:pst]
    province.hst = province_data[:hst]
  end
end

puts "Seeded #{Province.count} provinces"

# Seed pages
Page.find_or_create_by!(slug: 'about') do |page|
  page.title = 'About Us'
  page.content = 'Welcome to Rangoli Threads...'
end

Page.find_or_create_by!(slug: 'contact') do |page|
  page.title = 'Contact Us'
  page.content = 'Get in touch with us...'
end

puts "Seeded pages"
