# RELEASE HISTORY

## 0.4.0 | 2011-11-27

This release of Malt is a major improvement over the previous release.
Where as before not all formats behaved consistently --for instance,
not all templating engines handled block yielding, this release has
ensured consistent functionality across all engines. A couple of
significant changes were made to do this.

Most important to the end user, templating formats can no longer
use `yield` to insert block content, but rather must use `content`.
This was done to avoid unnecessary implementation complexity due
to Ruby's limitation on the use of yield within Proc objects.
The code is much cleaner and subsequently more robust thanks to 
this change.

The builder-style engines (Builder, Markaby, Erector and Nokogiri)
have all been united under a single `Builder` format class. The
common extension for such files is `.rbml`. These engines have been
tweaked to behave uniformly, supporting explicit and implicit
evaluation modes and using instance variables and externalized
scope.

In addition to these changes, a few new formats/engines have been
added, including Creole, Maruku, WikiCloth, CoffeeScript and
Nokogiri Builder.

Changes:

* Add Creole, Maruku and WikiCloth markup engine/formats.
* Add CoffeeScript transpiler engine/formats.
* Add Nokogiri Builder format.
* Support `scope and `locals` style data, as well as `data` option.
* Unified builder engines under one .rbml/.builder format.
* Use #content instead of #yield for block content!
* Add :multi option for multi-format rendering.
* Overhaul internal engine API, for better overall design.
* Formats delegate to master Malt.render method.


## 0.3.0 | 2010-11-04

New release adds a Malt::Machine class that encapsulates all
Malt's class level functionality. This allow Malt to be 
be more finally controlled. For example an instance of 
Malt::Machine can be used to limit rendering to a select
set of formats.

Changes:

* Add Machine class to encapsulate toplevel functions.
* Add feature via Machine options to select available formats.
* Add `#to_default` to for converting to default format.
* Add `Malt.engine?` to test for supported engine types.
* Rename `Malt.support?` to `Malt.format?`.
* Rename `Malt.main` to `Malt.cli`.


## 0.2.0 | 2010-10-22

Malt now support Erector, Markaby, Builder and Mustache templates.
Erector, Markaby and Builder are Ruby-based formats --templates
are simply Ruby code. This requires them to use instance variables
in templates rather than local variables/methods. Something to keep
in mind.

Changes:

* Add support for Erector templates.
* Add support for Markaby templates.
* Add support for Builder templates.
* Add support for Mustache templates.
* Add `:pass` option to render method.
* Rename `:format` option to `:to` for render method.


## 0.1.1 | 2010-09-21

This release simple fixes two bugs. One to handle variant arity
in format class #render methods. Currently the interface can vary
dependent on whether they accept interpolation data or not (this will
probably be uniform in the future). The other fix raises an error if
no engine exists to handle a given format.

Changes:

* Bug fix to raise error if format not handled by any engine.
* Bug fix to underlying #render calls to handle variant arities. 


## 0.1.0 | 2010-08-23

This if the initial release of Malt. I have no doubt the code base
still needs some fine-tuning --hence the 0.1 version, but I have put
it to good use with the latest version of Brite, my static website
generator, so I know that it is at least is a working state.

Changes:

* Initial release.

