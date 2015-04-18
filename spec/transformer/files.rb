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

shared_examples :transform_files do

  it "should transform an empty file into a SourceFile object" do
    transform(%q{
    }) do |object|
      expect(object.is_a? JParsr::SourceFile).to be true
    end
  end

  it "should transform file within a package to a Package object" do
    transform(%q{
      package special.soup.ingredients;
    }) do |object|
      expect(object.package.is_a? JParsr::Package).to be true
      expect(object.package.name).to eq "special.soup.ingredients"
    end
  end

  it "should build an Import object for a import statement" do
    transform(%q{
      import special.Soup;
    }) do |object|
      expect(object.imports[0].name).to eq "special.Soup"
    end
  end

  it "should build an Import object for every import statement" do
    transform(%q{
      import Bowl;
      import special.Soup;
    }) do |object|
      expect(object.imports[0].name).to eq "Bowl"
      expect(object.imports[1].name).to eq "special.Soup"
    end
  end

  it "should build mark static imports" do
    transform(%q{
      import static Bowl;
      import Spoon;
    }) do |object|
      expect(object.imports[0].name).to eq "Bowl"
      expect(object.imports[0].static?).to be true
      expect(object.imports[1].name).to eq "Spoon"
      expect(object.imports[1].static?).to be false
    end
  end

  it "should build mark wild card imports" do
    transform(%q{
      import special.ingredients.*;
      import special.ingredients;
    }) do |object|
      expect(object.imports[0].name).to eq "special.ingredients"
      expect(object.imports[0].all?).to be true
      expect(object.imports[1].name).to eq "special.ingredients"
      expect(object.imports[1].all?).to be false
    end
  end

  it "should build list of declared classes with one class" do
    transform(%q{
    public class Soup {
    }
    }) do |object|
      expect(object.classes.size).to eq 1
    end
  end

  it "should build list of declared classes with multiple classes" do
    transform(%q{
    public class Soup { }
    public class Bowl { }
    }) do |object|
      expect(object.classes.size).to eq 2
    end
  end


end
