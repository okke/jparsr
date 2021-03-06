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

require 'spec_helper'

require 'grammar/packages'
require 'grammar/classes'
require 'grammar/members'
require 'grammar/literals'
require 'grammar/methods'
require 'grammar/generics'
require 'grammar/comments'
require 'grammar/interfaces'
require 'grammar/enums'
require 'grammar/statements'
require 'grammar/expressions'
require 'grammar/annotations'


describe JParsr::Grammar do

  it_behaves_like :packages
  it_behaves_like :classes
  it_behaves_like :members
  it_behaves_like :literals
  it_behaves_like :methods
  it_behaves_like :generics
  it_behaves_like :comments
  it_behaves_like :interfaces
  it_behaves_like :enums
  it_behaves_like :statements
  it_behaves_like :expressions
  it_behaves_like :annotations

  it "should accept an empty source file to parse" do
    parse(%q{
    })
  end





end
