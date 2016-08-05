#!/usr/bin/env ruby

require 'sensu-plugin/check/cli'

SVSTAT = '/usr/bin/svstat'
SVSTAT_UP_REGEX = /.*: up \(pid (\d+)\) (\d+) seconds/
SVSTAT_DOWN_REGEX = /.*: down (\d+) seconds, normally up/

class CheckDaemontools < Sensu::Plugin::Check::CLI
  option :service_path,
         short: '-s',
         long: '--service-path PATH_TO_SERVICE',
         description: 'Path to service to check'
  option :warn_below_seconds,
         short: '-w',
         long: '--warn-below-seconds SECONDS',
         description: 'Issue a warn when the service has been up for less than this number of seconds',
         default: 120
  option :crit_below_seconds,
         short: '-s',
         long: '--crit-below-seconds SECONDS',
         description: 'Issue a crit when the service has been up for less than this number of seconds',
         default: 30
  option :svstat,
         short: '-x',
         long: '--svstat SECONDS',
         description: 'Path to svstat binary',
         default: SVSTAT


  def run
    if config[:service_path]
      service_path = config[:service_path]
    else
      unknown 'No service specified'
    end

    check_service(service_path, config[:svstat], config[:warn_below_seconds].to_i, config[:crit_below_seconds].to_i)
  end

  def check_service(service_path, svstat, warn_below_seconds, crit_below_seconds)
    service_status_text = service_status(service_path, svstat)

    if is_service_up?(service_status_text)
        pid, secs = parse_running_service(service_status_text)
        if secs < crit_below_seconds
            critical "#{service_path}: service has been up for less than crit threshold #{crit_below_seconds} secs (up #{secs}, pid #{pid})"
        elsif secs < warn_below_seconds
            warning "#{service_path}: service has been up for less than warn threshold #{warn_below_seconds} secs (up #{secs}, pid #{pid})"
        else
            ok "#{service_path}: ok (up #{secs} secs, pid #{pid})"
        end
    else
        secs = parse_down_service(service_status_text)
        critical "#{service_path}: down (#{secs} seconds)"
    end
  end

  def service_status(service_path, svstat)
    status = `#{svstat} #{service_path}`
    return status
  end

  def is_service_up?(service_status_text)
    match = service_status_text.match(SVSTAT_UP_REGEX)
    return match != nil
  end

  def parse_running_service(service_status_text)
    matchdata = service_status_text.match(SVSTAT_UP_REGEX)
    pid = matchdata[1].to_i  # pid 12345780
    secs = matchdata[2].to_i  # 1234 seconds
    return pid, secs
  end

  def parse_down_service(service_status_text)
    matchdata = service_status_text.match(SVSTAT_DOWN_REGEX)
    secs = matchdata[1].to_i  # 1234 seconds
    return secs
  end
end
