class FuzzyLookup
  def initialize(hash)
    @hash = hash
  end

  def [](key)
    fuzzy_hash[simplify(key)]
  end

  def fuzzy_hash
    @fuzzy_hash ||= @hash.map { |k, v| [simplify(k), v] }.to_h
  end

  private

  def simplify(str)
    str.to_s.downcase.gsub(/[^a-zA-Z0-9]/, '')
  end
end
