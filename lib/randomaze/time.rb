
require 'time'
module Randomize
  module Time
    def between range
      min, max = nil, nil
      if range.first.kind_of?(::Time) && range.first.kind_of?(::Time)
        min = range.first.to_f
        max = range.last.to_f
      else
        min = ::Time.parse(range.first).to_f
        max = ::Time.parse(range.last).to_f
      end

      epoch = Randomize.rand( max - min ) + min
      ::Time.at(epoch)
    end
    module_function :between

  end
end
