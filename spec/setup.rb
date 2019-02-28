require 'fileutils'

#constants
ROOT    = `pwd`.strip.freeze
SAMPLE  = "#{ROOT}/spec/sample_site".freeze
BUILD   = "#{ROOT}/test_build".freeze

# helper methods
def quiet_stdout
  if QUIET
    begin
      orig_stderr = $stderr.clone
      orig_stdout = $stdout.clone
      $stderr.reopen File.new('/dev/null', 'w')
      $stdout.reopen File.new('/dev/null', 'w')
      retval = yield
    rescue StandardError => e
      $stdout.reopen orig_stdout
      $stderr.reopen orig_stderr
      raise e
    ensure
      $stdout.reopen orig_stdout
      $stderr.reopen orig_stderr
    end
    retval
  else
    yield
  end
end

module Pagemaster::Test
  def self.reset
    Dir.chdir(ROOT)
    FileUtils.rm_r(BUILD) if File.directory?(BUILD)
    FileUtils.copy_entry(SAMPLE, BUILD)
    Dir.chdir(BUILD)
  end
end
