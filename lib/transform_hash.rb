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
def transform_hash(hsh, transform_keys_whitelist)
  result = {}
  transform_keys_whitelist.each do |input_path, output_path|
    value = hsh.dig(*input_path.split('.'))
    next unless value.present?
    undig(result, *output_path.split('.'), value.is_a?(ActionController::Parameters) ? value.permit!.to_h : value)
  end
  result
end
