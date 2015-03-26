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

shared_examples :members do

  it "should accept a single integer field member" do
    parse(%q{
      class Soep {
        int i;
      }
    })
  end

  it "should accept a multiple field members" do
    parse(%q{
      class Soep {
        int i;
        int j;
      }
    })
  end

  it "should accept all primitive field members" do
    parse(%q{
      class Soep {
        boolean b;
        byte b2;
        short s;
        int i;
        long l;
        char c;
        float f;
        double d;
      }
    })
  end

  it "should accept field modifiers" do
    parse(%q{
      class Soep {
        public int i1;
        private int i2;
        protected int i3;
        static int i4;
        final int i5;
        transient int i6;
        volatile int i7;
      }
    })
  end

  it "should accept multiple field modifiers" do
    parse(%q{
      class Soep {
        public final static int i1;
      }
    })
  end

  it "should accept class type fields" do
    parse(%q{
      class Soep {
        Bowl bowl;
      }
    })
  end

  it "should accept multiple field names" do
    parse(%q{
      class Soep {
        int i1, i2, i3;
      }
    })
  end

  it "should accept a primitive field initializer" do
    parse(%q{
      class Soep {
        boolean bt = true;
        int i1 = 3;
      }
    })
  end

  it "should accept an array type field" do
    parse(%q{
      class Soep {
        int[] arr = null;
      }
    })
  end

  it "should accept an array of arrays type field" do
    parse(%q{
      class Soep {
        int[][] arr = null;
      }
    })
  end

  it "should accept an array field by defining the fieldname as array" do
    parse(%q{
      class Soep {
        int []arr = null;
        int []arr1, []arr2 = null;
      }
    })
  end

end
