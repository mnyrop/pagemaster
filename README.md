# YAML-Splitter
## A minimal Jekyll plugin for generating a collection of markdown pages from a YAML array

#### How?

YAML-Splitter takes a specified YAML file from your `_data` folder and 'splits' each item into its own markdown page with the item data reproduced as front-matter.

#### Why?

If you have a data set for a Jekyll collection (say, a CSV of page titles, image links, dates, tags, and so on), you can completely automate the generation of collection pages by (1) converting your file to YAML and (2) running this plugin on it. ___No manual entry required.___ And if each page in the collection uses the same custom layout, you can (3) specify that layout in your `config` and generate the html pages to your compiled `_site`, exactly as you want, without ever having to touch the markdown pages.

## To use:
1. Add yml_splitter.rb to your `_plugins` directory.

2. Set-up your collection(s) in `_config.yml`:
```
collections:
    my_collection1:
      source: my_data.yml
      output: true
      yml_split: true
      name_key: title
      dir: my-directory
      layout: my_layout
    my_collection2:
      ...
```
3. Run `jekyll build`

4. Turn `yml_split` to `false` in order to skip running the plugin on future instances of `jekyll build` and `jekyll serve`.

</br>

### Config Parameters:

|             	|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	|
|-------------	|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	|
| `source`    	| REQUIRED: The name of the YAML data file you want to use to generate the .md pages. This file __must__ be in the `_data` directory in the root of your Jekyll site, and you __must__ include the file extension (.yml or .yaml). |
| `output`    	| REQUIRED: This is a built-in Jekyll collections value, and must be set to `true` in order to generate pages. Once the pages are generated, flip this value and/or `yml_split` to `false` to avoid the plugin running unecessarily on `jekyll build` or `jekyll serve`. |
| `yml_split` 	| REQUIRED: Must be set to `true` for YAML-Splitter to run on a given collection. If you have another collection within your site for which you do not want to generate pages, set this parameter to `false` for that collection. As with `output` above, you can also switch this value to `false` after the pages are properly generated. |                                                                     
| `name_key`    	| REQUIRED: The key in your YAML file that will be used to generate the file names of your pages. E.g. "title", "name", "id", etc. 	|
| `dir`       	| REQUIRED: The name of the directory where the generated pages will go. This must be specified for the plugin to run.     |         
| `layout`    	| OPTIONAL: YAML-Splitter will add layout information to the front-matter of the generated pages based on this value, so that Jekyll can build the html pages and style them automatically. For example, if you specify `layout: page_gen_layout` in your `_config.yml`, you'll need to make a `page_gen_layout.html` template and put it in the `_layouts` directory at the root of your site. This value is optional, in case you'd like to granularly specify `layout` values within your YAML file. 	|


</br>

*__Note:__ You can add as many parameters to your collection config as you like (for use in other functions for your site), but make sure they do not overwrite any of the ones above!*

</br>

## Bugs:

Unkown number of unknown bugs.


## License:

This project is licensed under the MIT License - see the [LICENSE.md](https://github.com/mnyrop/YAML-Splitter/blob/master/LICENSE.md) file for details
