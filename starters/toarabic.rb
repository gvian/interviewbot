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
