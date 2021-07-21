vowels_letter = ['a', 'e', 'i', 'o', 'u']
map_vowels_to_number_in_alphabet = {}
alphabet_letters = ('a'..'z').to_a

alphabet_letters.each do |letter|
  map_vowels_to_number_in_alphabet[letter] = alphabet_letters.index(letter) + 1 if vowels_letter.include?(letter)
end

puts map_vowels_to_number_in_alphabet
