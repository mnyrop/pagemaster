# pagemaster [:gem:](https://rubygems.org/gems/pagemaster) [![Gem Version](https://badge.fury.io/rb/pagemaster.svg)](https://badge.fury.io/rb/pagemaster) [![Dependency Status](https://gemnasium.com/badges/github.com/mnyrop/pagemaster.svg)](https://gemnasium.com/github.com/mnyrop/pagemaster)
## A Jekyll plugin for generating a collection of markdown pages to site root from a CSV or YAML file

### How?

**pagemaster** takes a specified `.yaml` or `.csv` file from your `_data` folder and 'splits' each item into the front matter of an individually generated page.

### Why?

If you have a data set for a Jekyll collection (e.g. a CSV of page titles, image links, dates, tags, and so on), you can completely automate the generation of collection pages by running this plugin with it. And if each page in the collection uses the same custom layout, you can specify that layout in your `_config.yml` file and generate the look of the pages programatically.

### Isn't this what Jekyll collections are for?

Kind of! **pagemaster** actually uses Jekyll collections, but gives you a lot more control and generates `.md` pages to root instead of `.html` pages to `_site/`.

### Will it work with GitHub Pages?

Yes. Because the pages are generated to root as markdown, you only need to run the plugin locally once. From there GH pages will do what it normally does with Jekyll sites: compile vanilla yaml and markdown to html.

## To use
1. Install by running `$ gem install pagemaster` or adding `gem 'pagemaster', '1.0.0'` to your Gemfile and running `$ bundle install`.
2. Add **pagemaster** as a plugin in `_config.yml`: `plugins: [ pagemaster ]` 
3. Set-up your collection(s) in `_config.yml` and add **pagemaster** variables. For example:
```yaml
collections:
      writers:
        output: true
        pm_generate: true
        pm_input: csv
        pm_source: writer-list
        pm_key: id
        pm_directory: writers
        pm_layout: writer-profile-page
      scientists:
        output: true
        pm_generate: true
        pm_input: yaml
        pm_source: scientist-survey
        pm_key: orcid
        pm_layout: scientist-profile-page

      ...
```
4. Run (bundle exec) `jekyll build` or `jekyll serve`

5. Switch `pm_generate` to `false`. This will avoid re-running the plugin (and regenerating the pages) on future instances of `jekyll build` and `jekyll serve`.

<br>

### Config parameters, explained

| name | type | description | importance 	|
|:------|:------|:-------------|:-------------|
| `output` 	| boolean | This is a built-in Jekyll collections value, and **must be set to `true`** in order for the generated `.md` pages to be compiled to html on `jekyll build`. 	| required 	|  
| `pm_generate` 	| boolean | **Must be set to `true`** for **pagemaster** to run on a given collection. Switch this value to `false` after the pages are properly generated to avoid running the plugin again. 	| required 	|
| `pm_input`   | string | The src input type of the data file. **Must be `yaml` or `csv`.** Also serves as the extension of the file.  | required   |
| `pm_source` 	| string | The name of the data file you want to use to generate the .md pages. This file **must be present in the `_data` directory** in the root of your Jekyll site, and you **must not include the file extension.** 	| required 	|
| `pm_key` 	| string | The **unique variable / primary key** in your data file that will be used to generate the file names of your pages. E.g. `title`, `name`, `id`, etc. 	| required 	|
| `pm_directory` 	| string | The name of the directory where the generated pages will go. If not specified, the `source` file name will be used. 	| optional 	|
| `pm_layout` 	| string | **pagemaster** will add layout information to the front-matter of the generated pages based on this value, so that Jekyll can build the html pages and style them automatically. For example,  `pm_layout: page_gen_layout` in will use the `page_gen_layout.html` template in the `_layouts` directory at the root of your site. | optional 	|


### Results

For the `writers` example above, **pagemaster** will:
1.  look for `writer-list.csv` in the `_data` directory,
2. make a new directory called `_writers`, and
3. generate a markdown page for each item in `writer-list.csv`, named after its `id` value and using the `writer-profile-page.html` layout.

For the `scientists` example above, **pagemaster** will:
1. look for `scientist-survey.yaml` in the `_data` directory,
2. becuase no `pm_directory` is specified, it will name a new directory after the collection `_scientists`, and
3. generate a markdown page for each item in `scientist-survey.yaml`, named after its `orcid` value and using the `scientist-profile-page.html` layout.

```bash
+-- _config.yml
+-- _data
|   +-- writer-list.csv
+-- _writers
|   +-- 00001.md
|   +-- 00002.md
|   +-- 00003.md
|   +-- 00004.md
|   +-- 00005.md
|   +-- ...
+-- _layouts
|   +-- default.html
|   +-- writer-profile-page.html
|   +-- scientist-profile-page.html
+-- _scientists
|   +-- 0000-0002-1825-0097.md
|   +-- 0000-0002-1825-0098.md
|   +-- 0000-0002-1825-0099.md
|   +-- 0000-0002-1825-0100.md
|   +-- 0000-0002-1825-0101.md
|   +-- ..
```
<br>

*__Note:__ You can add as many parameters to your collection config as you like (for use in other functions for your site), but make sure they do not overwrite any of the ones above!*

<br>
