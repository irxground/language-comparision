word = 'hello'
word.each_char do |c|
  puts '%s(%i)' % [c, c.ord]
end
