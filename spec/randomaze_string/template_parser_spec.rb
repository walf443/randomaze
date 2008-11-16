require File.join(File.dirname(__FILE__), '..', 'spec_helper')
begin
  require 'spec/fixture'

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

      set_fixtures([
        [ { "[0-9]{1}"          => [[[0..9], 1]]                      }, 'numeric'],
        [ { "[a-z]{1}"          => [[['a'..'z'], 1]]                  }, 'alpha_downcase'],
        [ { "[A-Z]{1}"          => [[['A'..'Z'], 1]]                  }, 'alpha_upcase'],
        [ { "[0-9a-zA-Z]{1}"    => [[[0..9, 'a'..'z', 'A'..'Z'], 1]]  }, 'multi set'],
        [ { "[0-9]{10}"         => [[[0..9], 10]]                     }, 'multi count'],
        [ { "[0-9]{1}[a-z]{5}"  => [[[0..9], 1], [['a'..'z'], 5]]     }, 'multi expression'],
        [ { '[abc]{1}'          => [[['a', 'b', 'c'], 1]]             }, 'non-range set' ],
        [ { '[\w]{1}'           => [[[ 'a'..'z', 'A'..'Z', 0..9, '_' ] , 1]]}, 'non-range set ( \w )' ],
        [ { '[\d]{1}'           => [[[ 0..9 ] , 1]]                   }, 'non-range set ( \d )' ],
        [ { '[abc0-9]{1}'       => [[['a', 'b', 'c', 0..9 ], 1]]      }, 'mixed set' ],

        [ { '[0-9あいう]{1}'    => [[[0..9, 'あ', 'い', 'う' ], 1]]   }, 'mixed set with non-ascii' ],
        [ { "abc"               => ['abc']                            }, 'with non-random express'],
        [ { "-_"                => ['-_']                             }, 'with non-random express'],
        [ { "あいう"            => ['あいう']                         }, 'with non-random express'],
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
