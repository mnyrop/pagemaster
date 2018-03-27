include FileUtils
require 'jekyll'
require 'yaml'

include FileUtils

module Fake
  def self.site
    site_dir = 'faker_site'
    mkdir_p(site_dir)
    data_dir = site_dir + '/_data'
    mkdir_p(data_dir)
    cd(site_dir)

    config_file = {
      'title'       => 'faker',
      'url'         => '',
      'baseurl'     => ''
    }
    config_opts = {
      'source'      => '.',
      'destination' => '_site',
      'config'      => '_config.yml'
    }
    File.open('_config.yml', 'w') { |f| f.puts(config_file.to_yaml) }
    Jekyll::Site.new(Jekyll.configuration(config_opts)).process
  end
end
