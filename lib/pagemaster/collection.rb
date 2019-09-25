# frozen_string_literal: true

module Pagemaster
  #
  #
  class Collection
    # Make the following attribute symbols readable
    attr_reader :source, :id_key, :layout, :data, :dir

    #
    #
    def initialize(name, config)
      @name       = name
      @config     = config
      @source     = fetch('source')
      @id_key     = fetch('id_key')
      @title_key  = fetch('title_key')
    end

    # Go through the configuration and return the value for the given key
    # If the key does not exist, raise an error
    # @param key that is supposed to be in the config for which to get the value
    # @return the value for the given key
    def fetch(key)
      raise Error::InvalidCollection, "Fetching key #{key} failed" unless @config.key?(key)

      @config.dig(key)
    end

    # Read the source file for the data set 
    # and parse it according to the file type 
    # Raise an error if
    #  * The file does not exist
    #  * The file extension is invalid
    #  * The file could not be parsed
    def ingest_source
      puts("Ingesting source")
      file = "_data/#{@source}"
      raise Error::InvalidSource, "Cannot find source file #{file}" unless File.exist?(file)

      case File.extname(file)
      when '.csv'
        return CSV.read(file, headers: true).map(&:to_hash)
      when '.json'
        return JSON.parse(File.read(file).encode('UTF-8'))
      when /\.ya?ml/
        return YAML.load_file(file)
      else
        raise Error::InvalidSource, "Collection source #{file} must have a valid extension (.csv, .yml, or .json)"
      end
    rescue StandardError
      raise Error::InvalidSource, "Cannot load #{file}. check for typos and rebuild."
    end

    # Goes over @data and checks for duplicate IDs and whether the @id_key is present.
    # Raises an error if the criteria are not met.
    # @return nothing
    def validate_data
      puts("Validating")

      puts("Checking if ID keys are present")
      ids = @data.map { |data_entry| data_entry.dig(@id_key) }
      unless ids.all?
        raise Error::InvalidCollection, "One or more items in collection '#{@name}' is missing required id for the id_key '#{@id_key}'"
      end

      puts("Checking for duplicate ID keys")
      duplicates = ids.detect { |id| ids.count(id) > 1 } || []
      unless duplicates.empty?
        raise Error::InvalidCollection, "The collection '#{@name}' has the following duplicate ids for id_key #{@id_key}: \n#{duplicates}"
      end
      puts(Rainbow("Validation complete").green)
    end

    # Removes the output directory if it exists
    # Does nothing otherwise.
    def remove_output_dir
      return unless @dir

      FileUtils.rm_rf(@dir)
      puts Rainbow("Overwriting #{@dir} directory with --force.").cyan
    end

    #
    #
    def generate_pages(opts, collections_dir, source_dir)
      @opts   = opts
      @dir    = File.join [source_dir, collections_dir, "_#{@name}"].compact

      remove_output_dir if @opts.fetch(:force, false)
      FileUtils.mkdir_p(@dir)
      @data = ingest_source
      validate_data

      processed_paths = []
      @data.map do |data_entry|
        puts("Processing #{data_entry}")
        path = "#{@dir}/#{slug(data_entry[@id_key])}.md"
        title = data_entry.dig(@title_key)
        new_entry = {}
        puts("\tlayout")
        new_entry['layout'] = @config['layout']       if @config.key?('layout')
        puts("\ttitle: #{title}")
        new_entry['title']  = title
        puts("\tdata")
        new_entry['data']   = data_entry

        if File.exist?(path)
          puts(Rainbow("#{path} already exits. Skipping.").cyan)
        else
          File.open(path, 'w') { |file| file.write("#{new_entry.to_yaml}---") }
        end
        puts(Rainbow("Written #{path}").cyan)
        processed_paths.append(path)
      end
      return processed_paths
    end

    #
    #
    def slug(str)
      str.downcase.tr(' ', '_').gsub(/[^:\w-]/, '')
    end
  end
end
