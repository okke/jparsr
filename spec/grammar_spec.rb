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
    parse(%Q{
    })
  end

  it "should accept a package statement" do
    parse(%Q{
      package soep;
    })
  end

  it "should accept a nested package statement" do
    parse(%Q{
      package com.soep.bowl;
    })
  end

  it "should accept an empty class" do
    parse(%Q{
      class Soep {
      }
    })
  end

  it "should accept an multple classes" do
    parse(%Q{
      class Soep {
      }
      class SoepBowl {
      }
    })
  end

  it "should accept a public class" do
    parse(%Q{
      public class Soep {
      }
    })
  end

  it "should accept a public final class" do
    parse(%Q{
      public final class Soep {
      }
    })
  end

  it "should accept a final public class" do
    parse(%Q{
      final public class Soep {
      }
    })
  end

  it "should accept an abstract class" do
    parse(%Q{
      abstract class Soep {
      }
    })
  end

  it "should accept a public abstract class" do
    parse(%Q{
      public abstract class Soep {
      }
    })
  end

  it "should accept a class import" do
    parse(%Q{
      import Bowl;
      class Soep {
      }
    })
  end

  it "should accept a fully qualified class import" do
    parse(%Q{
      import com.soup.Bowl;
      class Soep {
      }
    })
  end

  it "should accept a wildcard package import" do
    parse(%Q{
      import com.soup.*;
      class Soep {
      }
    })
  end

  it "should accept a static import" do
    parse(%Q{
      import static com.soup.Bowl;
      class Soep {
      }
    })
  end

  it "should accept class inheritance" do
    parse(%Q{
      class Soep extends Bowl {
      }
    })
  end

  it "should accept single interface implementation" do
    parse(%Q{
      class Soep implements Bowl {
      }
    })
  end

  it "should accept multiple interface implementation" do
    parse(%Q{
      class Soep implements Hot, Spicy {
      }
    })
  end

  it "should accept a single integer field member" do
    parse(%Q{
      class Soep {
        int i;
      }
    })
  end

  it "should accept a multiple field members" do
    parse(%Q{
      class Soep {
        int i;
        int j;
      }
    })
  end

  it "should accept all primitive field members" do
    parse(%Q{
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
    parse(%Q{
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
    parse(%Q{
      class Soep {
        public final static int i1;
      }
    })
  end

  it "should accept class type fields" do
    parse(%Q{
      class Soep {
        Bowl bowl;
      }
    })
  end


end
