class String
  def to_slug
    downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
  end
end
class Hash
  def filter(keys)
    select { |key, value| keys.include? key }
  end
  def to_params
    self.map{|k,v| "#{k.to_s}=#{ v.is_a?(Array) ? v.join(",") : v.is_a?(Hash) ? v.to_params.join("&") : v.to_s }" }.join("&")
  end
end