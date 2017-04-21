# Uses collection values defined in config.yml
# NEEDS: Strings (directory, source, name_key) and Booleans (yml_split, output)
# WANTS: String layout

Jekyll::Hooks.register :site, :after_reset do |site| # when site is re/built

	for collection in site.collections
		collection = collection[1]
		if collection.metadata["output"] && collection.metadata["yml_split"]

			# grab collection variables from config
			@dir = collection.metadata["directory"].to_s
			@name_key = collection.metadata["name_key"].to_s
			@layout = collection.metadata["layout"].to_s
			@src = collection.metadata["source"].to_s

			# check usability of dir name. gsub alphanumerics to (especially) avoid leading double underscores. then make directory.
			if @dir.empty?
				raise "YAML-Splitter :: Target directory is undefined or unusable. Cannot generate pages. Specify dir in config and rebuild."
			else
				@targetdir = "_" + @dir.downcase.gsub(/[^\0-9a-z]/, '').to_s
				FileUtils::mkdir_p @targetdir
				puts ">> YAML-Splitter :: Made directory " + @targetdir + " in root."
			end

			# check usability of name_key, to be used later when naming generated pages
			if @name_key.empty?
				raise "YAML-Splitter ::  Name_key is undefined or unusable. Cannot generate pages. Specify name_key in config and rebuild."
			end

			def ingest(s) # takes + opens src file
				begin
					puts ">> YAML-Splitter :: Loaded " + s + "."
					return YAML::load(File.open('_data/' + s))
				rescue
					raise "YAML-Splitter :: Cannot load " + s + ". Check for typos and rebuild."
				end
			end

			def uniqify(s, n) # takes opened src file, and name_key to slugify + uniquify
				occurences = {} # hash list of slug names and # of occurences
				s.each do |item|
					new_name = item[@name_key].downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '').gsub(/-+/, '-') # gsub for slug
					if occurences.has_key? new_name
						occurences[new_name]+=1
						safe_slug = new_name + "-" + occurences[new_name].to_s
					else
						occurences.store(new_name, 1)
						safe_slug = new_name
					end
					item.store("slug", safe_slug)
					puts safe_slug
				end
				return s # return changed yml array with unique, slugified names added
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
					puts ">> YAML-Splitter :: Title for item is unspecified. Cannot generate page."
					untitled+=1
				elsif !File.exist?(pagepath)
					File.open(pagepath, 'w') { |file| file.write( item.to_yaml.to_s + layout_str + "\n---" ) }
					# puts ">> YAML-Splitter :: Created " + pagename + ".md."
					valid+=1
				else
					puts ">> YAML-Splitter :: " + pagename + ".md already exits."
					nonunique+=1
				end
			end

			# log outcomes
			puts ">> YAML-Splitter :: " + valid.to_s + " pages were generated from " + @src + " to " + @targetdir + " directory."
			puts ">> YAML-Splitter :: " + nonunique.to_s + " items were skipped because of non-unique names."
			puts ">> YAML-Splitter :: " + untitled.to_s + " items were skipped because of missing titles."
		end
	end
end
