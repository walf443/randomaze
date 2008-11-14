$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))

module Randomaze
  def rand int=0, min=0
    Kernel.rand(int) + min
  end
  module_function :rand

  autoload :String, 'randomaze/string'
  autoload :Time, 'randomaze/time'
end
