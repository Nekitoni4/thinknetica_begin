puts "Input first side of triangle, sir:"
a = gets.to_i
puts "Input second side of triangle, sir:"
b = gets.to_i
puts "Input third side of triangle, sir:"
c = gets.to_i


triangle_is_equilateral = a == b && b == c && c == a
triangle_is_isosceles = (a == b) || (b == c) || (c == a)
triangle_is_rectangular = nil


# The first condition is not to do unnecessary calculations
# 
if !triangle_is_equilateral && !triangle_is_isosceles
  hypotenuse_of_triangle = [a, b, c].max
  if a > b && a > c
    triangle_is_rectangular = hypotenuse_of_triangle ** 2 == b ** 2 + c ** 2
  elsif b > a && b > c
    triangle_is_rectangular = h ** 2 == a ** 2 + c ** 2
  elsif c > a && c > b
    triangle_is_rectangular = hypotenuse_of_triangle ** 2 == a ** 2 + b ** 2
  else 
   hypotenuse_of_triangle = false
  end
end


if triangle_is_equilateral
  puts "Triangle is equilateral"
elsif triangle_is_isosceles
  puts "Triangle is isosceles"
elsif triangle_is_rectangular
  puts "Triangle is rectangular"
else 
  puts "Oops, something went wrong"
end
