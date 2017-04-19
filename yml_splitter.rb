Jekyll::Hooks.register :site, :after_reset do |site| # when site is re/built
	for collection in site.collections # look thru collections in config.yml
		collection = collection[1]
		if collection.metadata["output"] && collection.metadata["yml_split"]
			unless collection.metadata["dir"].nil? || collection.metadata["dir"] == ''
				targetdir = "_" + collection.metadata["dir"].downcase.gsub(/[^\0-9a-z]/, '').to_s # accepts alphanumeric only, esp. avoiding double _
			else
				raise "YAML-Splitter :: Target directory is undefined or unusable. Cannot generate pages. Specify dir in config and rebuild."
			end
			unless collection.metadata["layout"].nil? || collection.metadata["layout"] == ''
				layout = collection.metadata["layout"].to_s
			else # if no layout is specified, use default
				layout = "default"
				puts ">>>> YAML-Splitter :: No layout specified in config. Using default layout."
			end
			FileUtils::mkdir_p targetdir
			puts ">>>> YAML-Splitter :: Made directory " + targetdir + " in root."
			src = collection.metadata["source"].to_s
			my_yml = YAML::load(File.open('_data/' + src))
			puts ">>>> YAML-Splitter :: Loaded " + src + "."
			page_count = 0
			skip_count = 0
			my_yml.each do |item|
				basename = item["title"].to_s.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '').gsub(/-+/, '-')
				pagepath = targetdir + "/" + basename + ".md"
				if !File.exist?(pagepath)
					File.open(pagepath, 'w') { |file| file.write( item.to_yaml.to_s  + "layout: " + layout + "\n---" ) }
					page_count+=1
				else
					puts ">>>> YAML-Splitter :: EEEK! " + basename + ".md already exits."
					skip_count+=1
				end
			end
			puts ">>>> YAML-Splitter :: " + page_count.to_s + " pages were generated from " + src + " to new directory " + targetdir + "."
			puts ">>>> YAML-Splitter :: " + skip_count.to_s + " items were skipped because of non-unique names."
		end
	end
end


