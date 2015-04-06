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

shared_examples :statements do

  it "should accept a return statement" do
    parse(%q{
      class Soep {
        void boil() {
          return;
        }
      }
    })
  end

  it "should accept a return expression statement" do
    parse(%q{
      class Soep {
        String boil() {
          return "hot";
        }
      }
    })
  end

  it "should accept a synchronized statement" do
    parse(%q{
      class Soep {
        String boil() {
          synchronized("soep") {
          }
        }
      }
    })
  end

  it "should accept a synchronized statement within a synchronized statement" do
    parse(%q{
      class Soep {
        String boil() {
          synchronized("hot") {
            synchronized("soep") {
            }
          }
        }
      }
    })
  end

  it "should accept an assignment as statement" do
    parse(%q{
      class Soep {
        String boil() {
          until = max_temperature;
          start_at = 30;
        }
      }
    })
  end

  it "should accept a post/pre increment/decrement  as statement" do
    parse(%q{
      class Soep {
        String boil() {
          ++temperature;
          temperature++;
          --temperature;
          temperature--;
        }
      }
    })
  end

  it "should accept a method invocation as statement" do
    parse(%q{
      class Soep {
        String boil() {
          stove.on();
          lightFire();
          andWaitFor(180 /* seconds */);
          stove.off();
        }
      }
    })
  end

end
