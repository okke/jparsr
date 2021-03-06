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

shared_examples :transform_generic_types do

  it "should transform a class parameter" do
    transform(%q{class Recipy<Soup> {
    }},:class_declaration) do |object|
      expect(object.is_a? JParsr::Class).to be true
      expect(object.name).to eq "Recipy"
      expect(object.parameters[0].name).to eq "Soup"
    end
  end

  it "should transform a class parameter extending a type" do
    transform(%q{class Recipy<Soup extends Food, Bread> {
    }},:class_declaration) do |object|
      expect(object.is_a? JParsr::Class).to be true
      expect(object.name).to eq "Recipy"
      expect(object.parameters[0].extends[0].id).to eq "Food"
    end
  end

  it "should transform a class parameter extending a type" do
    transform(%q{class Recipy<Soup extends Food & Liquid> {
    }},:class_declaration) do |object|
      expect(object.is_a? JParsr::Class).to be true
      expect(object.name).to eq "Recipy"
      expect(object.parameters[0].extends[0].id).to eq "Food"
      expect(object.parameters[0].extends[1].id).to eq "Liquid"
    end
  end

  it "should transform a multiple class parameters" do
    transform(%q{class Recipy<Soup, MainIngredient> {
    }},:class_declaration) do |object|
      expect(object.is_a? JParsr::Class).to be true
      expect(object.name).to eq "Recipy"
      expect(object.parameters.map{|p| p.name}).to eq ["Soup", "MainIngredient"]
    end
  end

end
