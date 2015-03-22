# 
# Copyright (c) 2015, Okke van 't Verlaat
#  
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
# 
# The above copyright notice and this permission notice shall be includedi
# in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR 
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
# 


require 'parslet'

module JParsr 

  class Grammar < Parslet::Parser
    rule(:space)       { match["\s\n\r"].repeat }
    rule(:space?)      { space.maybe }
    rule(:skip)        { space? }

    rule(:dot)         { str('.') >> skip}
    rule(:semicolon)   { str(';') >> skip}
    rule(:lcurly)      { str('{') >> skip}
    rule(:rcurly)      { str('}') >> skip}
    rule(:star)        { str('*') >> skip}

    rule(:package_kw)  { str('package') >> skip }
    rule(:public_kw)   { str('public') >> skip }
    rule(:final_kw)    { str('final') >> skip }
    rule(:abstract_kw) { str('abstract') >> skip }
    rule(:class_kw)    { str('class') >> skip }
    rule(:import_kw)   { str('import') >> skip }
    rule(:static_kw)   { str('static') >> skip }

    rule(:literal)     { match('[a-zA-Z0-9_]').repeat >> skip}

    rule(:package_name) { literal >> (dot >> literal).repeat.maybe }

    # NOT USED YET
    rule(:any_between_curlies) do
      (match('[^{}]')).repeat.maybe >>
      (str('{') >> any_between_curlies >> str('}') >> any_between_curlies).maybe
    end

    rule(:package_def) do
      package_kw >>
      package_name >>
      semicolon >> 
      skip
    end

    # TODO, current import allows multiple '*'s in declaration
    #
    rule(:import_def) do
      import_kw >>
      static_kw.maybe >>
      (literal >> (dot >> (star | literal)).repeat.maybe) >>
      semicolon >> 
      skip
    end

    rule(:class_modifier) do
      (public_kw | final_kw | abstract_kw).repeat
    end

    rule(:class_def) do
      class_modifier.maybe >>
      class_kw >>
      literal >>
      lcurly >>
      rcurly >>
      skip
    end

    rule(:source_file) do
      skip >>
      package_def.maybe >>
      import_def.maybe >>
      class_def.repeat.maybe
    end

    root :source_file
  end
end
