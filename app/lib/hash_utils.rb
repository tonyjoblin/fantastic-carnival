# frozen_string_literal: true

module HashUtils
  # sets deeply nested key in hash
  # modifies the provided hash and returns it
  # the reverse of dig
  # Example
  # h = { }
  # undig(h, 'a', 'b', 5) => { 'a' => { 'b' => 5 } }
  def self.undig(hash, *keys, value)
    keys.reduce(hash) do |acc, key|
      acc[key] = key == keys.last ? value : {}
      acc[key]
    end
    hash
  end

  # Returns a new hash. Transforms keys in the original hash
  # using a white list.
  # hsh may also be a ActionController::Parameters instance
  # transform looks like
  # {
  #   "reservation.code" => "code",
  #   "reservation.start_date" => "start_date",
  #   "reservation.end_date" => "end_date",
  #   "reservation.guest_details" => "guest_details"
  # }
  # TODO: doesn't handle moving to root level
  def self.transform_hash(hsh, transform_keys_whitelist)
    result = {}
    transform_keys_whitelist.each do |input_path, output_path|
      value = hsh.dig(*input_path.split('.'))
      next if value.blank?

      undig(result, *output_path.split('.'),
            value.is_a?(ActionController::Parameters) ? value.permit!.to_h : value)
    end
    result
  end

  # returns true if the hash has all the keys
  # keys can be deeply nested
  # a key can be like 'a', 'a.b'
  def self.keys?(params, keys)
    keys.map { |key| key?(params, key) }.all?
  end

  # returns true if the hash has the key
  # the key can be deeply nested
  # a key can be like 'a', 'a.b'
  def self.key?(params, key)
    params.dig(*key.split('.')).present?
  rescue StandardError
    false
  end
end
