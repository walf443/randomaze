require File.join(File.dirname(__FILE__), 'spec_helper')
require 'time'

describe Randomaze::Time do
  describe '#between' do
    it 'should generate time between time range' do
      from = Time.utc(2008, 11, 14)
      to   = Time.utc(2008, 12, 14)
      10.times do
        date = Randomaze::Time.between from..to
        ( from..to ).should include(date)
      end
    end

    it 'should generate time between string time range' do
      range = '2008-11-14'..'2008-12-14'
      from = Time.parse(range.first)
      to   = Time.parse(range.last)
      10.times do
        date = Randomaze::Time.between range
        ( from..to ).should include(date)
      end
    end
  end
end
