require './lich_report'

SPACE = ' '.freeze
UNDERSCORE = '_'.freeze
COLON = ':'.freeze
DASH = '-'.freeze

# IO Constants
WRITE = 'w'.freeze

# A Custom RSpec Formatter that should be able to provide dynamic output of
# results for continuous inspection by a web service.
class LichFormatter
  # This registers the notifications this formatter supports, and tells
  # us that this was written against the RSpec 3.x formatter API.
  RSpec::Core::Formatters.register self,
                                   :start,
                                   :example_started,
                                   :example_passed,
                                   :example_failed

  def initialize(_arg)
    Dir.mkdir('reports') unless File.directory?('reports')
    report_path = "reports/#{Time.now}.json"
                  .gsub(SPACE, UNDERSCORE)
                  .gsub(COLON, DASH)
    @lich_report = LichReport.new(report_path)
    ObjectSpace.define_finalizer(self, self.class.finalize(@lich_report))
  end

  def start(start_notification)
    @lich_report.start(start_notification)
  end

  def example_started(example_notification)
    @lich_report.example_started(example_notification)
  end

  def example_failed(failed_example_notification)
    @lich_report.example_failed(failed_example_notification)
  end

  def example_passed(example_notification)
    @lich_report.example_passed(example_notification)
  end

  def self.finalize(lich_report)
    proc {
      lich_report.close
    }
  end
end
