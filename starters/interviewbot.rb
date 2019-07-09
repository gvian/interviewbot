#
# Ruby automated interviewbot example
#
# Can you write a program that passes the interviewbot test?
#
require 'net/http'
require 'json'

require_relative 'getfactors'
require_relative 'toarabic'
require_relative 'texttonum'

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

def answer_question(question)
  q = question['question']
  return get_factors(q) if q.is_a?(Integer)
  return to_arabic(q) if q.is_a?(String) && q[0].upcase == q[0]
  return text_to_num(q) if q.is_a?(String) && q[0].downcase == q[0]

  ''
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