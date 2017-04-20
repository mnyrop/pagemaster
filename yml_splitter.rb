Jekyll::Hooks.register :site, :after_reset do |site| # when site is re/built
	for collection in site.collections
		collection = collection[1]
		if collection.metadata["output"] && collection.metadata["yml_split"]
			# check usability of dir name. gsub alphanumerics to (especially) avoid leading double underscores. make directory.
			if collection.metadata["dir"].to_s.empty?
				raise "YAML-Splitter :: Target directory is undefined or unusable. Cannot generate pages. Specify dir in config and rebuild."
			else
				targetdir = "_" + dir.downcase.gsub(/[^\0-9a-z]/, '').to_s
				FileUtils::mkdir_p targetdir
				puts ">>>> YAML-Splitter :: Made directory " + targetdir + " in root."
			end
			# set layout from config. if none specified, add default.
			if collection.metadata["layout"].to_s.empty?
				layout = "default"
				puts ">>>> YAML-Splitter :: No layout specified in config. Using default layout."
			else
				layout = collection.metadata["layout"].to_s
			end
			# load YAML from config source var
			begin
				src = collection.metadata["source"].to_s
				data = YAML::load(File.open('_data/' + src))
				puts ">>>> YAML-Splitter :: Loaded " + src + "."
			rescue
				raise "YAML-Splitter :: Cannot load " + src + ". Check for typos and rebuild."
			end
			# keep track of (valid) pages generated vs. (untitled, nonunique) pages skipped.
			untitled, nonunique, valid = 0, 0, 0
			# make pages
			data.each do |item|
				basename = item["title"].to_s.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '').gsub(/-+/, '-')
				pagepath = targetdir + "/" + basename + ".md"
				if basename.to_s.empty?
					puts ">>>> YAML-Splitter :: Title for item is unspecified. Cannot generate page."
					untitled+=1
				elsif !File.exist?(pagepath)
					File.open(pagepath, 'w') { |file| file.write( item.to_yaml.to_s  + "layout: " + layout + "\n---" ) }
					valid+=1
				else
					puts ">>>> YAML-Splitter :: " + basename + ".md already exits."
					nonunique+=1
				end
			end
			# log outcomes
			puts ">>>> YAML-Splitter :: " + valid.to_s + " pages were generated from " + src + " to " + targetdir + " directory."
			puts ">>>> YAML-Splitter :: " + nonunique.to_s + " items were skipped because of non-unique names."
			puts ">>>> YAML-Splitter :: " + untitled.to_s + " items were skipped because of missing titles."
		end
	end
end
