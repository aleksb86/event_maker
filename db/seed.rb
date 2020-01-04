# frozen_string_literal: true

require 'fileutils'
require_relative '../support/dependencies'
require_relative '../support/initialization'

Initialization.db_connection(Config.settings.db.database)

# rubocop:disable Metrics/LineLength
LOGS = [
  'Dec 17 12:00:36 elli-hub systemd[1]: Started Run anacron jobs. Dec 17 12:00:36 elli-hub systemd[1]: Started Run anacron jobs.',
  'Dec 17 12:00:36 elli-hub anacron[30729]: Anacron 2.3 started on 2019-12-17',
  'Dec 17 12:00:36 elli-hub anacron[30729]: Normal exit (0 jobs run)',
  'Dec 17 12:01:03 elli-hub wpa_supplicant[933]: wlp4s0: WPA: Group rekeying completed with 40:4a:03:ad:61:fe [GTK=CCMP]',
  'Dec 17 12:01:44 elli-hub NetworkManager[932]: <info>  [1576573304.3355] manager: NetworkManager state is now CONNECTED_GLOBAL',
  'Dec 17 12:01:44 elli-hub systemd[1]: Starting Network Manager Script Dispatcher Service...',
  'Dec 17 12:01:44 elli-hub dbus-daemon[835]: [system] Successfully activated service "org.freedesktop.nm_dispatcher"',
  'Dec 17 12:01:44 elli-hub nm-dispatcher: req:1 "connectivity-change": new request (1 scripts)',
  'Dec 17 12:01:44 elli-hub nm-dispatcher: req:1 "connectivity-change": start running ordered scripts...',
  'Dec 17 12:17:01 elli-hub CRON[31958]: (root) CMD (   cd / && run-parts --report /etc/cron.hourly)',
  'Dec 17 12:31:03 elli-hub wpa_supplicant[933]: wlp4s0: WPA: Group rekeying completed with 40:4a:03:ad:61:fe [GTK=CCMP]',
  'Dec 17 13:04:28 elli-hub systemd[1]: Started Run anacron jobs.',
  'Dec 17 13:04:28 elli-hub anacron[718]: Anacron 2.3 started on 2019-12-17',
  'Dec 17 13:17:02 elli-hub CRON[1221]: (root) CMD (   cd / && run-parts --report /etc/cron.hourly)',
  'Dec 17 14:01:00 elli-hub systemd[1]: Started Run anacron jobs.',
  'Dec 17 14:01:00 elli-hub anacron[2487]: Anacron 2.3 started on 2019-12-17',
  'Dec 17 14:01:00 elli-hub anacron[2487]: Normal exit (0 jobs run)',
  'Dec 17 14:01:03 elli-hub wpa_supplicant[933]: wlp4s0: WPA: Group rekeying completed with 40:4a:03:ad:61:fe [GTK=CCMP]',
  'Dec 17 14:17:01 elli-hub CRON[3565]: (root) CMD (   cd / && run-parts --report /etc/cron.hourly)',
  'Dec 17 14:31:03 elli-hub wpa_supplicant[933]: wlp4s0: WPA: Group rekeying completed with 40:4a:03:ad:61:fe [GTK=CCMP]'
].freeze
# rubocop:enable Metrics/LineLength

LOGS_DIR = Config.settings.app.source_dirs.logs

EVENT_RULES = {
  systemd: 'systemd\[\d+\]:',
  wpa: 'wpa_supplicant\[\d+\]:'
}.freeze

ATTRIBUTE_RULES = {
  systemd: { message: ':([a-zA-Z\s]+)' },
  wpa: { interface: 'wlp\ds\d', wpa: 'WPA:\s+([a-zA-Z\s\d:]+)' }
}.freeze

# Create sample log files:

# Delete old log files (if exists)
FileUtils.rm_rf("#{LOGS_DIR}/.")

LOGS.each_slice(3) do |lines|
  time = (Time.now + rand(20) * 3600).strftime('%Y-%m-%d %H:%M:%S')
  File.open("#{LOGS_DIR}/#{time}", 'w') { |file| lines.each { |line| file.puts(line) } }
end

# Add event rules:

EVENT_RULES.each do |key, val|
  EventRule.find_or_create(name: key.to_s, pattern: val.to_s)
end

# Add attribute rules:

ATTRIBUTE_RULES.each do |key, val|
  event_rule = EventRule[name: key.to_s]
  val.each do |name, pattern|
    AttributeRule.find_or_create(
      event_rule_id: event_rule.id,
      name: name.to_s,
      pattern: pattern.to_s
    )
  end
end
