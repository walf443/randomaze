require File.join(File.dirname(__FILE__), 'spec_helper')

describe Randomize::Time do
  describe '#between' do
    it 'should generate time between time range' do
      from = Time.utc(2008, 11, 14)
      to   = Time.utc(2008, 12, 14)
      10.times do
        date = Randomize::Time.between from..to
        p date.to_s
        ( from..to ).should include(date)
      end
    end
  end
end
