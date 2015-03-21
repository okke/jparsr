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

    rule(:package_kw)  { str('package') >> skip }
    rule(:class_kw)    { str('class') >> skip }

    rule(:literal)     { match('[a-zA-Z0-9_]').repeat >> skip}

    rule(:package_name) { literal >> (dot >> literal).repeat.maybe }

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

    rule(:class_def) do
      class_kw >>
      literal >>
      lcurly >>
        any_between_curlies >>
      rcurly >>
      skip
    end

    rule(:source_file) do
      skip >>
      package_def.maybe >>
      class_def.maybe
    end

    root :source_file
  end
end
