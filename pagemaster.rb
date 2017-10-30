require 'yaml'
require 'csv'

Jekyll::Hooks.register :site, :after_reset do |site| # when site is re/built

	for collection in site.collections
		collection = collection[1]
		if collection.metadata["output"] && collection.metadata["pm_generate"]

			# grab collection variables from config
			@input = collection.metadata["pm_input"].to_s
			@dir = collection.metadata["pm_directory"].to_s
			@name_key = collection.metadata["pm_key"].to_s
			@src = collection.metadata["pm_source"].to_s
			@layout = collection.metadata["pm_layout"].to_s

			@layout ||= @src
			@src = @src + "." + @input

      # check if input is csv or yaml
      unless @input == 'yaml' or @input == 'csv'
        raise "pagemaster :: Input must be 'csv' or 'yaml'."
      end

			# check usability of dir name. gsub alphanumerics to (especially) avoid leading double underscores. then make directory.
			if @dir.empty?
				raise "pagemaster :: Target directory is undefined or unusable. Cannot generate pages. Specify dir in config and rebuild."
			else
				@targetdir = "_" + @dir.downcase.gsub(/[^\0-9a-z]/, '').to_s
				FileUtils::mkdir_p @targetdir
				puts ">> pagemaster :: Made directory " + @targetdir + " in root."
			end

			# check usability of name_key, to be used later when naming generated pages
			if @name_key.empty?
				raise "pagemaster ::  pm_key is undefined or unusable. Cannot generate pages. Specify pm_key in config and rebuild."
			end

			def ingest(src) # takes + opens src file
				begin
					puts ">> pagemaster :: Loaded " + src + "."
          if @input == 'yaml'
            return YAML.load_file('_data/' + src)
          else
            return CSV.read('_data/' + src, :headers => true).map(&:to_hash)
          end
				rescue
					raise "pagemaster :: Cannot load " + src + ". Check for typos and rebuild."
				end
			end

			def uniqify(hashes, key) # takes opened src file as hash array
				occurences = {} # hash list of slug names and # of occurences
				hashes.each do |item|
					if item[key].nil?
						raise "pagemaster :: Source file has at least one missing value for pm_key='" + key + "'. Cannot generate page."
					end
					new_name = item[key].downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '').gsub(/-+/, '-') # gsub for slug
					if occurences.has_key? new_name
						occurences[new_name]+=1
						safe_slug = new_name + "-" + occurences[new_name].to_s
					else
						occurences.store(new_name, 1)
						safe_slug = new_name
					end
					item.store("slug", safe_slug)
				end
				return hashes # return changed yml array with unique, slugified names added
			end

			# ingest data source, sort it and generate unique titles
			data = uniqify(ingest(@src), @name_key)

			# keep track of (valid) pages generated vs. (untitled, nonunique) pages skipped.
			untitled, nonunique, valid = 0, 0, 0

			# make pages
			data.each do |item|
				pagename = item["slug"]
				pagepath = @targetdir + "/" + pagename + ".md"
				layout_str = ""
				unless @layout.empty?
					layout_str = "layout: " + @layout
				end
				if pagename.empty?
					puts ">> pagemaster :: Title for item is unspecified. Cannot generate page."
					untitled+=1
				elsif !File.exist?(pagepath)
					File.open(pagepath, 'w') { |file| file.write( item.to_yaml.to_s + layout_str + "\n---" ) }
					valid+=1
				else
					puts ">> pagemaster :: " + pagename + ".md already exits."
					nonunique+=1
				end
			end

			# log outcomes
			puts ">> pagemaster :: " + valid.to_s + " pages were generated from " + @src + " to " + @targetdir + " directory."
			puts ">> pagemaster :: " + nonunique.to_s + " items were skipped because of non-unique names."
			puts ">> pagemaster :: " + untitled.to_s + " items were skipped because of missing titles."
		end
	end
end
