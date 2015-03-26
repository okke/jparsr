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

shared_examples :literals do

  it "should accept long decimal literals" do
    parse(%q{
      class Soep {
        int i = 3l;
        int j = 3L;
      }
    })
  end

  it "should accept hexadecimal and octal literals" do
    parse(%q{
      class Soep {
        int i = 0x3;
        int j = 0X3;
        int p = 0X3l;
        int q = 0X3L;
        int o = 0777;
      }
    })
  end

  it "should accept floating point literals" do
    parse(%q{
      class Soep {
        double d = 1.2;
        double e = .2;
        double f = .2f;
        double g = 0.2F;
        double h = 0.2d;
        double i = 1.2D;
        double j = 2e5;
        double k = 2e+15;
        double l = 2e-15;
      }
    })
  end

  it "should accept character literals" do
    parse(%q{
      class Soep {
        char c = 'c';
        char d = '\\r';
      }
    })
  end

  it "should accept null as a literals" do
    parse(%q{
      class Soep {
        String name  = null;
      }
    })
  end

  it "should accept strings as a literals" do
    parse(%q{
      class Soep {
        String name  = "pea soup da luxe";
      }
    })
  end

  it "should accept escapes characters in strings" do
    parse(%q{
      class Soep {
        String name  = "\"pea\" soup\tda\tluxe\n";
      }
    })
  end

  it "should accept empty strings" do
    parse(%q{
      class Soep {
        String name  = "";
      }
    })
  end

end
