require 'csv'
require 'yaml'
require 'json'

include FileUtils

# Jekyll comand to generate markdown collection pages from CSV/YML/JSON records
class Pagemaster < Jekyll::Command
  class << self
    def init_with_program(prog)
      prog.command(:pagemaster) do |c|
        c.syntax 'pagemaster [options] [args]'
        c.description 'Generate md pages from collection data.'
        c.option :no_perma, '--no-permalink', 'Skips adding hard-coded permalink.'
        c.option :force, '--force', 'Erases pre-existing collection before regenerating.'
        c.action { |args, options| execute(args, options) }
      end
    end

    def execute(args, opts = {})
      config = YAML.load_file('_config.yml')
      abort 'Cannot find collections in config' unless config.key?('collections')
      args.each do |name|
        abort "Cannot find #{name} in collection config" unless config['collections'].key? name
        meta = {
          id_key: config['collections'][name].fetch('id_key'),
          layout: config['collections'][name].fetch('layout'),
          source: config['collections'][name].fetch('source'),
          ext:    config.fetch('permalink', '') == 'pretty' ? '/' : '.html'
        }
        data = ingest(meta)
        generate_pages(name, meta, data, opts)
      end
    end

    def ingest(meta)
      src = "_data/#{meta[:source]}"
      puts "Processing #{src}...."
      data = case File.extname(src)
             when '.csv'
               CSV.read(src, headers: true).map(&:to_hash)
             when '.json'
               JSON.parse(File.read(src).encode('UTF-8'))
             when '.yml'
               YAML.load_file(src)
             else
               raise 'Collection source must have a valid extension (.csv, .yml, or .json)'
             end
      detect_duplicates(meta, data)
      data
    rescue StandardError
      raise "Cannot load #{src}. check for typos and rebuild."
    end

    def detect_duplicates(meta, data)
      ids = data.map { |d| d[meta[:data]] }
      duplicates = ids.detect { |i| ids.count(i) > 1 } || []
      raise "Your collection duplicate ids: \n#{duplicates}" unless duplicates.empty?
    end

    def generate_pages(name, meta, data, opts)
      dir       = "_#{name}"
      perma     = opts.fetch(:no_perma, meta[:ext])

      if opts.fetch(:force, false)
        FileUtils.rm_rf(dir)
        puts "Overwriting #{dir} directory with --force."
      end

      mkdir_p(dir)
      data.each do |item|
        pagename = slug(item.fetch(meta[:id_key]))
        pagepath = "#{dir}/#{pagename}.md"
        item['permalink'] = "/#{name}/#{pagename}#{perma}" if perma
        item['layout']    = meta[:layout]
        if File.exist?(pagepath)
          puts "#{pagename}.md already exits. Skipping."
        else
          File.open(pagepath, 'w') { |f| f.write("#{item.to_yaml}---") }
        end
      end
    rescue StandardError
      raise 'Pagemaster exited for some reason, most likely a missing or invalid id_key.'
    end

    def slug(str)
      str.downcase.tr(' ', '_').gsub(/[^:\w-]/, '')
    end
  end
end
