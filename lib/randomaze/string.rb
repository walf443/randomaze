module Randomaze
  module String
    autoload :TemplateParser, 'randomaze/string/template_parser'

    module Core
      def default_max_length
        @default_max_length ||= 19
      end

      def random_length
        Randomaze.rand(default_max_length, 1)
      end

      def default_max_length= int
        @default_max_length = int
      end

      # Return +length+ length random string that contain array chars.
      # If +check+ is true, return nil
      def from_array array, length=random_length, &check
        check_result check do
          result = []
          length.times do
            result << array[Randomaze.rand(array.size)]
          end
          result.join
        end
      end

      #
      # Randomaze::String.from_template([['a'..'z',3], '__', [0..9, 2 ]] ) #=> 'abc__01
      #
      def from_template templates, options={}, &check
        check_result check do
          results = []
          templates.each do |item|
            results << case item
            when Array
              set = item.first
              set = set.map {|i| i.to_a }.flatten
              lenght = item.last

              from_array(set, lenght)
            else
              item
            end
          end
          results.join
        end
      end

      def format template, &check
        templates = Randomaze::String::TemplateParser.parse(template)
        from_template(templates, &check)
      end

      # Run +block+ and apply the result to +check_proc+.
      # If +check_proc+'s result is true, return nil. And else return +block+'s result.
      # It's useful for you to define your custom random string generator.
      #
      # you can skip generated value in block_lists like followings:
      #
      #   random_string = nil
      #   loop do
      #     random_string = YourMod.your_method(length) {|result| black_lists.include?(result) }
      #     break if random_string
      #   end
      #
      #   # do some thing with random_string.
      #
      def check_result check_proc=nil, &block
        result = block.call
        if check_proc && check_proc.call(result)
          nil
        else
          result
        end
      end

      def self.included klass
        klass.extend self
      end
    end

    module Utils
      def rand_base
        Randomaze::String
      end
    end

    module Basic
      ALPHA_UPCASE   = ('A'..'Z').to_a
      ALPHA_DOWNCASE = ('a'..'z').to_a
      ALPHA = ALPHA_UPCASE + ALPHA_DOWNCASE
      NUMBER = ('0'..'9').to_a
      HEX = NUMBER + ('a' .. 'f').to_a
      ALNUM = ALPHA + NUMBER

      def self.included klass
        klass.extend self
      end

      # For exmaple, "abcAbc".
      # If you'd like to get only downcase word, please use it with followings:
      #   Randomaze::String.alpha(6, ALPHA_DOWNCASE) #=> 'abcabc'
      #
      def alpha length=Randomaze::String.random_length, type=ALPHA, &check
        Randomaze::String.from_array(type, length, &check)
      end

      # For exmaple, "01234".
      def number length=Randomaze::String.random_length, &check
        Randomaze::String.from_array(NUMBER, length, &check)
      end

      # For exmaple, "0139af".
      def hex length=Randomaze::String.random_length, &check
        Randomaze::String.from_array(HEX, length, &check)
      end

      # For exmaple, "019abc".
      def alnum length=Randomaze::String.random_length, array=ALPHA, &check
        Randomaze::String.from_array(array + NUMBER, length, &check )
      end
    end

    module Inflection
      module Methods
        include Utils

        # For exmaple, "CamelCase", "Camel20Case".
        # If you'd like to get start from downcase char, please use it with followings:
        #   Randomaze::String.calme_case(6, ALPHA_DOWNCASE) #=> 'camelCase'
        #
        def camel_case length=Randomaze::String.random_length, start=rand_base::ALPHA_UPCASE, &check
          rand_base.check_result check do
            rand_base.alpha(1, start) + rand_base.alnum(length-1, rand_base::ALPHA)
          end
        end

        # For exmaple, "CONST_NAME". result is no starting from '_'.
        def const_name length=rand_base.random_length, &check
          weight = 3
          rand_base.check_result check do
            rand_base.alpha(1, rand_base::ALPHA_UPCASE) + rand_base.alpha(length-1, rand_base::ALPHA_UPCASE + ['_'] * weight)
          end
        end

        # For exmaple, "snake_case", "snake_20case". result is no starting from '_'.
        def snake_case length=rand_base.random_length, &check
          rand_base.check_result check do
            if length > 2
              weight = 3
              [
                rand_base.alpha(1, rand_base::ALPHA_DOWNCASE),
                rand_base.from_array(rand_base::ALPHA_DOWNCASE + rand_base::NUMBER + ['_'] * weight, length-2),
                rand_base.alpha(1, rand_base::ALPHA_DOWNCASE),
              ].join
            else
              rand_base.alpha(length, rand_base::ALPHA_DOWNCASE)
            end
          end
        end
      end

      include Methods
    end

    include Core
    include Basic
  end
end
