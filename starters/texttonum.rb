NUMS = {
    'zero': 0,
    'one': 1,
    'two': 2,
    'three': 3,
    'four': 4,
    'five': 5,
    'six': 6,
    'seven': 7,
    'eight': 8,
    'nine': 9,
    'ten': 10
}.freeze

# TODO: add 10 powers support (thirty-one)
def text_to_num(text)
  text.gsub!('divided by', '/')
  text.gsub!('times', '*')
  text.gsub!('minus', '-')
  text.gsub!('plus', '+')

  NUMS.keys.each do |k|
    text.gsub!(k.to_s, NUMS[k].to_s)
  end

  # Divisions and multiplications
  text = text.split(' ')
  i = 0
  while i < text.length
    if %r{\d*.?\d+ \/ \d+.?\d*}.match?(text[i..i + 2].join(' '))
      result = text[i].to_f / text[i + 2].to_f
      text[i] = result.to_s
      text.delete_at(i + 2)
      text.delete_at(i + 1)
      i = -1
    end

    if %r{\d*.?\d+ \* \d+.?\d*}.match?(text[i..i + 2].join(' '))
      result = text[i].to_f * text[i + 2].to_f
      text[i] = result.to_s
      text.delete_at(i + 2)
      text.delete_at(i + 1)
      i = -1
    end
    i += 1
  end

  # Addition and subtraction
  i = 0
  while i < text.length
    if %r{\d*.?\d+ \+ \d+.?\d*}.match?(text[i..i + 2].join(' '))
      result = text[i].to_f + text[i + 2].to_f
      text[i] = result.to_s
      text.delete_at(i + 2)
      text.delete_at(i + 1)
      i = -1
    end

    if %r{\d*.?\d+ \- \d+.?\d*}.match?(text[i..i + 2].join(' '))
      result = text[i].to_f - text[i + 2].to_f
      text[i] = result.to_s
      text.delete_at(i + 2)
      text.delete_at(i + 1)
      i = -1
    end
    i += 1
  end
  text[0].split('.')[1] == '0' ? text[0].to_i : text[0].to_f
end