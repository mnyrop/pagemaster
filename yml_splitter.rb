Jekyll::Hooks.register :site, :after_reset do |site| # when site is re/built
	for collection in site.collections # look thru collections in config.yml
		collection = collection[1]
		if collection.metadata["output"] && collection.metadata["yml_split"]
			unless collection.metadata["dir"].nil? || collection.metadata["dir"] == ''
				targetdir = "_" + collection.metadata["dir"].downcase.gsub(/[^\0-9a-z]/, '').to_s # accepts alphanumeric only, esp. avoiding double _
			else
				raise "Yml_Splitter :: Target directory is undefined or unusable. Cannot generate pages. Specify dir in config and rebuild."
			end
			unless collection.metadata["layout"].nil? || collection.metadata["layout"] == ''
				layout = collection.metadata["layout"].to_s
			else # if no layout is specified, use default
				layout = "default"
				puts ">>>> Yml_Splitter :: No layout specified in config. Using default layout."
			end
			FileUtils::mkdir_p targetdir
			puts ">>>> Yml_Splitter :: Made directory " + targetdir + " in root."
			src = collection.metadata["source"].to_s
			my_yml = YAML::load(File.open('_data/' + src))
			puts ">>>> Yml_Splitter :: Loaded " + src + "."
			page_count = 0
			my_yml.each do |item|
				basename = item["title"].to_s.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '').gsub(/-+/, '-')
				pagepath = targetdir + "/" + basename + ".md"
				if !File.exist?(pagepath)
					File.open(pagepath, 'w') { |file| file.write( item.to_yaml.to_s  + "layout: " + layout + "\n---" ) }
					page_count+=1
				end
			end
			puts ">>>> Yml_Splitter :: Completed page generation of " + page_count.to_s + " pages from collection data."
		end
	end
end
