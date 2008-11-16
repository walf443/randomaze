#
# DO NOT MODIFY!!!!
# This file is automatically generated by racc 1.4.5
# from racc grammer file "lib/randomaze/string/template_parser.y".
#

require 'racc/parser'


require 'strscan'


module Randomaze

  module String

    class TemplateParser < Racc::Parser

module_eval <<'..end lib/randomaze/string/template_parser.y modeval..idf87ddbb7d4', 'lib/randomaze/string/template_parser.y', 88

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
  set_start_fg = false
  until s.eos? do
    if set_start_fg
      case
      when s.scan(/\\./)
        tokens.push([:META_SET, s[0]])
      when s.scan(/\]/)
        set_start_fg = false
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
      case
      when s.scan(/\\./)
        tokens.push([:META_SET, s[0]])
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

..end lib/randomaze/string/template_parser.y modeval..idf87ddbb7d4

##### racc 1.4.5 generates ###

racc_reduce_table = [
 0, 0, :racc_error,
 0, 16, :_reduce_none,
 2, 16, :_reduce_2,
 1, 17, :_reduce_none,
 1, 17, :_reduce_4,
 2, 17, :_reduce_5,
 3, 17, :_reduce_6,
 3, 19, :_reduce_7,
 3, 18, :_reduce_8,
 0, 20, :_reduce_none,
 2, 20, :_reduce_10,
 1, 21, :_reduce_none,
 1, 21, :_reduce_12,
 1, 22, :_reduce_13,
 1, 23, :_reduce_none,
 1, 23, :_reduce_none,
 2, 23, :_reduce_none,
 1, 23, :_reduce_17,
 1, 24, :_reduce_none,
 1, 24, :_reduce_none ]

racc_reduce_n = 20

racc_shift_n = 30

racc_action_table = [
    20,     1,     2,     3,     6,    20,    12,    22,    13,    15,
    17,    19,    22,    13,    15,    17,    19,     1,     2,     3,
     6,    10,    25,    26,    27,    28,     8 ]

racc_action_check = [
    23,     0,     0,     0,     9,     8,     6,    23,    23,    23,
    23,    23,     8,     8,     8,     8,     8,     5,     5,     5,
     2,     4,    10,    12,    15,    21,     3 ]

racc_action_pointer = [
    -1,   nil,    13,    21,    21,    15,    -2,   nil,     2,    -3,
    22,   nil,    14,   nil,   nil,    12,   nil,   nil,   nil,   nil,
   nil,    19,   nil,    -3,   nil,   nil,   nil,   nil,   nil,   nil ]

racc_action_default = [
    -1,    -3,    -4,   -20,   -20,    -1,   -20,    -5,    -9,   -20,
   -20,    -2,   -20,   -14,   -11,   -20,   -12,   -18,   -15,   -19,
   -17,   -20,   -13,    -9,    -6,    30,    -8,   -16,    -7,   -10 ]

racc_goto_table = [
    21,     7,     4,     9,   nil,   nil,   nil,    11,    24,   nil,
   nil,   nil,   nil,   nil,   nil,    29 ]

racc_goto_check = [
     5,     3,     1,     4,   nil,   nil,   nil,     1,     3,   nil,
   nil,   nil,   nil,   nil,   nil,     5 ]

racc_goto_pointer = [
   nil,     2,   nil,    -1,     0,    -8,   nil,   nil,   nil,   nil ]

racc_goto_default = [
   nil,   nil,     5,   nil,   nil,   nil,    23,    14,    16,    18 ]

racc_token_table = {
 false => 0,
 Object.new => 1,
 :IDENT_WORD => 2,
 :META_SET => 3,
 :EXPR_START => 4,
 :SETS_START => 5,
 :SETS_END => 6,
 :COUNT_START => 7,
 :NUMBER => 8,
 :COUNT_END => 9,
 :RANGE => 10,
 :IDENT => 11,
 :meta_set => 12,
 :ALPHA => 13,
 :NUMCHAR => 14 }

racc_use_result_var = true

racc_nt_base = 15

Racc_arg = [
 racc_action_table,
 racc_action_check,
 racc_action_default,
 racc_action_pointer,
 racc_goto_table,
 racc_goto_check,
 racc_goto_default,
 racc_goto_pointer,
 racc_nt_base,
 racc_reduce_table,
 racc_token_table,
 racc_shift_n,
 racc_reduce_n,
 racc_use_result_var ]

Racc_token_to_s_table = [
'$end',
'error',
'IDENT_WORD',
'META_SET',
'EXPR_START',
'SETS_START',
'SETS_END',
'COUNT_START',
'NUMBER',
'COUNT_END',
'RANGE',
'IDENT',
'meta_set',
'ALPHA',
'NUMCHAR',
'$start',
'exprs',
'expr',
'count_expr',
'sets_expr',
'sets',
'set',
'range',
'ident',
'alnum']

Racc_debug_parser = false

##### racc system variables end #####

 # reduce 0 omitted

 # reduce 1 omitted

module_eval <<'.,.,', 'lib/randomaze/string/template_parser.y', 8
  def _reduce_2( val, _values, result )
              result = val
   result
  end
.,.,

 # reduce 3 omitted

module_eval <<'.,.,', 'lib/randomaze/string/template_parser.y', 15
  def _reduce_4( val, _values, result )
              token = val.shift
              result = [ meta_set(token), 1]
   result
  end
.,.,

module_eval <<'.,.,', 'lib/randomaze/string/template_parser.y', 20
  def _reduce_5( val, _values, result )
              token, count = val
              result = [ meta_set(token), count ]
   result
  end
.,.,

module_eval <<'.,.,', 'lib/randomaze/string/template_parser.y', 30
  def _reduce_6( val, _values, result )
              first = val.shift
              result = nil
              if first == '['
                result = val
              else
                result = first
              end
   result
  end
.,.,

module_eval <<'.,.,', 'lib/randomaze/string/template_parser.y', 41
  def _reduce_7( val, _values, result )
              array = []
              val[1].flatten.each do |range|
                next unless range
                array << range
              end

              result = array.uniq
   result
  end
.,.,

module_eval <<'.,.,', 'lib/randomaze/string/template_parser.y', 46
  def _reduce_8( val, _values, result )
              result = val[1]
   result
  end
.,.,

 # reduce 9 omitted

module_eval <<'.,.,', 'lib/randomaze/string/template_parser.y', 52
  def _reduce_10( val, _values, result )
              result = val
   result
  end
.,.,

 # reduce 11 omitted

module_eval <<'.,.,', 'lib/randomaze/string/template_parser.y', 58
  def _reduce_12( val, _values, result )
              result = val
   result
  end
.,.,

module_eval <<'.,.,', 'lib/randomaze/string/template_parser.y', 68
  def _reduce_13( val, _values, result )
              first,last = val.first.to_a
              if first =~ /\d/ && last =~ /\d/
                first = first.to_i
                last  = last.to_i
              end
              result = first..last
   result
  end
.,.,

 # reduce 14 omitted

 # reduce 15 omitted

 # reduce 16 omitted

module_eval <<'.,.,', 'lib/randomaze/string/template_parser.y', 77
  def _reduce_17( val, _values, result )
              first = val.shift
              result = meta_set(first)
   result
  end
.,.,

 # reduce 18 omitted

 # reduce 19 omitted

 def _reduce_none( val, _values, result )
  result
 end

    end   # class TemplateParser

  end   # module String

end   # module Randomaze
