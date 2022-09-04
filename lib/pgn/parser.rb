require 'treetop'

module Bchess
  module PGN
    class ParserException < RuntimeError; end

    class Parser
      attr_reader :input, :output, :error, :tree

      Treetop.load(File.expand_path('pgn_rules.treetop', __dir__))

      def initialize(input)
        @parser = SexpParser.new
        @input = input
      end

      def parse
        if input.is_a?(String)
          @tree = @parser.parse(input)
        elsif input.is_a?(Bchess::PGN::PGNFile)
          @tree = @parser.parse(input.load_games)
        end

        unless tree
          raise PGN::ParserException, "Parse error: #{@parser.failure_reason}"
        end

        sanitize_tree(tree)
      end

      private

      def sanitize_tree(root_node)
        root_elements = root_node.elements
        return unless root_elements

        root_elements.delete_if { |node| node.class.name == 'Treetop::Runtime::SyntaxNode' }
        root_elements.each { |node| sanitize_tree(node) }
      end
    end
  end
end
