module Pagemaster
  class Runner
    attr_reader :config, :args, :opts, :collections

    def initialize(config = nil, args, opts)
      @config       = config || parse_config
      @args         = args
      @opts         = opts
      @collections  = parse_collections

      raise Error::MissingArgs, 'You must specify one or more collections after `jekyll pagemaster`' if @args.empty?
      raise Error::InvalidCollection, "Cannot find collection(s) #{args} in config" if collections.empty?
    end

    def self.run

    end

    def parse_config
      YAML.load_file("#{`pwd`.strip}/_config.yml")
    end

    def parse_collections
      collections = @args.map { |a| @config.dig('collections', a) }
      raise Error::InvalidArgument, "Cannot find one or more requested collections #{args} in config" unless collections.all?

      collections.map { |c| Collection.new(c) }
    end

    # def ingest(meta)
    #   src = "_data/#{meta[:source]}"
    #   puts "Processing #{src}...."
    #   data = case File.extname(src)
    #          when '.csv'
    #            CSV.read(src, headers: true).map(&:to_hash)
    #          when '.json'
    #            JSON.parse(File.read(src).encode('UTF-8'))
    #          when '.yml'
    #            YAML.load_file(src)
    #          else
    #            raise 'Collection source must have a valid extension (.csv, .yml, or .json)'
    #          end
    #   detect_duplicates(meta, data)
    #   data
    # rescue StandardError
    #   raise "Cannot load #{src}. check for typos and rebuild."
    # end
    #
    # def detect_duplicates(meta, data)
    #   ids = data.map { |d| d[meta[:data]] }
    #   duplicates = ids.detect { |i| ids.count(i) > 1 } || []
    #   raise "Your collection duplicate ids: \n#{duplicates}" unless duplicates.empty?
    # end
    #
    # def generate_pages(name, meta, data, opts)
    #   dir       = "_#{name}"
    #   perma     = opts.fetch(:no_perma, meta[:ext])
    #
    #   if opts.fetch(:force, false)
    #     FileUtils.rm_rf(dir)
    #     puts "Overwriting #{dir} directory with --force."
    #   end
    #
    #   mkdir_p(dir)
    #   data.each do |item|
    #     pagename = slug(item.fetch(meta[:id_key]))
    #     pagepath = "#{dir}/#{pagename}.md"
    #     item['permalink'] = "/#{name}/#{pagename}#{perma}" if perma
    #     item['layout']    = meta[:layout]
    #     if File.exist?(pagepath)
    #       puts "#{pagename}.md already exits. Skipping."
    #     else
    #       File.open(pagepath, 'w') { |f| f.write("#{item.to_yaml}---") }
    #     end
    #   end
    # rescue StandardError
    #   raise 'Pagemaster exited for some reason, most likely a missing or invalid id_key.'
    # end
    #
    # def slug(str)
    #   str.downcase.tr(' ', '_').gsub(/[^:\w-]/, '')
    # end
  end
end
