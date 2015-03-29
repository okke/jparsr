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
require 'grammar/basic_class'
require 'grammar/members'
require 'grammar/literals'
require 'grammar/methods'
require 'grammar/generics'
require 'grammar/comments'
require 'grammar/interfaces'
require 'grammar/enums'


describe JParsr::Grammar do

  it_behaves_like :packages
  it_behaves_like :basic_class
  it_behaves_like :members
  it_behaves_like :literals
  it_behaves_like :methods
  it_behaves_like :generics
  it_behaves_like :comments
  it_behaves_like :interfaces
  it_behaves_like :enums

  it "should accept an empty source file to parse" do
    parse(%q{
    })
  end

  it "should accept local method variables" do
    parse(%q{
      class Soep {
        void boil() {
          int i;
          String s = null;
          boolean a,b = true;
          int[] arr = null;
          int []arr1, []arr2;
        };
      }
    })
  end

  it "should accept a return statement" do
    parse(%q{
      class Soep {
        void boil() {
          return;
        };
      }
    })
  end

  it "should accept a return expression statement" do
    parse(%q{
      class Soep {
        String boil() {
          return "hot";
        };
      }
    })
  end

  it "should accept a static block inside a class" do
    parse(%q{
      class Soep {
        static {
        }
      }
    })
  end

  it "should accept a mix of static blocks, members and methods" do
    parse(%q{
      class Soep {
        public int i = 0;
        static {
        }
        private static final int i = 0;
        void boil() {
        }
        String s = "hot";
        static {
          return "return from static block?";
        }
        void boilAgain() {
        }
      }
    })
  end


end
