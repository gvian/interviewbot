def get_factors(num)
  factors = []
  # While num is even
  while (num % 2).zero?
    factors.push(2)
    num /= 2
  end

  # While num is odd
  (3..Math.sqrt(num).to_i + 1).step(2) do |i|
    while (num % i).zero?
      factors.push(i)
      num /= i
    end
  end
  factors
end
