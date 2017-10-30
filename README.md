# pagemaster 🔀📄💥
## A Jekyll plugin for generating a collection of markdown pages to /root from a CSV or YAML file

#### How?

**pagemaster** takes a specified `.yaml` or `.csv` file from your `_data` folder and 'splits' each item into the front matter of an individually generated page.

#### Why?

If you have a data set for a Jekyll collection (e.g. a CSV of page titles, image links, dates, tags, and so on), you can completely automate the generation of collection pages by running this plugin with it. And if each page in the collection uses the same custom layout, you can specify that layout in your `config` and generate the html pages to your compiled `_site`, exactly as you want, without ever having to touch the markdown pages.

#### Isn't this what Jekyll collections are for?

Kind of. But **pagemaster** gives you a lot more control and generates specifically to the `root` of your site.

#### Will it work with GitHub Pages?

Yes. Because the pages are generated to root as markdown, you only need to run the plugin locally once. From there GH pages will do what it normally does with Jekyll sites—compile vanilla yaml and markdown to html.

## To use
1. `gem install pagemaster` or add `gem 'pagemaster, '1.0.0'` to your Gemfile.
2. Set-up your collection(s) in `_config.yml`. For example:
```yaml
collections:
      writers:
        output: true
        pm_generate: true
        pm_input: csv
        pm_source: writer-list
        pm_key: id
        pm_directory: writer
        pm_layout: writer-profile-page
      scientists:
        output: true
        pm_generate: true
        pm_input: yaml
        pm_source: scientist-survey
        pm_key: orcid
        pm_directory: scientist
        pm_layout: scientist-profile-page

      ...
```
3. Run `jekyll build`

4. Turn `pm_generate` to `false` in order to skip re-running the plugin (and regenerating the pages) on future instances of `jekyll build` and `jekyll serve`.

</br>

### Config parameters, explained

| name | type | description | importance 	|
|:------|:------|:-------------|:-------------|
| `output` 	| boolean | This is a built-in Jekyll collections value, and must be set to `true` in order for the generated `.md` pages to be compiled to html on `jekyll build`. 	| required 	|  
| `pm_generate` 	| boolean | Must be set to `true` for **pagemaster** to run on a given collection. Switch this value to `false` after the pages are properly generated to avoid running the plugin again. 	| required 	|
| `pm_input`   | string | The src input type of the data file. Must be `yaml` or `csv`. Also serves as the extension of the file.  | required   |
| `pm_source` 	| string | The name of the data file you want to use to generate the .md pages. This file __must__ be present in the `_data` directory in the root of your Jekyll site, and you __must not__ include the file extension. 	| required 	|
| `pm_key` 	| string | The unique variable / primary key in your data file that will be used to generate the file names of your pages. E.g. `title`, `name`, `id`, etc. 	| required 	|
| `pm_directory` 	| string | The name of the directory where the generated pages will go. If not specified, the `source` file name will be used. 	| optional 	|
| `pm_layout` 	| string | YAML-Splitter will add layout information to the front-matter of the generated pages based on this value, so that Jekyll can build the html pages and style them automatically. For example,  `pm_layout: page_gen_layout` in will use the `page_gen_layout.html` template in the `_layouts` directory at the root of your site. | optional 	|


### Results

For the `writers` example above, **pagemaster** will:
1.  look for `writer-list.csv` in the `_data` directory,
2. make a new directory called `_writers`, and
3. generate a markdown page for each item in `writer-list.csv`, named after its `id` value and using the `writer-profile-page.html` layout.

<br>

*__Note:__ You can add as many parameters to your collection config as you like (for use in other functions for your site), but make sure they do not overwrite any of the ones above!*

<br>
