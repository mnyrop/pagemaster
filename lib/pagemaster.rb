include FileUtils
require 'csv'
require 'yaml'
require 'json'

# Jekyll comand to generate markdown collection pages from CSV/YML/JSON records
class Pagemaster < Jekyll::Command
  class << self
    def init_with_program(prog)
      prog.command(:pagemaster) do |command|
        command.syntax 'pagemaster [options]'
        command.description 'Generate md pages from collection data.'
        command.action do |args|
          execute(args)
        end
      end
    end

    def execute(args)
      config = YAML.load_file('_config.yml')
      abort 'Cannot find collections in config' unless config.key?('collections')
      perma = config['permalink'] == 'pretty' ? '/' : '.html'
      args.each do |name|
        abort "Cannot find #{name} in collection config" unless config['collections'].key? name
        meta = {
          'id_key'  => config['collections'][name].fetch('id_key'),
          'layout'  => config['collections'][name].fetch('layout'),
          'source'  => config['collections'][name].fetch('source')
        }
        data = ingest(meta)
        generate_pages(name, meta, data, perma)
      end
    end

    def ingest(meta)
      src = '_data/' + meta['source']
      puts "Processing #{src}...."
      case File.extname(src)
      when '.csv' then data = CSV.read(src, headers: true, encoding: 'utf-8').map(&:to_hash)
      when '.json' then data = JSON.parse(File.read(src).encode('UTF-8'))
      when '.yml' then data = YAML.load_file(src)
      else abort 'Collection source must have a valid extension (.csv, .yml, or .json)'
      end
      detect_duplicates(meta, data)
      data
    rescue StandardError
      abort "Cannot load #{src}. check for typos and rebuild."
    end

    def detect_duplicates(meta, data)
      ids = []
      data.each { |d| ids << d[meta['id_key']] }
      duplicates = ids.detect { |i| ids.count(i) > 1 } || []
      abort "Your collection duplicate ids: \n#{duplicates}" unless duplicates.empty?
    end

    def generate_pages(name, meta, data, perma)
      completed = 0
      skipped = 0
      dir = '_' + name
      mkdir_p(dir)
      data.each do |item|
        pagename = slug(item.fetch(meta['id_key']))
        pagepath = dir + '/' + pagename + '.md'
        item['permalink'] = '/' + name + '/' + pagename + perma
        item['layout'] = meta['layout']
        if File.exist?(pagepath)
          puts "#{pagename}.md already exits. Skipping."
          skipped += 1
        else
          File.open(pagepath, 'w') { |file| file.write(item.to_yaml.to_s + '---') }
          completed += 1
        end
      end
    rescue StandardError
      abort 'Pagemaster exited for some reason, most likely a missing or invalid id_key.'
    end

    def slug(str)
      str.downcase.tr(' ', '_').gsub(/[^:\w-]/, '')
    end
  end
end
