require File.join(File.dirname(__FILE__), '..', 'spec_helper')
begin
  require 'spec/fixture'
  require 'set'

  describe Randomaze::String::TemplateParser do
    with_fixtures :template => :expect do
      it "should convert :template to :expect (:msg)" do |template, expect|
        Randomaze::String::TemplateParser.parse(template).should == expect
      end

      it '#from_template should generate random string that match :template with :expect' do |template,expect|
        10.times do
          result = Randomaze::String.from_template(expect)
          result.should =~ /#{template}/
        end
      end

      it '#format should generate random string that match :template' do |template,expect|
        10.times do
          result = Randomaze::String.format(template)
          result.should =~ /#{template}/
        end
      end

      it '#format should generate random string from regex with #source' do |template,expect|
        [/#{template}/, /#{template}/i, /#{template}/m, /#{template  }/x ].each do |regex|
          10.times do
            result = Randomaze::String.format(regex.source)
            result.should =~ /#{template}/
          end
        end
      end
      set_fixtures([
        [ { "[0-9]{1}"          => [[[0..9], 1]]                      }, 'numeric'],
        [ { "[a-z]{1}"          => [[['a'..'z'], 1]]                  }, 'alpha_downcase'],
        [ { "[A-Z]{1}"          => [[['A'..'Z'], 1]]                  }, 'alpha_upcase'],
        [ { "[あ-お]{1}"        => [[['あ'..'お'], 1]]                }, 'non-ascii'],

        [ { "[0-9]"             => [[[0..9], 1]]                      }, 'without count_expr'],

        [ { "[0-9a-zA-Z]{1}"    => [[[0..9, 'a'..'z', 'A'..'Z'], 1]]  }, 'multi set'],
        [ { "[0-9]{10}"         => [[[0..9], 10]]                     }, 'multi count'],
        [ { "[0-9]{1}[a-z]{5}"  => [[[0..9], 1], [['a'..'z'], 5]]     }, 'multi expression'],

        [ { "[0-9]{1,5}"        => [[[0..9], 1..5]]                   }, 'multi count'],
        [ { "[0-9]?"            => [[[0..9], 0..1]]                   }, 'question'],

        [ { "[0-9]{3,}"         => [[[0..9], [3, nil]]]                }, 'more than ..'],
        [ { "[0-9]+"            => [[[0..9], [1, nil]]]                }, 'plus'],
        [ { "[0-9]+?"           => [[[0..9], [1, nil]]]                }, 'plus with question'],
        [ { "[0-9]*"            => [[[0..9], [0, nil]]]                }, 'asterisk'],
        [ { "[0-9]*?"           => [[[0..9], [0, nil]]]                }, 'asterisk with question'],

        [ { '[abc]{1}'          => [[['a', 'b', 'c'], 1]]             }, 'non-range set' ],
        [ { '[\w]{1}'           => [[[ 'a'..'z', 'A'..'Z', 0..9, '_' ] , 1]]}, 'non-range set ( \w )' ],
        [ { '[\d]{1}'           => [[[ 0..9 ] , 1]]                   }, 'non-range set ( \d )' ],

        [ { '[abc0-9]{1}'       => [[['a', 'b', 'c', 0..9 ], 1]]      }, 'mixed set' ],
        [ { '[0-9あいう]{1}'    => [[[0..9, 'あ', 'い', 'う' ], 1]]   }, 'mixed set with non-ascii' ],

        [ { "abc"               => ['abc']                            }, 'with non-random expression'],
        [ { "-_"                => ['-_']                             }, 'with non-random expression'],
        [ { "あいう"            => ['あいう']                         }, 'with non-random expression'],

        [ { "(abc)"             => ['abc']                            }, 'with non-select expression' ],
        [ { "(abc|def)"         => [Set.new(['abc', 'def'])]          }, 'with select expression'],
        [ { "(abc|[a-z])"       => [Set.new(['abc', [['a'..'z'], 1]])] }, 'mix with select expression and set_expr '],

        [ { '\d'                => [[[0..9], 1]]                      }, 'with non-set expression ( \d )'],
        [ { '\d?'               => [[[0..9], 0..1]]                   }, 'with non-set expression ( \d? )'],
        [ { '\w'                => [[['a'..'z', 'A'..'Z', 0..9, '_'], 1]]  }, 'with non-set expression ( \w )'],
        [ { '.'                 => [[['a'..'z', 'A'..'Z', 0..9, '_'], 1]]  }, 'with non-set expression ( . )'],

        [ { 'hoge\?'            => ['hoge', '?']                      }, 'with non-set expression ( escaped ? )'],
        [ { 'hoge\['            => ['hoge', '[']                      }, 'with non-set expression ( escaped [ )'],
        [ { 'hoge\]'            => ['hoge', ']']                      }, 'with non-set expression ( escaped ] )'],
        [ { 'hoge\{'            => ['hoge', '{']                      }, 'with non-set expression ( escaped { )'],
        [ { 'hoge\}'            => ['hoge', '}']                      }, 'with non-set expression ( escaped } )'],
        [ { 'hoge\*'            => ['hoge', '*']                      }, 'with non-set expression ( escaped * )'],
        [ { 'hoge\+'            => ['hoge', '+']                      }, 'with non-set expression ( escaped + )'],
        [ { 'hoge\^'            => ['hoge', '^']                      }, 'with non-set expression ( escaped ^ )'],
        [ { 'hoge\$'            => ['hoge', '$']                      }, 'with non-set expression ( escaped $ )'],
        [ { 'hoge\\\\'          => ['hoge', '\\']                     }, 'with non-set expression ( escaped \ )'],
        [ { 'hoge\.'            => ['hoge', '.']                      }, 'with non-set expression ( escaped . )'],
        [ { 'hoge\|'            => ['hoge', '|']                      }, 'with non-set expression ( escaped | )'],
        [ { 'hoge\('            => ['hoge', '(']                      }, 'with non-set expression ( escaped ( )'],
        [ { 'hoge\)'            => ['hoge', ')']                      }, 'with non-set expression ( escaped ) )'],
        [ { 'hoge\['            => ['hoge', '[']                      }, 'with non-set expression ( escaped [ )'],

        [ { '\d{2}'             => [[[0..9], 2]]                           }, 'with non-set expression ( \d )'],
        [ { '\w{2}'             => [[['a'..'z', 'A'..'Z', 0..9, '_'], 2]]  }, 'with non-set expression ( \w )'],
        [ { '.{2}'              => [[['a'..'z', 'A'..'Z', 0..9, '_'], 2]]  }, 'with non-set expression ( . )'],
        [ { '\d{3}-\d{4}-\d{4}' => [[[0..9], 3], '-', [[0..9], 4], '-', [[0..9], 4]] }, 'with non-set expression mixed'],

        [ { "abc[0-9]{1}"             => ['abc', [[0..9], 1]]                     }, 'mixed with non-random expression in head'],
        [ { "__[0-9]{1}"              => ['__', [[0..9], 1]]                      }, 'mixed with non-random expression in head (symbol)'],
        [ { "あいう[0-9]{1}"          => ['あいう', [[0..9], 1]]                  }, 'mixed with non-random expression in head (non-ascii)'],

        [ { "[0-9]{1}abc"             => [[[0..9], 1], 'abc']                     }, 'mixed with non-random expression in tail'],
        [ { "[0-9]{1}_-"              => [[[0..9], 1], '_-']                      }, 'mixed with non-random expression in tail (symbol)'],
        [ { "[0-9]{1}あいう"          => [[[0..9], 1], 'あいう']                  }, 'mixed with non-random expression in tail (non-ascii)'],

        [ { "[0-9]{1}abc[a-z]{5}"     => [[[0..9], 1], 'abc', [['a'..'z'], 5]]    }, 'mixed with non-random expression in middle'],
        [ { "[0-9]{1}__[a-z]{5}"      => [[[0..9], 1], '__', [['a'..'z'], 5]]     }, 'mixed with non-random expression in middle (symbol)'],
        [ { "[0-9]{1}あいう[a-z]{5}"  => [[[0..9], 1], 'あいう', [['a'..'z'], 5]] }, 'mixed with non-random expression in middle (non-ascii)'],
      ])
    end
  end
rescue LoadError => e
  warn "this test reuired rspec-fixture."
end
