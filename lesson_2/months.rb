months_and_number_of_days_in_each = {
  January: 31, February: 28, March: 31,
  April: 30, May: 31, June: 30,
  July: 31, August: 31, September: 30,
  October: 31, November: 30, December: 31
}

months_and_number_of_days_in_each.each do |month, count_of_days|
  puts month if count_of_days == 30
end
