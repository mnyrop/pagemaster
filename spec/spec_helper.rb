require 'simplecov'
SimpleCov.start

require 'fake/helpers'
require 'fake/site'
require 'fake/data'

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'pagemaster'

QUIET = !ENV['DEBUG']

describe 'pagemaster' do
  Fake.site
  collection_data = Fake.data
  args = collection_data.map { |c| c[0] }
  add_collections_to_config(args, collection_data)

  let(:dirs) { args.map { |a| "_#{a}" } }

  context 'with --no-permalink' do
    it 'throws no errors' do
      expect { quiet_stdout { Pagemaster.execute(args, no_perma: true) } }.not_to raise_error
    end
    it 'makes the correct dirs' do
      dirs.each { |dir| expect(exist(dir)) }
    end
    it 'generates md pages' do
      dirs.each { |dir| expect(Dir.glob("#{dir}/*.md")) }
    end
    it 'skips writing permalinks' do
      Dir.glob("#{dirs.first}/*.md").each do |p|
        page = YAML.load_file(p)
        expect(!page.key?('permalink'))
      end
    end
  end

  context 'with --force' do
    it 'throws no errors' do
      expect { quiet_stdout { Pagemaster.execute(args, force: true) } }.not_to raise_error
    end
    it 'deletes the dir' do
      expect { Pagemaster.execute(args, force: true) }.to output(/.*Overwriting.*/).to_stdout
      expect { Pagemaster.execute(args, force: true) }.not_to output(/.*Skipping.*/).to_stdout
    end
    it 'regenerates md pages' do
      dirs.each { |dir| expect(Dir.glob("#{dir}/*.md")) }
    end
  end

  context 'with default options' do
    it 'throws no errors' do
      expect { quiet_stdout { Pagemaster.execute(args) } }.not_to raise_error
    end
    it 'skips existing pages' do
      expect { Pagemaster.execute([args.first]) }.to output(/.*Skipping.*/).to_stdout
    end
    it 'writes permalinks' do
      Dir.glob("#{dirs.first}/*.md").each do |p|
        page = YAML.load_file(p)
        expect(page.key?('permalink'))
      end
    end
  end
end
