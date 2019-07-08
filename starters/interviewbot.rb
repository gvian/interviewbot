#
# Ruby automated interviewbot example
#
# Can you write a program that passes the interviewbot test?
#
require 'net/http'
require 'json'

def main
  # get started
  # get the path to the first question
  start_result = post_json('/interviewbot/start', login: 'gvian')
  question_path = start_result['nextQuestion']

  loop do
    # Answer each question
    # get the next question
    question = get_json(question_path)

    # your code to figure out the answer goes here
    answer = answer_question(question)

    # send it to interviewbot
    answer_result = send_answer(question_path, answer)

    break if answer_result['result'] != 'correct'

    question_path = answer_result['nextQuestion']
  end
end

ROMAN = {
  'CM': 900,
  'M': 1000,
  'CD': 400,
  'D': 500,
  'XC': 90,
  'C': 100,
  'XL': 40,
  'L': 50,
  'IX': 9,
  'X': 10,
  'IV': 4,
  'V': 5,
  'I': 1
}.freeze

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

def answer_question(question)
  q = question['question']
  return get_factors(q) if q.is_a?(Integer)
  return to_arabic(q) if q.is_a?(String) && q[0].upcase == q[0]
  return text_to_num(q) if q.is_a?(String) && q[0].downcase == q[0]

  ''
end

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

def to_arabic(rom)
  arab = 0
  ROMAN.keys.each do |k|
    while rom.include?(k.to_s)
      rom = rom.sub(k.to_s, '')
      arab += ROMAN[k]
    end
  end
  arab
end

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

def send_answer(path, answer)
  post_json(path, answer: answer)
end

# get data from the api and parse it into a ruby hash
def get_json(path)
  puts "*** GET #{path}"

  response = Net::HTTP.get_response(build_uri(path))
  result = JSON.parse(response.body)
  puts "HTTP #{response.code}"

  puts JSON.pretty_generate(result)
  result
end

# post an answer to the noops api
def post_json(path, body)
  uri = build_uri(path)
  puts "*** POST #{path}"
  puts JSON.pretty_generate(body)

  post_request = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
  post_request.body = JSON.generate(body)

  response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
    http.request(post_request)
  end

  puts "HTTP #{response.code}"
  result = JSON.parse(response.body)
  puts JSON.pretty_generate(result)
  result
end

def build_uri(path)
  domain = 'https://api.noopschallenge.com'
  URI.parse(domain + path)
end

main
