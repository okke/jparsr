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

shared_examples :classes do

  it "should accept an empty class" do
    parse(%q{
      class Soep 
      {
      }
    },:root) do |tree|
      expect(find(tree,[:class, :name, :id])).to eq "Soep"
    end
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


  it "should accept class inheritance" do
    parse(%q{
      class Soep extends Bowl {
      }
    })
  end

  it "should accept class inheritance from a fully qualified class" do
    parse(%q{
      class Soep extends special.Bowl {
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

  it "should accept an abstract class" do
    parse(%q{
      abstract class Soep {
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
