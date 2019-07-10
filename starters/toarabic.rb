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
