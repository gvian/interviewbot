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

TENS = {
  'eleven': 11,
  'twelve': 12,
  'thirteen': 13,
  'fourteen': 14,
  'fifteen': 15,
  'sixteen': 16,
  'seventeen': 17,
  'eighteen': 18,
  'nineteen': 19,
  'twenty': 20
}.freeze

TENPOWS = {
  'twenty': 20,
  'thirty': 30,
  'forty': 40,
  'fifty': 50,
  'sixty': 60,
  'seventy': 70,
  'eighty': 80,
  'ninety': 90
}.freeze

def text_to_num(text)
  puts "default: #{text}"
  text = subcomp(text)
  text = subsmall(text)

  text = subops(text)

  text = text.split(' ')
  text = divmul(text)
  text = addsub(text)

  text[0].split('.')[1] == '0' ? text[0].to_i : text[0].to_f
end

# Substitutes numbers in range 0-10
def subsmall(text)
  TENPOWS.keys.each do |k|
    text.gsub!(k.to_s, TENPOWS[k].to_s)
  end
  TENS.keys.each do |k|
    text.gsub!(k.to_s, TENS[k].to_s)
  end
  NUMS.keys.each do |k|
    text.gsub!(k.to_s, NUMS[k].to_s)
  end
  text
end

# Substitutes numbers over 0-10 range with units from 1-9
def subcomp(text)
  text = text.split(' ')
  i = 0
  while i < text.length
    if %r{\w+\-\w+}.match?(text[i])
      res = text[i].split('-')
      text[i] = (TENPOWS[res[0].to_sym] + NUMS[res[1].to_sym]).to_s
      i = -1
    end
    i += 1
  end
  text.join(' ')
end

# Substitutes math operators
def subops(text)
  text.gsub!('divided by', '/')
  text.gsub!('times', '*')
  text.gsub!('minus', '-')
  text.gsub!('plus', '+')
  text
end

def divmul(text)
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
  text
end

def addsub(text)
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
  text
end
