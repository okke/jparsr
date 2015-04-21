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

shared_examples :generics do

  it "should accept a generic class accepting one class parameter" do
    parse(%q{
      class Soep<MainIngredient> {
      }
    })
  end

  it "should accept a generic class accepting multiple class parameters" do
    parse(%q{
      class Soep<Stock, MainVegatable> {
      }
    })
  end

  it "should accept a generic class with parameters using the extend clause" do
    parse(%q{
      class Soep<Stock extends Food, MainVegatable extends Food> {
      }
    })
  end

  it "should accept a class exending a generic class" do
    parse(%q{
      class Soep extends LiquidVersionOf<Vegatable> {
      }
    })
  end

  it "should accept a class exending a generic class with multiple class parameters" do
    parse(%q{
      class Soep extends LiquidVersionOf<Vegatable, Meat> {
      }
    })
  end

  it "should accept a class implementing a generic interface" do
    parse(%q{
      class Soep implements LiquidVersionOf<Vegatable> {
      }
    })
  end

  it "should accept a class implementing a generic interface with multiple class parameters" do
    parse(%q{
      class Soep implements LiquidVersionOf<Vegatable, Meat> {
      }
    })
  end

  it "should accept a generic class as type for members" do
    parse(%q{
      class Soep {
        List<String> ingredients;
      }
    })
  end

  it "should accept a generic class as type for method parameters" do
    parse(%q{
      class Soep {
        public void use(List<String> ingredients) {
        }
      }
    })
  end

  it "should accept a generic class as type for method return values" do
    parse(%q{
      class Soep {
        public List<String> getIngredients() {

        }
      }
    })
  end

  it "should accept a generic method accepting one type parameter" do
    parse(%q{
      class Soep {
        public <T> void useIngredients(List<T> ingredients) {
        }
      }
    })
  end

  it "should accept a generic method accepting multiple type parameters" do
    parse(%q{
      class Soep {
        public <T,S> void useIngredients(List<T> ingredients) {
        }
      }
    })
  end

  it "should accept a generic method accepting type parameters with extend" do
    parse(%q{
      class Soep {
        public <T,S extends T> void useIngredients(List<T> ingredients) {
        }
      }
    })
  end

  it "should accept nested generics" do
    parse(%q{
      class Soep {
        List<List<String>> ingredients;  
      }
    })
  end

  it "should accept arrays within generic types" do
    parse(%q{
      class Soep {
        List<String[]> ingredients;  
      }
    })
  end
end
