module Aruba
  module Utils

    # Make a string a regular expression
    def regexp(string_or_regexp)
      return string_or_regexp if Regexp === string_or_regexp

      Regexp.compile(Regexp.escape(string_or_regexp))
    end

    # Require files based on pattern
    def require_files_matching_pattern(pattern)
      Dir.glob(pattern).each { |rb| require_relative rb }
    end

    module_function :regexp, :require_files_matching_pattern
  end
end
