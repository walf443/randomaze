require File.join(File.dirname(__FILE__), '..', 'spec_helper')
begin
  require 'spec/fixture'

  describe Randomize::String::Basic do
    with_fixtures :meth => :pattern do
      it "#:meth should match :pattern" do |meth,pattern|
        self.class.class_eval do
          include Randomize::String::Basic
        end
        10.times do 
          __send__(meth) {|i| i.should =~ pattern }
        end
      end

      it '#:meth should be able to specify length' do |meth,|
        self.class.class_eval do
          include Randomize::String::Basic
        end
        10.times do
          __send__(meth, 10) {|i| i.size.should == 10 }
        end
      end

      desc_filters(:meth => :to_s)

      set_fixtures([
        [ :alpha  => /\A[a-zA-Z]+\z/],
        [ :number => /\A[0-9]+\z/],
        [ :hex    => /\A[0-9a-z]+\z/],
        [ :alnum  => /\A[0-9a-zA-Z]+\z/],
      ])
    end
  end
rescue LoadError => e
  warn "this test reuired rspec-fixture."
end
