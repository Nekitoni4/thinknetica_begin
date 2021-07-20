puts "Input your name, sir:"
name  = gets.chomp
puts "Input your height, sir:"
height = gets.to_i

ideal_weight = (height - 110) * 1.15

if ideal_weight < 0
  puts "Your weight is optimal"
else
  puts "#{name}, your ideal weight is #{ideal_weight}"
end
