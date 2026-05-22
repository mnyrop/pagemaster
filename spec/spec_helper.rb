# frozen_string_literal: true

require 'simplecov'
SimpleCov.start do
  add_filter 'spec'
end

require File.expand_path('../lib/pagemaster.rb', __dir__)
require 'pagemaster'
require 'setup'

shared_context 'shared', shared_context: :metadata do
  let(:args)    { %w[csv_collection json_collection yaml_collection] }
  let(:config)  { YAML.load_file "#{BUILD}/_config.yml" }
  let(:opts)    { {} }
  let(:site)    { Pagemaster::Site.new args, opts }
  let(:page_paths) do
    ['src/_csv_collection/img_item_1.md',
     'src/_csv_collection/img_item_2.md',
     'src/_csv_collection/dir_imgs_item.md',
     'src/_csv_collection/pdf_imgs_item.md',
     'src/_json_collection/img_item_1.md',
     'src/_json_collection/img_item_2.md',
     'src/_json_collection/dir_imgs_item.md',
     'src/_json_collection/pdf_imgs_item.md',
     'src/_yaml_collection/img_item_1.md',
     'src/_yaml_collection/img_item_2.md',
     'src/_yaml_collection/dir_imgs_item.md',
     'src/_yaml_collection/pdf_imgs_item.md']
  end
end

require 'collection_spec'
require 'site_spec'
