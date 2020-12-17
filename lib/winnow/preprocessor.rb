require 'rouge'

module Winnow
  class Preprocessor
    def preprocess
      raise NotImplementedError
    end
  end

  class SourceCode < Preprocessor
      attr_reader :lexer

      def initialize(language)
        @lexer = Rouge::Lexer.find(language)
      end

      def preprocess(str)
        current_index = 0
        processed_chars = []

        lexer.lex(str).to_a.each do |token|
          type, chunk = token

          processed_chunk = if type <= Rouge::Token::Tokens::Name
                              'x'
                            elsif type <= Rouge::Token::Tokens::Comment
                              ''
                            elsif type <= Rouge::Token::Tokens::Text
                              ''
                            else
                              chunk
                            end

          processed_chars += processed_chunk.chars.map do |c|
            [c, current_index]
          end

          current_index += chunk.length
        end

        processed_chars
      end
    end

  class Plaintext < Preprocessor
    def preprocess(str)
        str.chars.each_with_index.to_a
    end
  end
end


