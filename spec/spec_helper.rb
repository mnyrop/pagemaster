require 'fake/helpers'
require 'fake/site'
require 'fake/data'

include FileUtils

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'pagemaster'


describe 'pagemaster' do
  Fake.site
  collection_data = Fake.data
  args = collection_data.map { |c| c[0] }
  add_collections_to_config(args, collection_data)
  dirs = args.map { |a| '_' + a }

  context 'with --no-permalink' do
    options = {'no-perma': true }

    it 'throws no errors' do
      Pagemaster.execute(args, options)
    end

    it 'makes the correct dirs' do
      dirs.each { |dir| expect(exist(dir)) }
    end

    it 'generates md pages' do
      dirs.each { |dir| expect(Dir.glob(dir + '/*.md')) }
    end

    it 'skips writing permalinks' do
      sample_pages = Dir.glob(dirs.first + '/*.md')
      sample_pages.each do |p|
        page = YAML.load_file(p)
        expect(!page.key?('permalink'))
      end
    end
  end

  context 'with default options' do
    options = {}

    it 'throws no errors' do
      rm_rf(dirs)
      Pagemaster.execute(args, options)
    end

    it 'makes the correct dirs' do
      dirs.each { |dir| expect(exist(dir)) }
    end

    it 'generates md pages' do
      dirs.each { |dir| expect(Dir.glob(dir + '/*.md')) }
    end

    it 'writes permalinks' do
      sample_pages = Dir.glob(dirs.first + '/*.md')
      sample_pages.each do |p|
        page = YAML.load_file(p)
        expect(page.key?('permalink'))
      end
    end
  end
end
