# frozen_string_literal: true

module Pagemaster
  #
  #
  class Collection
    attr_reader :source, :id_key, :layout, :data, :dir

    #
    #
    def initialize(name, config)
      @name   = name
      @config = config
      @source = fetch 'source'
      @id_key = fetch 'id_key'
    end

    #
    #
    def fetch(key)
      raise Error::InvalidCollection unless @config.key? key

      @config.dig key
    end

    #
    #
    def ingest_source
      file = "_data/#{@source}"
      raise Error::InvalidSource, "Cannot find source file #{file}" unless File.exist? file

      case File.extname file
      when '.csv'
        CSV.read(file, headers: true).map(&:to_hash)
      when '.json'
        JSON.parse(File.read(file).encode('UTF-8'))
      when /\.ya?ml/
        YAML.load_file file
      else
        raise Error::InvalidSource, "Collection source #{file} must have a valid extension (.csv, .yml, or .json)"
      end
    rescue StandardError
      raise Error::InvalidSource, "Cannot load #{file}. check for typos and rebuild."
    end

    #
    #
    def validate_data
      ids = @data.map { |d| d.dig @id_key }
      raise Error::InvalidCollection, "One or more items in collection '#{@name}' is missing required id for the id_key '#{@id_key}'" unless ids.all?

      duplicates = ids.detect { |i| ids.count(i) > 1 } || []
      raise Error::InvalidCollection, "The collection '#{@name}' has the follwing duplicate ids for id_key #{@id_key}: \n#{duplicates}" unless duplicates.empty?
    end

    #
    #
    def overwrite_pages
      return unless @dir

      FileUtils.rm_rf @dir
      puts Rainbow("Overwriting #{@dir} directory with --force.").cyan
    end

    #
    #
    def generate_pages(opts, collections_dir, source_dir)
      @opts   = opts
      @dir    = File.join [source_dir, collections_dir, "_#{@name}"].compact

      overwrite_pages if @opts.fetch :force, false
      FileUtils.mkdir_p @dir
      @data = ingest_source
      validate_data

      @data.map do |d|
        path = "#{@dir}/#{slug d[@id_key]}.md"
        d['layout'] = @config['layout'] if @config.key? 'layout'
        if File.exist? path
          puts Rainbow("#{path} already exits. Skipping.").cyan
        else
          File.open(path, 'w') { |f| f.write("#{d.to_yaml}---") }
        end
        path
      end
    end

    #
    #
    def slug(str)
      str.downcase.tr(' ', '_').gsub(/[^:\w-]/, '')
    end
  end
end
