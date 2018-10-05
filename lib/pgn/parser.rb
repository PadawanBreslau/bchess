require 'treetop'

module Bchess
  module PGN
    class ParserException < Exception ;end

    class Parser
      attr_reader :input, :output, :error, :tree

      Treetop.load('./lib/pgn/pgn_rules.treetop')
      @@parser = SexpParser.new

      def initialize(input)
        @input = input
      end

      def parse
        if input.kind_of?(String)
          @tree = @@parser.parse(input)
        elsif input.kind_of?(Bchess::PGN::PGNFile)
          @tree = @@parser.parse(input.load_games)
        end

        if !tree
          raise PGN::ParserException, "Parse error at offset: #{@@parser.index}"
        end

        sanitize_tree(tree)
      end

      private

      def sanitize_tree(root_node)
        root_elements = root_node.elements
        return unless root_elements

        root_elements.delete_if{ |node| node.class.name == "Treetop::Runtime::SyntaxNode" }
        root_elements.each{ |node| sanitize_tree(node) }
      end
    end
  end
end
