= Malt

Malt is a multi-template rendering framework.

  require 'malt'

For example lets say we have a document called 'test.rdoc'
containing ...

  = Example

  This is an example of RDOC rendering.

We can convert rdoc documents to html very easily.

  out = Malt.file('tmp/test.rdoc').html

First we will notice that the output is an instance
of Malt::Formats::HTML.

  out.class.assert == Malt::Formats::HTML

And that by calling #to_s we can get the rendered HTML
document.

  out.to_s.assert.include?('<h1>Example</h1>')

