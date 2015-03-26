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

def parse(s)
  JParsr::Grammar.new.parse(s)
end

describe JParsr::Grammar do

  it "should accept an empty source file to parse" do
    parse(%q{
    })
  end

  it "should accept a package statement" do
    parse(%q{
      package soep;
    })
  end

  it "should accept a nested package statement" do
    parse(%q{
      package com.soep.bowl;
    })
  end

  it "should accept an empty class" do
    parse(%q{
      class Soep {
      }
    })
  end

  it "should accept an multple classes" do
    parse(%q{
      class Soep {
      }
      class SoepBowl {
      }
    })
  end

  it "should accept a public class" do
    parse(%q{
      public class Soep {
      }
    })
  end

  it "should accept a public final class" do
    parse(%q{
      public final class Soep {
      }
    })
  end

  it "should accept a final public class" do
    parse(%q{
      final public class Soep {
      }
    })
  end

  it "should accept an abstract class" do
    parse(%q{
      abstract class Soep {
      }
    })
  end

  it "should accept a public abstract class" do
    parse(%q{
      public abstract class Soep {
      }
    })
  end

  it "should accept a class import" do
    parse(%q{
      import Bowl;
      class Soep {
      }
    })
  end

  it "should accept a fully qualified class import" do
    parse(%q{
      import com.soup.Bowl;
      class Soep {
      }
    })
  end

  it "should accept a wildcard package import" do
    parse(%q{
      import com.soup.*;
      class Soep {
      }
    })
  end

  it "should accept a static import" do
    parse(%q{
      import static com.soup.Bowl;
      class Soep {
      }
    })
  end

  it "should accept class inheritance" do
    parse(%q{
      class Soep extends Bowl {
      }
    })
  end

  it "should accept single interface implementation" do
    parse(%q{
      class Soep implements Bowl {
      }
    })
  end

  it "should accept multiple interface implementation" do
    parse(%q{
      class Soep implements Hot, Spicy {
      }
    })
  end

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

end
