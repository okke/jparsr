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

shared_examples :packages do

  it "should accept a package statement" do
    parse(%q{
      package soep;
    })
  end

  it "should accept a nested package statement" do
    parse(%q{
      package com.soep.bowl;
    })
  end

  it "should accept a class import" do
    parse(%q{
      import Bowl;
      class Soep {
      }
    })
  end

  it "should accept a fully qualified class import" do
    parse(%q{
      import com.soup.Bowl;
      class Soep {
      }
    })
  end

  it "should accept a wildcard package import" do
    parse(%q{
      import com.soup.*;
      class Soep {
      }
    })
  end

  it "should accept a static import" do
    parse(%q{
      import static com.soup.Bowl;
      class Soep {
      }
    })
  end

end
