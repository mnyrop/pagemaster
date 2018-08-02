require 'simplecov'
SimpleCov.start

require 'fake/helpers'
require 'fake/site'
require 'fake/data'

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'pagemaster'

include FileUtils

describe 'pagemaster' do
  Fake.site
  collection_data = Fake.data
  args = collection_data.map { |c| c[0] }
  add_collections_to_config(args, collection_data)
  dirs = args.map { |a| '_' + a }

  context 'with --no-permalink' do
    it 'throws no errors' do
      Pagemaster.execute(args, no_perma: true)
    end
    it 'makes the correct dirs' do
      dirs.each { |dir| expect(exist(dir)) }
    end
    it 'generates md pages' do
      dirs.each { |dir| expect(Dir.glob(dir + '/*.md')) }
    end
    it 'skips writing permalinks' do
      Dir.glob(dirs.first + '/*.md').each do |p|
        page = YAML.load_file(p)
        expect(!page.key?('permalink'))
      end
    end
  end

  context 'with --force' do
    it 'throws no errors' do
      Pagemaster.execute(args, force: true)
    end
    it 'deletes the dir' do
      # fill in
    end
    it 'regenerates md pages' do
      # fill in
    end
  end

  context 'with default options' do
    it 'throws no errors' do
      rm_rf(dirs)
      Pagemaster.execute(args)
    end
    it 'skips existing pages' do
      # fill in
    end
    it 'writes permalinks' do
      Dir.glob(dirs.first + '/*.md').each do |p|
        page = YAML.load_file(p)
        expect(page.key?('permalink'))
      end
    end
  end
end
