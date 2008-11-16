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

module_eval <<'..end lib/randomaze/string/template_parser.y modeval..id0afb289b33', 'lib/randomaze/string/template_parser.y', 66

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
      when s.scan(/\]/)
        set_start_fg = false
        tokens.push([:SETS_END, ']' ])
      when s.scan(/([A-Za-z0-9])-([A-Za-z0-9])/)
        tokens.push([ :RANGE, [ s[1], s[2] ] ])
        if s[1] =~ /[a-zA-Z]/ && s[2] =~ /[a-zA-Z]/
          tokens.push([ :ALPHA, s[1] ])
          tokens.push([ :ALPHA, s[2] ])
        elsif s[1] =~ /[0-9]/ && s[2] =~ /[0-9]/
          tokens.push([ :NUMCHAR, s[1].to_i ])
          tokens.push([ :NUMCHAR, s[2].to_i ])
        else
          raise Racc::ParseError, "#{s[0]} is wrong"
        end

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

..end lib/randomaze/string/template_parser.y modeval..id0afb289b33

##### racc 1.4.5 generates ###

racc_reduce_table = [
 0, 0, :racc_error,
 0, 14, :_reduce_none,
 2, 14, :_reduce_2,
 1, 15, :_reduce_none,
 3, 15, :_reduce_4,
 3, 16, :_reduce_5,
 3, 17, :_reduce_6,
 0, 18, :_reduce_none,
 2, 18, :_reduce_8,
 1, 19, :_reduce_none,
 1, 19, :_reduce_10,
 3, 20, :_reduce_11,
 1, 21, :_reduce_none,
 1, 21, :_reduce_none,
 1, 22, :_reduce_none,
 1, 22, :_reduce_none ]

racc_reduce_n = 16

racc_shift_n = 27

racc_action_table = [
    14,    16,     9,    11,    14,    16,     9,    11,     1,     2,
     9,    11,     9,    11,     1,     2,    20,    21,    18,     7,
    24,     5,    26 ]

racc_action_check = [
    13,    13,    13,    13,     5,     5,     5,     5,     4,     4,
    14,    14,    23,    23,     0,     0,     7,    12,     6,     3,
    18,     2,    24 ]

racc_action_pointer = [
    12,   nil,    17,    19,     6,    -5,    12,    16,   nil,   nil,
   nil,   nil,    12,    -9,    -1,   nil,   nil,   nil,    13,   nil,
   nil,   nil,   nil,     1,    14,   nil,   nil ]

racc_action_default = [
    -1,    -3,   -16,   -16,    -1,    -7,   -16,   -16,    -2,   -14,
   -13,   -15,   -16,    -7,   -16,    -9,   -12,   -10,   -16,    -4,
    27,    -5,    -8,   -16,   -16,   -11,    -6 ]

racc_goto_table = [
    23,     3,    12,     6,    19,     8,   nil,   nil,   nil,    25,
    22 ]

racc_goto_check = [
     9,     1,     5,     3,     4,     1,   nil,   nil,   nil,     9,
     5 ]

racc_goto_pointer = [
   nil,     1,   nil,     1,    -2,    -3,   nil,   nil,   nil,   -14 ]

racc_goto_default = [
   nil,   nil,     4,   nil,   nil,   nil,    13,    15,    17,    10 ]

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
 :ALPHA => 11,
 :NUMCHAR => 12 }

racc_use_result_var = true

racc_nt_base = 13

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

module_eval <<'.,.,', 'lib/randomaze/string/template_parser.y', 53
  def _reduce_11( val, _values, result )
              result = val[1]..val[2]
   result
  end
.,.,

 # reduce 12 omitted

 # reduce 13 omitted

 # reduce 14 omitted

 # reduce 15 omitted

 def _reduce_none( val, _values, result )
  result
 end

    end   # class TemplateParser

  end   # module String

end   # module Randomaze