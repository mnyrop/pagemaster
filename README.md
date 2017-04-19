# YAML-Splitter
## A minimal Jekyll plugin for generating a collection of markdown files (with YAML front-matter) from single YAML array data file

## To use:
1. Add yml_splitter.rb to your `_plugins` directory.

2. Set-up your collection(s) in `_config.yml`:
```
collections:
    my_collection1:
      source: my_data.yml
      output: true
      yml_split: true
      layout: page_gen_layout
      dir: my-directory
    my_collection2:
      ...
```
3. Make sure each collection item in your source file has a valid `title:` value. These will be used to name the page files.

</br>

### Config Parameters:


| `source`    	| The name of the YAML data file you want to use to generate the .md pages. This file __must__ be in the `_data` directory in the root of your Jekyll site, and you __must__ include the file extension (.yml or .yaml).                                                                                                                                                                                                                                                                                              	|
|-------------	|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	|
| `output`    	| This is a built-in Jekyll collections value, and must be set to `true` in order to generate pages. Once the pages are generated, flip this value and/or `yml_split` to `false` to avoid the plugin running unecessarily on `jekyll build` or `jekyll serve`.                                                                                                                                                                                                                                                        	|
| `yml_split` 	| Must be set to `true` for the yml_splitter to run on a given collection. If you have another collection within your site that you do not want to generate pages for, set this parameter to `false` for that collection. As with `output` above, you can switch this value to `false` after the pages are properly generated.                                                                                                                                                                                        	|
| `layout`    	| YML-Splitter will add layout information to the front-matter of the generated pages based on this value, so that Jekyll can build the html pages and style them automatically. For example, if you specify `layout: page_gen_layout` in your `_config.yml`, you'll need to make a `page_gen_layout.html` template and put it in the `_layouts` directory at the root of your site. If no layout is specified, YML-Splitter adds `layout: default` to the front matter of each page and notifies you in the console. 	|
| `dir`       	| The name of the directory where the generated pages will go. This must be specified for the plugin to run.                                                                                                                                                                                                                                                                                                                                                                                                          	|





</br>

*__Note:__ You can add as many parameters to your collection config as you like, to use in other parts of your site. Just make sure they do not overlap with the ones above!*

</br>

## Bugs:

The plugin currently does not account for collection items with the same name. If it encounters a second (or third...) item with the same name as one that has already generated a page, the plugin will move on. This can be mitigated by generating pages from unique IDs, though I will be working on another solution soon.
