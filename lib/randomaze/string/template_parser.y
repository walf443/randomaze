class Randomaze::String::TemplateParser

rule
  exprs     :
            | expr exprs
            {
              result = val
            }

  expr      : EXPR_START sets_expr count_expr
            {
              val.shift
              result = val
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

  set       : alnum '-' alnum
            {
              result = val[0]..val[2]
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
  @tokens = []
  @s = StringScanner.new(str)
  scan_str
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

def scan_str
  set_start_fg = false
  until @s.eos? do
    if set_start_fg
      case
      when @s.scan(/\]/)
        set_start_fg = false
        @tokens.push([:SETS_END, '[' ])
      when @s.scan(/[0-9]+/)
        raise Racc::ParseError, "#{@s[0]} is wrong" if @s[0].size > 1
        @tokens.push([:NUMCHAR, @s[0].to_i ])
      when @s.scan(/[a-zA-Z]/)
        @tokens.push([:ALPHA, @s[0] ])
      when @s.scan(/-/)
        @tokens.push(['-', @s[0] ])
      else
        raise Racc::ParseError, "#{@s[0]} is wrong"
      end
    else
      case
      when @s.scan(/\[/)
        set_start_fg = true
        @tokens.push([:EXPR_START, '[' ])
        @tokens.push([:SETS_START, '[' ])
      when @s.scan(/\{/)
        @tokens.push([:COUNT_START, '{' ])
      when @s.scan(/\}/)
        @tokens.push([:COUNT_END, '}' ])
      when @s.scan(/[0-9]+/)
        @tokens.push([:NUMBER, @s[0].to_i ])
      else
        s = @s.getch
        @tokens.push [s, s]
      end
    end
  end
end

