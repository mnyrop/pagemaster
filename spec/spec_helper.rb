# frozen_string_literal: true

require 'simplecov'
SimpleCov.start do
  add_filter 'spec'
end

require 'pagemaster'
require 'setup'

shared_context 'shared', shared_context: :metadata do
  let(:args)    { %w[csv_collection json_collection yaml_collection] }
  let(:config)  { YAML.load_file "#{BUILD}/_config.yml" }
  let(:opts)    { {} }
  let(:site)    { Pagemaster::Site.new args, opts }
end

require_relative 'pagemaster/site'
require_relative 'pagemaster/collection'
