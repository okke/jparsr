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

shared_examples :methods do

  it "should accept an empty method" do
    parse(%q{
      class Soep {
        int boil() {
        }
      }
    })
  end

  it "should accept a void method" do
    parse(%q{
      class Soep {
        void boil() {
        }
      }
    })
  end

  it "should accept method with one parameter" do
    parse(%q{
      class Soep {
        void boil(int temperature) {
        }
      }
    })
  end

  it "should accept method with multiple parameters" do
    parse(%q{
      class Soep {
        void boil(float temperature, long duration) {
        }
      }
    })
  end

  it "should accept method with an array parameter" do
    parse(%q{
      class Soep {
        void boil(float temperature[]) {
        }
      }
    })
  end

  it "should accept method with variable arguments" do
    parse(%q{
      class Soep {
        void boil(float ... temperature) {
        }
      }
    })
  end

  it "should accept multiple methods" do
    parse(%q{
      class Soep {
        void boil() {
        }
        void freeze() {
        }
      }
    })
  end

  it "should accept a method ending with a semicolon" do
    parse(%q{
      class Soep {
        int i;
        void boil() {
        };
      }
    })
  end

  it "should accept an abstract method" do
    parse(%q{
      class Soep {
        abstract void boil();
      }
    })
  end

  it "should accept a synchronized method" do
    parse(%q{
      class Soep {
        synchronized void boil() {
        }
      }
    })
  end

  it "should accept a constructor method" do
    parse(%q{
      class Soep {
        Soep() {
        }
      }
    })
  end

  it "should accept multiple constructor methods" do
    parse(%q{
      class Soep {
        Soep() {
        }
        Soep(int i) {
        }
      }
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
          int arr1[], arr2[] = new int[3];
          int i1=1, i2=2, i3=3;
        };
      }
    })
  end

  it "should accept a mix of local method variables and statements" do
    parse(%q{
      class Soep {
        int boil() {
          String s = null;
          freeze(10);
          String s2 = null;
          return 98;
        };
      }
    })
  end

  it "should accept a local variable with a primitive array initializer" do
    parse(%q{
      class Soep {
        void boil() {
          int temperatures[] = {65,85,95};
        };
      }
    })
  end

  it "should accept a fully qualified local method variable" do
    parse(%q{
      class Soep {
        int boil() {
          special.MenuItem menuItem;
        };
      }
    })
  end

  it "should accept a throws clause with one defined exception" do
    parse(%q{
      class Soep {
        int boil() throws SoupToHotException {
        }
      }
    })
  end

  it "should accept a throws clause with multiple defined exception" do
    parse(%q{
      class Soep {
        int boil() throws SoupToHotException, AllSoupGoneException {
        }
      }
    })
  end

  it "should accept a final method parameter" do
    parse(%q{
      class Soep {
        int boil(final int i) {
        }
      }
    })
  end


end
