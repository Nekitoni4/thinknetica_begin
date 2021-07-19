puts "Input your name, sir:"
name  = gets.chomp
puts "Input your height, sir:"
height = gets.chomp.to_i

idealWeight = (height - 110) * 1.15

if idealWeight < 0
  puts "Your weight is optimal"
else
  puts "#{name}, your ideal weight is #{idealWeight}"
end
