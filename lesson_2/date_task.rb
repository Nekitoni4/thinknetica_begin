puts "Plz, input date, sir:"
number = gets.to_i
puts "Plz, input month, sir:"
month = gets.to_i
puts "Plz, input year, sir:"
year = gets.to_i

is_leap_year = (year % 4 == 0) || (year % 100 == 0 && year % 400 == 0)

serial_months_and_number_of_days = {
  1 => 31, 2 => is_leap_year ? 29 : 28, 
  3 => 31, 4 => 30, 5 => 31, 6 => 30, 7 => 31, 8 => 31,
  9 => 30, 10 => 31, 11 => 30, 12 => 31
}

date_serial_number = 0

serial_months_and_number_of_days.each do |serial_month, count_days|
  if serial_month == month
    date_serial_number += number
    break
  end
  date_serial_number += count_days
end

puts "The serial number of the is #{date_serial_number}"
