# @!method have_size(obj)
#   This matchers checks if <obj> has size. An object can be a file, an io or a string
#
#   @param [String] obj
#     The name of the obj which should be checked
#
#   @return [TrueClass, FalseClass] The result
#
#     false:
#     * if obj does not have size
#     true:
#     * if obj has size
#
#   @example Use matcher
#
#     RSpec.describe do
#       it { expect(file1).to have_size(256) }
#     end
RSpec::Matchers.define :have_size do |expected|
  match do |actual|
    @old_actual = actual
    @actual     = object_size(actual)

    size?(@old_actual, expected)
  end

  failure_message do |actual|
    format(%(expected that object "%s" has size "%s", but it has "%s".), @old_actual, expected, @actual)
  end

  failure_message_when_negated do |actual|
    format(%(expected that object "%s" does not have size "%s".), @old_actual, expected)
  end
end
