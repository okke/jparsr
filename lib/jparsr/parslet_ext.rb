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
#


require 'parslet'


#
# atom for not_in operations in grammar
#
class Parslet::Atoms::NotIn < Parslet::Atoms::Base
  attr_reader :parslet, :set, :set_name

  def initialize(parslet,set, set_name)
    @parslet = parslet
    @set = set
    @set_name = set_name
  end

  def try(source, context, consume_all)
    start_pos = source.pos

    success, value = result = parslet.apply(source, context, false)

    parsed = flatten(value,true)

    if set.has_key?(parsed.to_s)
      # TODO: correct error handling
      # (passing [value] as children does not seem to work
      #
      return context.err_at(self, source, "#{parsed} may not be part of #{set_name}", start_pos, [])
    end

    return result
  end

  def to_s_inner(prec)
    "not_in(#{set_name})"
  end

end

#
# add a not_in operator to the grammar construction dsl
#
# can be used like: match('[a-z]').repeat(1).not_in(set,"keywords")
# where set is a set of strings implemented as hash<string,any>
#
class Parslet::Atoms::Base
  def not_in(set, name)
    Parslet::Atoms::NotIn.new(self, set, name)
  end
end
