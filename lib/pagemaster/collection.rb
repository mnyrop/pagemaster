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
      @name         = name
      @config       = config
      @source       = fetch('source')
      @id_key       = fetch('id_key')
      @copy_keys    = fetch('do_copy') if config.key?('do_copy')
      @resolve_keys = fetch('do_resolve') if config.key?('do_resolve')
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
      puts('Ingesting source')
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
      puts('Validating')

      puts('Checking if ID keys are present')
      ids = @data.map { |data_entry| data_entry.dig(@id_key) }
      unless ids.all?
        raise Error::InvalidCollection, "One or more items in collection '#{@name}' is missing required id for the id_key '#{@id_key}'"
      end

      puts('Checking for duplicate ID keys')
      duplicates = ids.detect { |id| ids.count(id) > 1 } || []
      raise Error::InvalidCollection, "The collection '#{@name}' has the following duplicate ids for id_key #{@id_key}: \n#{duplicates}" unless duplicates.empty?

      puts(Rainbow('Validation complete').green)
    end

    # Removes the output directory if it exists
    # Does nothing otherwise.
    def remove_output_dir
      return unless @dir

      FileUtils.rm_rf(@dir)
      puts Rainbow("Overwriting #{@dir} directory with --force.").cyan
    end

    # Attempts to process the resolve keys
    # For each entry
    #   key -> foreign_key
    # in _config.yml/do_resolve a lookup into @data occurs trying to find a mapping
    #   foreign_key -> value
    # If it is found the new mapping
    #   key -> value
    # is put into the returned hash.
    # @return a hash mapping
    def resolve_keys(data_entry)
      resolved_hash = {}
      return resolved_hash unless @resolve_keys

      @resolve_keys.each do |key, foreign_key|
        if data_entry.key?(foreign_key)
          value = data_entry.dig(foreign_key)
          resolved_hash[key] = value
          puts(Rainbow("Resolved #{key} -(#{foreign_key})-> #{value}").cyan)
        else
          puts(Rainbow("Foreign key #{foreign_key} not found in #{data_entry} - skipping").red)
        end
      end
      resolved_hash
    end

    def process_data_entry(data_entry)
      puts("Processing #{data_entry}")
      path = "#{@dir}/#{slug(data_entry[@id_key])}.md"
      new_entry = {}
      new_entry['layout'] = @config['layout'] if @config.key?('layout')
      new_entry['data'] = data_entry
      new_entry = new_entry.merge(resolve_keys(data_entry))
      new_entry = new_entry.merge(@copy_keys) if @copy_keys

      if File.exist?(path)
        puts(Rainbow("#{path} already exits. Skipping.").cyan)
      else
        File.open(path, 'w') { |file| file.write("#{new_entry.to_yaml}---") }
      end
      puts(Rainbow("Written #{path}").cyan)
      path
    end

    #
    #
    def generate_pages(opts, collections_dir, source_dir)
      @opts = opts
      @dir = File.join [source_dir, collections_dir, "_#{@name}"].compact

      remove_output_dir if @opts.fetch(:force, false)
      FileUtils.mkdir_p(@dir)
      @data = ingest_source
      validate_data

      processed_paths = []
      @data.map do |data_entry|
        path = process_data_entry(data_entry)
        processed_paths << path
      end
      processed_paths
    end

    #
    #
    def slug(str)
      str.downcase.tr(' ', '_').gsub(/[^:\w-]/, '')
    end
  end
end
