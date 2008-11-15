require File.join(File.dirname(__FILE__), '..', 'spec_helper')
begin
  require 'spec/fixture'

  describe Randomaze::String::TemplateParser do
    with_fixtures :template => :expect do
      it "should convert :template to :expect (:msg)" do |template, expect|
        Randomaze::String::TemplateParser.parse(template).should == expect
      end

      it '#parse should generate random string that match :template' do |template,expect|
        10.times do
          result = Randomaze::String.parse(template)
          result.should =~ /#{template}/
        end
      end

      it '#from_template should generate random string that match :template with :expect' do |template,expect|
        10.times do
          result = Randomaze::String.from_template(expect)
          result.should =~ /#{template}/
        end
      end

      set_fixtures([
        [ { "[0-9]{1}"          => [[[0..9], 1]]                      }, 'numeric'],
        [ { "[a-z]{1}"          => [[['a'..'z'], 1]]                  }, 'alpha_downcase'],
        [ { "[A-Z]{1}"          => [[['A'..'Z'], 1]]                  }, 'alpha_upcase'],
        [ { "[0-9a-zA-Z]{1}"    => [[[0..9, 'a'..'z', 'A'..'Z'], 1]]  }, 'multi set'],
        [ { "[0-9]{10}"         => [[[0..9], 10]]                     }, 'multi count'],
        [ { "[0-9]{1}[a-z]{5}"  => [[[0..9], 1], [['a'..'z'], 5]]   },   'multi expression'],
      ])
    end
  end
rescue LoadError => e
  warn "this test reuired rspec-fixture."
end
