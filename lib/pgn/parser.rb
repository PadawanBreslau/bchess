require 'rubygems'
require 'treetop'
require_relative 'pgn_nodes.rb'

module Bchess
  module PGN
    class ParserException < Exception ;end
    class Parser
      Treetop.load(File.expand_path(File.join(File.dirname(__FILE__), 'pgn_rules.treetop')))
      @@parser = SexpParser.new

      attr_reader :input, :output, :error, :tree

      def initialize(input)
        @input = input
      end

      def parse
        @tree = @@parser.parse(input)
        if !tree
          puts @@parser.failure_reason
          raise PGN::ParserException, "Parse error at offset: #{@@parser.index}"
        end
        clean_tree(tree)
        read_games(tree)
      end

      private

      ## cleans tree, leaving only nodes from our classess
      def clean_tree(root_node)
        root_elements = root_node.elements
        return unless root_elements
        root_elements.delete_if{|node| node.class.name == "Treetop::Runtime::SyntaxNode" }
        root_elements.each {|node| clean_tree(node) }
      end

      def read_games(root_node)
        root_elements = root_node.elements
        return unless root_elements
        root_elements.each{|game| parse_one_game(game) }
      end


      def parse_one_game(game_root)
        root_elements = game_root.elements
        return unless root_elements
        header, body = root_elements
        header_id = get_header_information(header) if header.class == Sexp::PHeaderBody
        get_game_body(body, header_id) if body.class == Sexp::PAllMovesWithResult
      end

      def get_header_information(header_root)
        root_elements = header_root.elements
        return unless root_elements.present?
        header_hash = Hash.new
        root_elements.each do |header_line|
          parsed_header_line = header_line.selfparse(header_line.text_value)
          header_hash[parsed_header_line[0]] = parsed_header_line[1] unless wrong_format(parsed_header_line[1])
        end
        header_hash
      end

      def get_game_body(body_root, header_id)
        root_elements = body_root.elements
        return if root_elements.nil? || body_root.text_value == ""
        body_id = 0

        root_elements.each do |body_element|
          if body_element.class == Sexp::PMove
            Sexp::PMove.save_move(body_element, body_id)
          elsif body_element.class == Sexp::PComment
            #Sexp::PComment.save_comment(body_element, body_id, last_read_move)
          elsif body_element.class == Sexp::PVariation
            #depth = 1;
            #Sexp::PMove.save_variation(body_element, body_id, depth)
          elsif body_element.class == Sexp::PCastle
            #last_read_move = Sexp::PMove.save_move(body_element, body_id)
          end
        end
      end

      def wrong_format(header_value)
        header_value.empty? || header_value == "?" || header_value == "0"
      end
    end
  end
end
