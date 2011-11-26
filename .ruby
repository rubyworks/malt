--- 
dependencies: []

name: malt
conflicts: []

repositories: 
- name: upstream
  uri: git@github.com:rubyworks/malt.git
  scm: git
title: Malt
copyrights: 
- license: BSD-2-Clause
  holder: Rubyworks
  year: "2010"
replacements: []

resources: 
  code: http://github.com/rubyworks/malt
  docs: http://rubyworks.github.com/malt/docs/api
  bugs: http://github.com/rubyworks/malt/issues
  wiki: http://wiki.github.com/rubyworks/malt
  home: http://rubyworks.github.com/malt
date: "2011-11-25"
alternatives: []

version: 0.3.0
requirements: 
- name: blankslate
- groups: 
  - build
  name: detroit
  development: true
- groups: 
  - test
  name: qed
  development: true
- groups: 
  - test
  name: test
  development: true
- groups: 
  - test
  name: lemon
  development: true
- groups: 
  - test
  name: ae
  development: true
- groups: 
  - test
  name: rdoc
  version: 3+
  development: true
- groups: 
  - test
  name: RedCloth
  development: true
- groups: 
  - test
  name: bluecloth
  development: true
- groups: 
  - test
  name: kramdown
  development: true
- groups: 
  - test
  name: rdiscount
  development: true
- groups: 
  - test
  name: haml
  development: true
- groups: 
  - test
  name: sass
  development: true
- groups: 
  - test
  name: less
  development: true
- groups: 
  - test
  name: tenjin
  development: true
- groups: 
  - test
  name: rtals
  development: true
- groups: 
  - test
  name: liquid
  development: true
- groups: 
  - test
  name: erubis
  development: true
- groups: 
  - test
  name: mustache
  development: true
- groups: 
  - test
  name: markaby
  development: true
- groups: 
  - test
  name: builder
  development: true
- groups: 
  - test
  name: radius
  development: true
- groups: 
  - test
  name: ragtag
  development: true
- groups: 
  - test
  name: redcarpet
  development: true
- groups: 
  - test
  name: wikicloth
  development: true
- groups: 
  - test
  name: maruku
  development: true
- groups: 
  - test
  name: creole
  development: true
- groups: 
  - test
  name: erector
  development: true
- groups: 
  - test
  name: active_support
  development: true
- groups: 
  - test
  name: coffee-script
  development: true
revision: 0
authors: 
- name: trans
  email: transfire@gmail.com
summary: Multi-template/multi-markup rendering engine
description: Malt provides a factory framework for rendering a variety of template and markup document formats.
organization: rubyworks
source: 
- var
extra: {}

load_path: 
- lib
created: "2010-06-22"
