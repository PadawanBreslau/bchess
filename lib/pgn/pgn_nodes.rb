module Sexp
  class PAllGames < Treetop::Runtime::SyntaxNode
  end

  class PGame < Treetop::Runtime::SyntaxNode
  end

  class PHeaderBody < Treetop::Runtime::SyntaxNode
  end

  class PHeader < Treetop::Runtime::SyntaxNode
    def parse(value)
      val = value.split(' ', 2)

      [val[0].delete('['), val[1].delete('"]').rstrip]
    end
  end

  class PAllMoves < Treetop::Runtime::SyntaxNode
  end

  class PAllMovesWithResult < Treetop::Runtime::SyntaxNode
  end

  class POneMove < Treetop::Runtime::SyntaxNode
  end

  class PMove < Treetop::Runtime::SyntaxNode
  end

  class PMoveNumber < Treetop::Runtime::SyntaxNode
  end

  class PComment < Treetop::Runtime::SyntaxNode
  end

  class PCommentWithBracket < Treetop::Runtime::SyntaxNode
  end

  class PVariation < Treetop::Runtime::SyntaxNode
  end

  class PResult < Treetop::Runtime::SyntaxNode
  end

  class PTakes < Treetop::Runtime::SyntaxNode
  end

  class PInteger < Treetop::Runtime::SyntaxNode
  end

  class PFloat < Treetop::Runtime::SyntaxNode
  end

  class PString < Treetop::Runtime::SyntaxNode
  end

  class PIdentifier < Treetop::Runtime::SyntaxNode
  end

  class PCastle < Treetop::Runtime::SyntaxNode
  end

  class PTime < Treetop::Runtime::SyntaxNode
  end

  class PTimeIdentifier < Treetop::Runtime::SyntaxNode
  end
end

class Treetop::Runtime::SyntaxNode
  def create_value_hash
    hash = {}

    elements.each do |element|
      key = element.elements.first.text_value
      value = element.elements.last.text_value

      hash[key] = value.delete('"')
    end

    hash
  end
end
