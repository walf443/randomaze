class Randomaze::String::TemplateParser

rule
  exprs     :
            | expr exprs
            {
              result = val
            }

  expr      : IDENT_WORD
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
              result =
                case first
                when '\w'
                  ['a'..'z', 'A'..'Z', 0..9, '_']
                when '\d'
                  [0..9]
                else
                  raise Racc::ParseError, "not support meta character #{first}"
                end
            }

  alnum     : ALPHA
            | NUMCHAR

end

---- header
require 'strscan'

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

def next_token
  @tokens.shift
end

def self.tokenize str
  tokens = []
  s = StringScanner.new str
  set_start_fg = false
  until s.eos? do
    if set_start_fg
      case
      when s.scan(/\\./)
        tokens.push([:META_SET, s[0]])
      when s.scan(/\]/)
        set_start_fg = false
        tokens.push([:SETS_END, ']' ])
      when s.scan(/([A-Za-z0-9])-([A-Za-z0-9])/)
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
      case
      when s.scan(/\[/)
        set_start_fg = true
        tokens.push([:EXPR_START, '[' ])
        tokens.push([:SETS_START, '[' ])
      when s.scan(/\{/)
        tokens.push([:COUNT_START, '{' ])
      when s.scan(/\}/)
        tokens.push([:COUNT_END, '}' ])
      when s.scan(/[0-9]+/)
        tokens.push([:NUMBER, s[0].to_i ])
      when s.scan(%r![^\[\{\}\]]+!)
        tokens.push [:IDENT_WORD, s[0]]
      else
        char = s.getch
        tokens.push [char, char]
      end
    end
  end

  tokens
end

