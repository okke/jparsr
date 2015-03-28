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

shared_examples :comments do

  it "should accept a single line comment" do
    parse(%q{
      // Soup or no Soup
    })
  end

  it "should accept nothing but the start of a single line comment" do
    parse('//')
  end

  it "should accept a multiple single line comments" do
    parse(%q{
      // Soup or no Soup
      // Sing your own halleluyah
    })
  end

  it "should accept a single line after regular code" do
    parse(%q{
      class Soup {                // Soup or no Soup
        List<String> ingredients; // Sing your own halleluyah
      }                           // (Halleluyah)
    })
  end

  it "should accept a comment block" do
    parse(%q{
      /* Soup or no Soup */
    })
  end

  it "should accept a multi line comment block" do
    parse(%q{
      /* 
        Soup or no Soup 
        Sing you own halleluyah
      */
    })
  end

  it "should accept a comment block between regular code" do
    parse(%q{
       class /* Soup or no Soup */ Soup {
         /* Sing your own halleluyah */ int i;
       }
    })
  end

end
