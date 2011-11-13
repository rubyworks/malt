== Erector

Lets say we have a Erector document called 'test.erector' containing:

  html do
    h1 "Example #{@title}"
    p "This is an example of a Maraby template."
  end

Notice the use of the instance variable. Erector templates must use instance
variables for data rendering in order to avoid ambiguity with the markup
syntax itself.

We can render Erector documents via the +render+ method, as we can any format.
Since Erector is a template format and not just a markup syntax, so we need
to also provide the +render+ function with data for interpolation into the
Erector document. 

  data = { :title=>"Document" }

  html = Malt.render(:file=>'test.erector', :data=>data)

  html.assert.include?('<h1>Example Document</h1>')

We can get a hold of the Erector document via the Malt.file function.

  erector = Malt.file('test.erector')

  erector.class.assert == Malt::Format::Erector

We can convert Erector documents to html very easily.

  data = {:title => "Document"}

  html = erector.to_html(data)

First we will notice that the output is an instance of Malt::Format::HTML.

  html.class.assert == Malt::Format::HTML

And that by calling #to_s we can get the rendered HTML document.

  html.to_s.assert.include?('<h1>Example Document</h1>')

Or we can convert the Erector document directly to HTML via the #html method.

  out = erector.html(data)

  out.assert.include?('<h1>Example Document</h1>')

