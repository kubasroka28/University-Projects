{
open Parser
}

let white = [' ' '\t' '\r']+
let digit = ['0'-'9']
let char = ['a'-'z' 'A'-'Z' '_']
let number = digit+
let ident = char(char|digit)*

rule token =
  parse
  | '\n'  { Lexing.new_line lexbuf; token lexbuf }
  | white { token lexbuf }
  | "(*"  { block_comment 1 lexbuf }
  | "("       { BR_OPN  }
  | ")"       { BR_CLS  }
  | "["       { SBR_OPN }
  | "]"       { SBR_CLS }
  | "{"       { CBR_OPN }
  | "}"       { CBR_CLS }
  | "="       { EQ      }
  | "<>"      { NEQ     }
  | "<"       { LT      }
  | ">"       { GT      }
  | "<="      { LEQ     }
  | ">="      { GEQ     }
  | "≠"       { NEQ     }
  | "≤"       { LEQ     }
  | "≥"       { GEQ     }
  | "+"       { PLUS    }
  | "-"       { MINUS   }
  | "*"       { TIMES   }
  | "/"       { DIV     }
  | "->"      { ARR     }
  | "|"       { BAR     }
  | ":"       { COLON   }
  | ","       { COMMA   }
  | "absurd"  { ABSURD  }
  | "and"     { AND     }
  | "axiom"   { AXIOM   }
  | "case"    { CASE    }
  | "exists"  { EXISTS  }
  | "false"   { FALSE   }
  | "forall"  { FORALL  }
  | "from"    { FROM    }
  | "fst"     { FST     }
  | "fun"     { FUN     }
  | "in"      { IN      }
  | "left"    { LEFT    }
  | "lemma"   { THEOREM }
  | "let"     { LET     }
  | "not"     { NOT     }
  | "of"      { OF      }
  | "or"      { OR      }
  | "pack"    { PACK    }
  | "proof"   { PROOF   }
  | "qed"     { QED     }
  | "right"   { RIGHT   }
  | "snd"     { SND     }
  | "theorem" { THEOREM }
  | "unpack"  { UNPACK  }
  | "→"       { ARR     }
  | "⊥"       { FALSE   }
  | "∃"       { EXISTS  }
  | "∀"       { FORALL  }
  | "∧"       { AND     }
  | "∨"       { OR      }
  | "¬"       { NOT     }
  | "ιᵢ"      { LEFT    }
  | "ι₂"      { RIGHT   }
  | "π₁"      { FST     }
  | "π₂"      { SND     }
  | number as n { NUM (int_of_string n) }
  | ident  as x { IDENT x }
  | eof { EOF }

and block_comment depth =
  parse
  | '\n' { Lexing.new_line lexbuf; block_comment depth lexbuf }
  | "(*" { block_comment (depth+1) lexbuf }
  | "*)" { if depth = 1 then token lexbuf
           else block_comment (depth-1) lexbuf }
  | ['(' '*'] { block_comment depth lexbuf }
  | [^'\n' '(' '*']+ { block_comment depth lexbuf }
