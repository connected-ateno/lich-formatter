require('active_support')
require('active_support/core_ext/numeric')

MILLISECONDS_PER_SECOND = 1000

# A class for the purpose of simple tests that can pass, fail and warn
# under various circumstances as well as provide a specific execution
# duration for the purpose of delaying output.
class MockUnit
  def self.method(success_type, ms_duration = 0)
    sleep((ms_duration / MILLISECONDS_PER_SECOND).seconds)
    case success_type
    when 'succeed'
      return true
    when 'fail'
      return false
    when 'error'
      raise '`MockUnit.method` is simulating an error'
    end
  end
end
