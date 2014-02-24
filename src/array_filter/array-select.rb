nums = [1, 2, 3, 4, 5]
odds = nums.select{ |x| x % 2 != 0 }
p odds
