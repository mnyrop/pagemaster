# pagemaster

[![Gem Version](https://badge.fury.io/rb/pagemaster.svg)](https://badge.fury.io/rb/pagemaster) ![License](https://img.shields.io/badge/license-MIT-yellowgreen.svg) ![Gem](https://img.shields.io/gem/dt/pagemaster?color=blue)
[![Build Status](https://travis-ci.com/mnyrop/pagemaster.svg?branch=master)](https://travis-ci.com/mnyrop/pagemaster)
[![Dependencies](https://img.shields.io/librariesio/github/mnyrop/pagemaster.svg)](https://libraries.io/github/mnyrop/pagemaster)

[![Maintainability](https://api.codeclimate.com/v1/badges/4f88f2668f643bbbacdf/maintainability)](https://codeclimate.com/github/mnyrop/pagemaster/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/4f88f2668f643bbbacdf/test_coverage)](https://codeclimate.com/github/mnyrop/pagemaster/test_coverage)

__jekyll plugin for generating markdown collection pages from .csv, .json, or .yml records__

<img src="https://media.giphy.com/media/XqpLGIQ7nMtqM/giphy.gif"/>

### How?

**pagemaster** takes a specified `.yml`, `.csv`, or `.json` file from your `_data` folder and 'splits' each item into the front matter of an individually generated markdown page.

### Why?

If you have a data set for a Jekyll collection (e.g. a CSV of page titles, image links, dates, tags, and so on), you can completely automate the generation of collection pages by running this plugin with it. And if each page in the collection uses the same custom layout, you can specify that layout in your `_config.yml` file and generate the look of the pages programatically.

### Isn't this what Jekyll collections are for?

Kind of! **pagemaster** actually uses Jekyll collections, but gives you a lot more control and generates `.md` pages to root instead of `.html` pages to `_site/`.

### Will it work with GitHub Pages?

Kind of! Because the pages are generated to root as markdown, you only need to run the plugin locally once. From there GH pages will do what it normally does with Jekyll sites: compile vanilla yaml and markdown to html. So GitHub won't run it, but it shouldn't need to.

## To use
1. Add `pagemaster` to the `:jekyll_plugins` group of your `Gemfile` like so:
    ```rb
    group :jekyll_plugins do
      gem 'pagemaster'
    end
    ```
2. Run `$ bundle install`.
2. Add **pagemaster** as a plugin in `_config.yml` like so:
  ```yml
  plugins:
    - pagemaster
  ```
3. Set-up your collection(s) in `_config.yml` and add **pagemaster** variables. For example:

```yaml
collections:
  writers:
    output: true
    source: writer-list.csv
    id_key: id
    layout: writer-profile-page
  scientists:
    output: true
    source: scientist-survey.json
    id_key: orcid
    layout: scientist-profile-page
```
4. Run $`bundle exec jekyll pagemaster [collection-name]`, e.g. $`bundle exec jekyll pagemaster writers scientists`.

### Results

For the `writers` example above, **pagemaster** will:
1. look for `writer-list.csv` in the `_data` directory,
2. make a new directory called `_writers`, and
3. generate a markdown page for each item in `writer-list.csv`, named after its `id` value and using the `writer-profile-page.html` layout.

For the `scientists` example above, **pagemaster** will:
1. look for `scientist-survey.json` in the `_data` directory,
2. make a new directory  `_scientists`, and
3. generate a markdown page for each item in `scientist-survey.json`, named after its `orcid` value and using the `scientist-profile-page.html` layout.

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
