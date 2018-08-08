require 'json'
require 'pp'

SHOULD_PRINT = true
PASS_CODE = '.'.freeze
FAIL_CODE = 'F'.freeze

# LichReport is a wrapping class to simplify the writing of results
# and the closing of a report
class LichReport
  def initialize(report_path)
    @report_path = report_path
    @report_hash = { suite_status: :in_progress }
  end

  def start(start_notification)
    write "Examples to be executed: #{start_notification.count}\n\n"
  end

  def arrange_metadata(example_or_metadata)
    if example_or_metadata.is_a? RSpec::Core::Example
      [example_or_metadata.metadata, example_or_metadata.example_group.metadata]
    else
      [example_or_metadata, example_or_metadata[:parent_example_group]]
    end
  end

  def arrange_report_hash(example_or_metadata)
    current_metadata, next_metadata = arrange_metadata(example_or_metadata)

    arrange_report_hash(next_metadata) if next_metadata

    scoped_id_array = current_metadata[:scoped_id].split(':')

    scoped_id_array.reduce(@report_hash) do |acc, id|
      acc[id] = { description: current_metadata[:description] } unless acc[id]
      acc[id]
    end
  end

  def process_example_notification(example_notification)
    current_hash = arrange_report_hash(example_notification.example)
    # execution_result = example_notification.example.execution_result
    # return unless execution_result
    # current_hash[:status] = execution_result.status
  end

  def process_failed_example_notification(failed_example_notification)
    # current_hash = arrange_report_hash(failed_example_notification.example)
    # execution_result = failed_example_notification.example.execution_result
    # return unless execution_result
    # current_hash[:status] = execution_result.status
    # current_hash[:exception] = failed_example_notification.exception.to_s
    # current_hash[:backtrace] = failed_example_notification.formatted_backtrace
  end

  def example_started(example_notification)
    process_example_notification(example_notification)
  end

  def example_passed(example_notification)
    write PASS_CODE
    process_example_notification(example_notification)
  end

  def example_failed(failed_example_notification)
    write FAIL_CODE
    process_failed_example_notification(failed_example_notification)
  end

  def write(output_message)
    print output_message
    report_stream = File.open(@report_path, WRITE)
    report_stream.puts JSON.pretty_generate(@report_hash)
    report_stream.close
  end

  def close
    @report_hash[:suite_status] = :finished
    write "\n\nFinishing the report: #{@report_path}\n"
  end
end
