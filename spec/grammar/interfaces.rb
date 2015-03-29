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

shared_examples :interfaces do

  it "should accept an empty interface" do
    parse(%q{
      interface Soep {
      }
    })
  end

  it "should accept an interface extending another interface" do
    parse(%q{
      interface Soep extends Food {
      }
    })
  end

  it "should accept an interface extending multiple other interfaces" do
    parse(%q{
      interface Soep extends Food, Fluid {
      }
    })
  end

  it "should accept a generic interface" do
    parse(%q{
      interface Soep<T> extends Food<T>, Fluid<T> {
      }
    })
  end


  it "should accept an interface with a method declarations" do
    parse(%q{
      interface Soep {
        void Boil();
      }
    })
  end

  it "should accept an interface with multiple method declarations" do
    parse(%q{
      interface Soep {
        void Boil();
        public List<String> getIngredients();
      }
    })
  end

end
