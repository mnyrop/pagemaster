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

`output` : This is a built-in Jekyll collections value, and must be set to `true` in order to generate pages.

`yml_split` : Must be set to `true` for the yml_splitter to run on a given collection. If you have another collection within your site that you do not want to generate pages for, set this parameter to `false` for that collection.

`layout` : YML-Splitter will replace the `layout: default` front-matter for the generated pages based on this value. For example, if you specify `layout: page_gen_layout` in your `_config.yml`, you'll need to make a `page_gen_layout.html` template and put it in the `_layouts` directory at the root of your site.

`dir` : The name of the directory where the generated pages will go.


</br>
*Note: This is the littlest, barest-of-bones plugin. It doesn't check for anything, or warn you if you're missing values. Be warned!
