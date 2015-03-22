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


end
