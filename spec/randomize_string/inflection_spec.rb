require File.join(File.dirname(__FILE__), '..', 'spec_helper')
begin
  require 'spec/fixture'

  describe Randomize::String::Inflection do
    with_fixtures :meth => :pattern do
      it "#:meth should match :pattern" do |meth,pattern|
        self.class.class_eval do
          include Randomize::String::Inflection
        end
        100.times do 
          __send__(meth) {|i| i.should =~ pattern }
        end
      end

      it '#:meth should be able to specify length' do |meth,|
        self.class.class_eval do
          include Randomize::String::Inflection
        end
        10.times do
          __send__(meth, 10) {|i| i.size.should == 10 }
        end
      end

      desc_filters(:meth => :to_s)

      set_fixtures([
        [ :camel_case    => /\A[A-Z][a-zA-Z0-9]*$\z/],
        [ :snake_case    => /\A[a-z][a-z0-9_]*[a-z]?$\z/],
        [ :const_name    => /\A[A-Z][A-Z_]*\z/],
      ])
    end
  end
rescue LoadError => e
  warn "this test reuired rspec-fixture."
end
