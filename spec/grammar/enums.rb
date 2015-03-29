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

shared_examples :enums do

  it "should accept an empty enum" do
    parse(%q{
      enum Soep {
      }
    })
  end

  it "should accept an enum implementing an interface" do
    parse(%q{
      enum Soep implements Food {
      }
    })
  end

  it "should accept an enum with constants" do
    parse(%q{
      enum Soep implements Food {
        TOMATO_SOUP, PEA_SOUP, GAZPACHO
      }
    })
  end

  it "should accept an enum with initializers for constants" do
    parse(%q{
      enum Soep implements Food {
        HOT_AND_SPICY_MEXIAN_BLACK_BEAN_SOUP("hasmbbs"), MELON_SOUP('m')
      }
    })
  end

  it "should accept an enum with constants followed by class members" do
    parse(%q{
      enum Soep implements Food {
        TOMATO_SOUP, PEA_SOUP, GAZPACHO;

        int a;
        void boil();

      }
    })
  end


end
