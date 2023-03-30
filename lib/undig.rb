# sets deeply nested key in hash
# modifies the provided hash and returns it
# the reverse of dig
# Example
# h = { }
# undig(h, 'a', 'b', 5) => { 'a' => { 'b' => 5 } }
def undig(h, *keys, value)
  keys.reduce(h) do |acc, key|
    if key == keys.last
      acc[key] = value
      h
    else
      acc[key] = {}
      acc[key]
    end
  end
  h
end
