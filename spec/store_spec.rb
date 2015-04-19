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

describe JParsr::Store do

  before(:each) do
    @store = JParsr::Store.new("jparsr_spec.store")
  end

  after(:each) do
    @store.destroy
  end

  it "should store and retrieve parsed source files" do
    transform(%q{
      public class Soup {
      }
    }) do |source|
      @store.write do |s|
        s.add_source("Soup.java", source)
      end
    end

    found = false
    @store.read do |s|
      s.get_source("Soup.java") do |source|
        found = true
        expect(source.classes[0].name).to eq "Soup"
      end
    end
    expect(found).to be true
  end

  it "should store and retrieve classes" do
    transform(%q{
      package special.kitchen;

      public class Soup {
      }
    }) do |source|
      @store.write do |s|
        s.add_source("Soup.java", source)
      end
    end

    found = false
    @store.read do |s|
      s.get_class("special.kitchen.Soup") do |clazz|
        found = true
        expect(clazz.name).to eq "Soup"
      end
    end
    expect(found).to be true
  end

end
