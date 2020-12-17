require_relative 'winnow/preprocessor'
require_relative 'winnow/fingerprinter'
require_relative 'winnow/matcher'

module Winnow
  class Location
    attr_reader :location

    def initialize(source, index)
      @location = { source: source, index: index }
    end
    #= Struct.new(:source, :index) do
  end

  class MatchDatum
    attr_reader :match

    def initialize(matches_from_a, matches_from_b)
      @match = { matches_from_a: matches_from_a, matches_from_b: matches_from_b }
    end
  end

  # MatchDatum = Struct.new(:matches_from_a, :matches_from_b) do
  # end
end
