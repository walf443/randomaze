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

module_eval <<'..end lib/randomaze/string/template_parser.y modeval..id4a036b05d9', 'lib/randomaze/string/template_parser.y', 86

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

..end lib/randomaze/string/template_parser.y modeval..id4a036b05d9

##### racc 1.4.5 generates ###

racc_reduce_table = [
 0, 0, :racc_error,
 0, 16, :_reduce_none,
 2, 16, :_reduce_2,
 1, 17, :_reduce_none,
 3, 17, :_reduce_4,
 3, 18, :_reduce_5,
 3, 19, :_reduce_6,
 0, 20, :_reduce_none,
 2, 20, :_reduce_8,
 1, 21, :_reduce_none,
 1, 21, :_reduce_10,
 1, 22, :_reduce_11,
 1, 23, :_reduce_none,
 1, 23, :_reduce_none,
 2, 23, :_reduce_none,
 1, 23, :_reduce_15,
 1, 24, :_reduce_none,
 1, 24, :_reduce_none ]

racc_reduce_n = 18

racc_shift_n = 28

racc_action_table = [
    16,    18,     9,    11,    13,    15,    16,    18,     9,    11,
    13,    15,     1,     2,     1,     2,    22,    20,     7,    23,
    24,     5,    26,    27 ]

racc_action_check = [
     5,     5,     5,     5,     5,     5,    19,    19,    19,    19,
    19,    19,     0,     0,     4,     4,     7,     6,     3,     9,
    17,     2,    20,    26 ]

racc_action_pointer = [
    10,   nil,    17,    18,    12,    -9,    11,    16,   nil,     8,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,    15,   nil,    -3,
    15,   nil,   nil,   nil,   nil,   nil,    15,   nil ]

racc_action_default = [
    -1,    -3,   -18,   -18,    -1,    -7,   -18,   -18,    -2,   -18,
    -9,   -15,   -10,   -16,   -13,   -17,   -11,   -18,   -12,    -7,
   -18,    -4,    28,   -14,    -5,    -8,   -18,    -6 ]

racc_goto_table = [
    17,     3,     6,    21,   nil,     8,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,    25 ]

racc_goto_check = [
     5,     1,     3,     4,   nil,     1,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,     5 ]

racc_goto_pointer = [
   nil,     1,   nil,     0,    -3,    -5,   nil,   nil,   nil,   nil ]

racc_goto_default = [
   nil,   nil,     4,   nil,   nil,   nil,    19,    10,    12,    14 ]

racc_token_table = {
 false => 0,
 Object.new => 1,
 :IDENT_WORD => 2,
 :EXPR_START => 3,
 :SETS_START => 4,
 :SETS_END => 5,
 :COUNT_START => 6,
 :NUMBER => 7,
 :COUNT_END => 8,
 :RANGE => 9,
 :IDENT => 10,
 :meta_set => 11,
 :META_SET => 12,
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
'EXPR_START',
'SETS_START',
'SETS_END',
'COUNT_START',
'NUMBER',
'COUNT_END',
'RANGE',
'IDENT',
'meta_set',
'META_SET',
'ALPHA',
'NUMCHAR',
'$start',
'exprs',
'expr',
'sets_expr',
'count_expr',
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

module_eval <<'.,.,', 'lib/randomaze/string/template_parser.y', 20
  def _reduce_4( val, _values, result )
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

module_eval <<'.,.,', 'lib/randomaze/string/template_parser.y', 31
  def _reduce_5( val, _values, result )
              array = []
              val[1].flatten.each do |range|
                next unless range
                array << range
              end

              result = array.uniq
   result
  end
.,.,

module_eval <<'.,.,', 'lib/randomaze/string/template_parser.y', 36
  def _reduce_6( val, _values, result )
              result = val[1]
   result
  end
.,.,

 # reduce 7 omitted

module_eval <<'.,.,', 'lib/randomaze/string/template_parser.y', 42
  def _reduce_8( val, _values, result )
              result = val
   result
  end
.,.,

 # reduce 9 omitted

module_eval <<'.,.,', 'lib/randomaze/string/template_parser.y', 48
  def _reduce_10( val, _values, result )
              result = val
   result
  end
.,.,

module_eval <<'.,.,', 'lib/randomaze/string/template_parser.y', 58
  def _reduce_11( val, _values, result )
              first,last = val.first.to_a
              if first =~ /\d/ && last =~ /\d/
                first = first.to_i
                last  = last.to_i
              end
              result = first..last
   result
  end
.,.,

 # reduce 12 omitted

 # reduce 13 omitted

 # reduce 14 omitted

module_eval <<'.,.,', 'lib/randomaze/string/template_parser.y', 75
  def _reduce_15( val, _values, result )
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
   result
  end
.,.,

 # reduce 16 omitted

 # reduce 17 omitted

 def _reduce_none( val, _values, result )
  result
 end

    end   # class TemplateParser

  end   # module String

end   # module Randomaze
