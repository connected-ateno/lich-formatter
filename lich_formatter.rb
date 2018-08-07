SPACE = ' '.freeze
UNDERSCORE = '_'.freeze
COLON = ':'.freeze
DASH = '-'.freeze

# A Custom RSpec Formatter that should be able to provide dynamic output of
# results for continuous inspection by a web service.
class LichFormatter
  # This registers the notifications this formatter supports, and tells
  # us that this was written against the RSpec 3.x formatter API.
  RSpec::Core::Formatters.register self, :example_started

  def initialize(_arg)
    Dir.mkdir('reports') unless File.directory?('reports')
    @report_path = "#{Time.now}.rpt".gsub(SPACE, UNDERSCORE).gsub(COLON, DASH)
    ObjectSpace.define_finalizer(self, self.class.finalize(@report_path))
  end

  def example_started(notification)
    notification.inspect
  end

  def self.finalize(report_path)
    proc { puts "Closing #{report_path}" }
  end
end
