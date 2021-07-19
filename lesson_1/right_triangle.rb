puts "Input first side of triangle, sir:"
a = gets.chomp.to_i
puts "Input second side of triangle, sir:"
b = gets.chomp.to_i
puts "Input third side of triangle, sir:"
c = gets.chomp.to_i

triangleIsEquilateral = a == b && b == c && c == a

triangleIsIsosceles = (a == b) || (b == c) || (c == a)

triangleIsRectangular = nil

if a > b && a > c
  hypotenuseOfTriangle = a
  triangleIsRectangular = hypotenuseOfTriangle ** 2 == b ** 2 + c ** 2
elsif b > a && b > c
  hypotenuseOfTriangle = b
  triangleIsRectangular = hypotenuseOfTriangle ** 2 == a ** 2 + c ** 2
elsif c > a && c > b
  hypotenuseOfTriangle = c
  triangleIsRectangular = hypotenuseOfTriangle ** 2 == a ** 2 + b ** 2
else 
  hypotenuseOfTriangle = false
end

if triangleIsEquilateral
  puts "Triangle is equilateral"
elsif triangleIsIsosceles
  puts "Triangle is isosceles"
elsif triangleIsRectangular
  puts "Triangle is rectangular"
else 
  puts "Oops, something went wrong"
end
