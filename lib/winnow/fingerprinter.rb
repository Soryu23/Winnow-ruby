module Winnow
  class Fingerprinter
    attr_reader :guarantee, :noise, :preprocessor
    alias guarantee_threshold guarantee
    alias noise_threshold noise

    def initialize(params)
      @guarantee = params[:guarantee_threshold] || params[:t]
      @noise = params[:noise_threshold] || params[:k]
      @preprocessor = params[:preprocessor] || Winnow::Plaintext.new
    end

    def fingerprints(str, params = {})
      source = params[:source]

      fingerprints = {}

      windows(str, source).each do |window|
        least_fingerprint = window.min_by { |fingerprint| fingerprint[:value] }
        value = least_fingerprint[:value]
        location = least_fingerprint[:location].location

        (fingerprints[value] ||= []) << location
      end

      fingerprints.each do |_, value|
        value.uniq!
      end
      fingerprints
    end

    private

    def windows(str, source)
      k_grams(str, source).each_cons(window_size)
    end

    def window_size
      guarantee - noise + 1
    end

    def k_grams(str, source)
      tokens(str).each_cons(noise).map do |tokens_k_gram|
        value = hash(tokens_k_gram.map { |(char)| char }.join)
        location = Location.new(source, tokens_k_gram.first[1])

        { value: value, location: location }
      end
    end

    def tokens(str)
      preprocessor.preprocess(str)
    end

    def hash(str)
      if str.respond_to?(:consistent_hash)
        str.consistent_hash
      else
        str.hash
      end
    end
  end
end
