products_data = Hash.new

loop do 
  puts "Sir, plz, input product name:"
  product_name = gets.chomp
  break if product_name.eql?("stop")
  puts "Sir, plz, input unit price:"
  unit_price = gets.to_i
  puts "Sir, plz, input quantity of goods:"
  quantity = gets.to_i
  products_data[product_name] = { 
    quantity: quantity,
    unit_price: unit_price
  }
end

puts products_data

products_data.each { |product_name, product_data| puts "Total amount for #{product_name}: " + 
                     "#{product_data[:quantity] * product_data[:unit_price]}" }


total = products_data.values.inject(0) { |sum, product_data| sum + product_data[:quantity] * product_data[:unit_price]}

puts "The total amount of the basket is #{total}"

