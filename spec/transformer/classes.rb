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

shared_examples :transform_classes do

  it "should transform an empty class into a Class object" do
    transform(%q{class Soup {
    }},:class_declaration) do |object|
      expect(object.is_a? JParsr::Class).to be true
      expect(object.name).to eq "Soup"
    end
  end

  it "should transform class modifiers" do
    transform(%q{public class Soup {
    }},:class_declaration) do |object|
      expect(object.public?).to be true
      expect(object.visibility).to eq :public
    end
    transform(%q{private class Soup {
    }},:class_declaration) do |object|
      expect(object.private?).to be true
      expect(object.visibility).to eq :private
    end
    transform(%q{protected class Soup {
    }},:class_declaration) do |object|
      expect(object.protected?).to be true
      expect(object.visibility).to eq :protected
    end
    transform(%q{abstract class Soup {
    }},:class_declaration) do |object|
      expect(object.abstract?).to be true
    end
    transform(%q{public abstract class Soup {
    }},:class_declaration) do |object|
      expect(object.abstract?).to be true
      expect(object.public?).to be true
    end
    transform(%q{final class Soup {
    }},:class_declaration) do |object|
      expect(object.final?).to be true
    end
    transform(%q{private final class Soup {
    }},:class_declaration) do |object|
      expect(object.final?).to be true
      expect(object.private?).to be true
    end
    transform(%q{static class Soup {
    }},:class_declaration) do |object|
      expect(object.static?).to be true
    end
  end

  it "should build unresolved reference to super class" do
    transform(%q{class Soup extends Food {
    }},:class_declaration) do |object|
      expect(object.unresolved_super_class).to eq "Food"
    end
    transform(%q{class Soup extends special.kitchen.Food {
    }},:class_declaration) do |object|
      expect(object.unresolved_super_class).to eq "special.kitchen.Food"
    end
  end

  it "should build unresolved references to interfaces" do
    transform(%q{class Soup implements Food {
    }},:class_declaration) do |object|
      expect(object.unresolved_interfaces).to eq ["Food"]
    end
    transform(%q{class Soup implements special.kitchen.Food {
    }},:class_declaration) do |object|
      expect(object.unresolved_interfaces).to eq ["special.kitchen.Food"]
    end

    transform(%q{class Soup implements Food,Boilable {
    }},:class_declaration) do |object|
      expect(object.unresolved_interfaces).to eq ["Food","Boilable"]
    end
  end

end
