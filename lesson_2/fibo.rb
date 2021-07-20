fibo_sequence = [0, 1]

loop do 
  last_elem = fibo_sequence.last
  prev_last_elem = fibo_sequence[fibo_sequence.length - 2]
  target_elem = last_elem + prev_last_elem
  target_elem > 100 ? break : fibo_sequence.push(target_elem)
end

puts fibo_sequence
