class Randomaze::String::TemplateParser

rule
  exprs     :
            | expr exprs
            {
              result = val
            }

  expr      : IDENT_WORD
            | DOT
            {
              token = val.shift
              result = [ ['a'..'z', 'A'..'Z', 0..9, '_'], 1 ]
            }
            | SELECT_START expr '|' expr SELECT_END
            {
              result = Set.new([val[1], val[3]])
            }
            | META_SET
            {
              token = val.shift
              result = [ meta_set(token), 1]
            }
            | EXPR_START sets_expr
            {
              result = [ val[1], 1]
            }
            | DOT count_expr
            {
              token, count = val
              result = [ ['a'..'z', 'A'..'Z', 0..9, '_'], count ]
            }
            | META_SET count_expr
            {
              token, count = val
              result = [ meta_set(token), count ]
            }
            | EXPR_START sets_expr count_expr
            {
              first = val.shift
              result = nil
              if first == '['
                result = val
              else
                result = first
              end
            }

  sets_expr : SETS_START sets SETS_END
            {
              array = []
              val[1].flatten.each do |range|
                next unless range
                array << range
              end

              result = array.uniq
            }

  count_expr : COUNT_START NUMBER COUNT_END
             {
               result = val[1]
             }
             | COUNT_START NUMBER ',' NUMBER COUNT_END
             {
               result = val[1]..val[3]
             }
             | QUESTION
             {
               result = 0..1
             }

  sets      :
            | set sets
            {
              result = val
            }

  set       : range
            | ident
            {
              result = val
            }

  range     : RANGE
            {
              first,last = val.first.to_a
              if first =~ /\d/ && last =~ /\d/
                first = first.to_i
                last  = last.to_i
              end
              result = first..last
            }
  ident     : IDENT
            | alnum
            | meta_set

  meta_set  | META_SET
            {
              first = val.shift
              result = meta_set(first)
            }

  alnum     : ALPHA
            | NUMCHAR

end

---- header
require 'strscan'
require 'set'

---- inner

def self.parse str
  new.parse(str)
end

def parse str
  raise Racc::ParseError if str.empty?
  @tokens = self.class.tokenize str
  result = do_parse
  arr = []
  tmp = result
  while tmp[1].kind_of? Array
    arr << tmp.first
    tmp = tmp[1]
  end
  arr << tmp.first

  arr
end

def meta_set str
  case str
  when '\w'
    # FIXME: \w is not generate multi byte character.
    ['a'..'z', 'A'..'Z', 0..9, '_']
  when '\d'
    [0..9]
  else
    raise Racc::ParseError, "not support meta character #{first}"
  end
end

def next_token
  @tokens.shift
end

def self.tokenize str
  tokens = []
  s = StringScanner.new str
  state = :default
  until s.eos? do
    case state
    when :default
      case
      when s.scan(/\\[a-z]/)
        tokens.push([:META_SET, s[0]])
      when s.scan(/\./)
        tokens.push([:DOT, s[0]])
      when s.scan(/\?/)
        tokens.push([:QUESTION, s[0]])
      when s.scan(/\[/)
        state = :set_expr
        tokens.push([:EXPR_START, '[' ])
        tokens.push([:SETS_START, '[' ])
      when s.scan(/\(/)
        tokens.push([:SELECT_START, '(' ])
      when s.scan(/\)/)
        tokens.push([:SELECT_END, ')' ])
      when s.scan(/\|/)
        tokens.push(['|', '|' ])
      when s.scan(/\{/)
        state = :count_expr
        tokens.push([:COUNT_START, '{' ])
      when s.scan(%r![^\)|\\\[\{\}\]]+!)
        tokens.push [:IDENT_WORD, s[0]]
      when s.scan(%r!\\([\?\[\]\{\}\*\+\^\$\\\.\|\(\)])!)
        tokens.push [:IDENT_WORD, s[1]]
      else
        char = s.getch
        tokens.push [char, char]
      end
    when :count_expr
      case
      when s.scan(/\}/)
        state = :default
        tokens.push([:COUNT_END, '}' ])
      when s.scan(/[0-9]+/)
        tokens.push([:NUMBER, s[0].to_i ])
      when s.scan(/,/)
        tokens.push([',', ','])
      else
        char = s.getch
        raise Racc::ParseError, "invalid char #{char}"
      end

    when :set_expr
      case
      when s.scan(/\\[a-z]/)
        tokens.push([:META_SET, s[0]])
      when s.scan(/\]/)
        state = :default
        tokens.push([:SETS_END, ']' ])
      when s.scan(/([\w])-([\w])/)
        tokens.push([ :RANGE, [ s[1], s[2] ] ])

      when s.scan(/[0-9]+/)
        raise Racc::ParseError, "#{s[0]} is wrong" if s[0].size > 1
        tokens.push([:NUMCHAR, s[0].to_i ])
      when s.scan(/[a-zA-Z]/)
        tokens.push([:ALPHA, s[0] ])
      when s.scan(/-/)
        tokens.push(['-', s[0] ])
      else
        char = s.getch
        tokens.push [:IDENT, char]
      end
    else
      raise "must not happend!!"
    end
  end

  tokens
end

