fibo_sequence = [0, 1]

while (new_number = fibo_sequence[-1] + fibo_sequence[-2]) < 100 do 
  fibo_sequence << new_number
end

puts fibo_sequence
