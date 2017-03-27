Jekyll::Hooks.register :site, :after_reset do |site|
	for collection in site.collections
		collname = collection[0]
		collection = collection[1]
		if collection.metadata["output"] && collection.metadata["yml_split"]
			targetdir = "_" + collection.metadata["dir"]
			FileUtils::mkdir_p targetdir
        src = collection.metadata["source"]
        my_yml = YAML::load(File.open('_data/' + src))
        my_yml.each do |item|
          basename = item["title"].to_s.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
          pagepath = targetdir + "/" + basename + ".md"
          layout = collection.metadata["layout"]
          if !File.exist?(pagepath)
      		    File.open(pagepath, 'w') { |file| file.write( item.to_yaml.to_s  + "layout: " + layout + "\n---" ) }
      		end
		   end
    end
	end
end
