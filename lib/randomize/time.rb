module Randomize
  module Time
    def between range
      min = range.first.to_f
      max = range.last.to_f
      epoch = Randomize.rand( max - min ) + min
      ::Time.at(epoch)
    end
    module_function :between

  end
end
