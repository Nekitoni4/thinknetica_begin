puts "Input a coefficient plz, sir:"
a = gets.to_i
puts "Input b coefficient plz, sir:"
b = gets.to_i
puts "Input c coefficient plz, sir:"
c = gets.to_i

d = b**2 - 4 * a * c

if d < 0
  puts "No roots. bro;("
elsif d == 0
  x = -b/(2.0 * a)
  puts "Discriminant is #{d}, x is #{x}"
else
  discRoot = Math.sqrt(d)
  x1 = (-b + discRoot)/2 * a
  x2 = (-b - discRoot)/2 * a
  puts "Discriminant is #{d}, x1 is #{x1}, x2 is #{x2}"
end
