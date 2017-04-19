# YAML-Splitter
## A minimal Jekyll plugin for generating a collection of markdown files (with YAML front-matter) from single YAML array data file

### To use:
Add yml_splitter.rb to your `_plugins` directory.

Set-up your collection(s) in `_config.yml`:
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
#### Keys:
`source` : The name of the YAML data file you want to use to generate the .md pages. This file __must__ be in the _data directory in the root of your Jekyll site.

`output` : This is a built-in Jekyll collections value, and must be set to `true` in order to generate pages. Once the pages are generated, turn this value and/or `yml_split` to false, in order to avoid the plugin running unecessarily.

`yml_split` : Must be set to `true` for the yml_splitter to run on a given collection. If you have another collection within your site that you do not want to generate pages for, set this parameter to `false` for that collection. As with `output` above, you can switch this value to false after the pages are properly generated.

`layout` : YML-Splitter will add layout information to the front-matter of the generated pages based on this value, so that Jekyll can build the html pages and style them automatically. For example, if you specify `layout: page_gen_layout` in your `_config.yml`, you'll need to make a `page_gen_layout.html` template and put it in the `_layouts` directory at the root of your site. If no layout is specified, YML-Splitter adds `layout: default`.

`dir` : The name of the directory where the generated pages will go. This must be specified for the plugin to run.


</br>

