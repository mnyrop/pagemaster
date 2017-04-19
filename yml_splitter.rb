Jekyll::Hooks.register :site, :after_reset do |site| # when site is re/built
	for collection in site.collections 
		collection = collection[1]
		if collection.metadata["output"] && collection.metadata["yml_split"] 
			# check usability of dir name, gsub alphanumerics to (especially) avoid leading double underscores, assign as targetdir
			unless collection.metadata["dir"].nil? || collection.metadata["dir"] == ''
				targetdir = "_" + collection.metadata["dir"].downcase.gsub(/[^\0-9a-z]/, '').to_s
			else
				raise "YAML-Splitter :: Target directory is undefined or unusable. Cannot generate pages. Specify dir in config and rebuild."
			end
			# set layout from config. if none specified, add default
			unless collection.metadata["layout"].nil? || collection.metadata["layout"] == ''
				layout = collection.metadata["layout"].to_s
			else # if no layout is specified, use default
				layout = "default"
				puts ">>>> YAML-Splitter :: No layout specified in config. Using default layout."
			end
			FileUtils::mkdir_p targetdir
			puts ">>>> YAML-Splitter :: Made directory " + targetdir + " in root."
			src = collection.metadata["source"].to_s
			begin
				my_yml = YAML::load(File.open('_data/' + src))
				puts ">>>> YAML-Splitter :: Loaded " + src + "."
			rescue
				raise "YAML-Splitter :: Cannot load " + src + ". Check for typos and rebuild."
			end
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
