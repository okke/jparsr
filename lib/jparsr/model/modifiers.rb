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

module JParsr::Modifiers
  attr_reader :visibility

  def init_modifiers(tree)

    @visibility = :default
    @final = false;
    @static = false;
    @abstract = false;

    tree[:modifiers].each do |mod|
      @visibility = :public if mod.has_key?(:public)
      @visibility = :private if mod.has_key?(:private)
      @visibility = :protected if mod.has_key?(:protected)
      @final = true if mod.has_key?(:final)
      @static = true if mod.has_key?(:static)
      @abstract = true if mod.has_key?(:abstract)
    end
  end

  def public?
    @visibility == :public
  end

  def private?
    @visibility == :private
  end

  def protected?
    @visibility == :protected
  end

  def abstract?
    @abstract
  end

  def static?
    @static
  end

  def final?
    @final
  end
end


