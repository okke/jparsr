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

shared_examples :annotations do

  it "accept an annotation without parameters" do
    parse("@Soup",:annotation) do |tree|
      expect(tree[:id].str).to eq "Soup"
    end
  end

  it "accept a plain annotation with zero parameters" do
    parse("@Soup()",:annotation) do |tree|
      expect(tree[:id].str).to eq "Soup"
    end
  end

  it "accept a plain annotation with one unnamed parameter" do
    parse("@Soup(Hot)",:annotation) do |tree|
      expect(tree[:id].str).to eq "Soup"
      expect(tree[:arguments][:id]).to eq "Hot"
    end
  end

  it "accept a plain annotation with multiple unnamed parameter" do
    parse("@Soup(Hot,Spicey)",:annotation) do |tree|
      expect(tree[:id].str).to eq "Soup"
      expect(tree[:arguments][0][:id]).to eq "Hot"
      expect(tree[:arguments][1][:id]).to eq "Spicey"
    end
  end

  it "accept a plain annotation with one named parameter" do
    parse("@Soup(temperature=Hot)",:annotation) do |tree|
      expect(tree[:id].str).to eq "Soup"
      expect(tree[:arguments][:o].has_key?(:assign_to)).to be true
    end
  end

  it "accept a plain annotation with multiple named parameter" do
    parse(%q{@Soup(temperature=Hot,name="Mighty Tomato")},:annotation) do |tree|
      expect(tree[:id].str).to eq "Soup"
      expect(tree[:arguments][0][:o].has_key?(:assign_to)).to be true
      expect(tree[:arguments][1][:o].has_key?(:assign_to)).to be true
    end
  end

  it "accept an annotation before a class" do
    parse(%q{
      @Hot
      class Soup {
      }
    })
  end

  it "accept multiple annotations before a class" do
    parse(%q{
      @Spicey(pepper=Peppers.MAX)
      @Hot("like steaming hot")
      class Soup {
      }
    })
  end

  it "should accept a single annotation before a field member" do
    parse(%q{
      class Soup {
        @Temperature int i;
      }
    })
  end

  it "should accept multiple annotations before a field member" do
    parse(%q{
      class Soup {
        @Temperature @AsHotAsPossible int i;
      }
    })
  end

  it "should accept a single annotation before a method" do
    parse(%q{
      class Soup {
        @Temperature public int get() {
        }
      }
    })
  end

  it "should accept multiple annotations before a method" do
    parse(%q{
      class Soup {
        @Temperature @AsHotAsPossible public int get() {
        }
      }
    })
  end

  it "should accept a single annotation before a constructor" do
    parse(%q{
      class Soup {
        @Temperature public Soup() {
        }
      }
    })
  end

  it "should accept multiple annotations before a constructor" do
    parse(%q{
      class Soup {
        @Temperature @AsHotAsPossible public Soup() {
        }
      }
    })
  end

  it "should accept a single annotation before a method argument definition" do
    parse(%q{
      class Soup {
        public void boil(@Temperature int t) {
        }
      }
    })
  end

  it "should accept a multiple annotations before a method argument definition" do
    parse(%q{
      class Soup {
        public void boil(@Temperature @Max(99) int t) {
        }
      }
    })
  end

  it "should accept a annotations before a all method argument definitions" do
    parse(%q{
      class Soup {
        public void boil(@Temperature @Max(99) int t, @How @Recipy("cookbook") int h) {
        }
      }
    })
  end

  it "should accept an annotation before a local variable" do
    parse(%q{
      class Soup {
        public void boil() {
          @Temperature int max;
        }
      }
    })
  end

  it "should accept multiple annotations before a local variable" do
    parse(%q{
      class Soup {
        public void boil() {
          @Temperature @Max(99) int max;
        }
      }
    })
  end

end

