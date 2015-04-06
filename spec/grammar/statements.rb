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
    parse(%q{return;},:statement) do |tree|
      expect(tree.has_key?(:return)).to be true
    end
  end

  it "should accept a return expression statement" do
    parse(%q{return "hot";},:statement) do |tree|
      expect(tree[:return][:expression][:string]).to eq "\"hot\""
    end
  end

  it "should accept a throw expression statement" do
    parse(%q{throw new SoupToHotException();},:statement) do |tree|
      expect(tree[:throw][:expression].has_key?(:new)).to be true
    end
  end

  it "should accept a synchronized statement" do
    parse(%q{synchronized(soup) {}},:statement) do |tree|
      expect(tree[:synchronized][:expression][:id]).to eq "soup"
    end
  end

  it "should accept a synchronized statement within a synchronized statement" do
    parse(%q{synchronized("hot") {
              synchronized("soep") {
              }
             }},:statement) do |tree|

      expect(tree[:synchronized][:block][0][:statement].has_key?(:synchronized)).to be true
    end
  end

  it "should accept an assignment as statement" do
    parse(%q{until = max_temperature;},:statement) do |tree|
      expect(tree[:expression][:o].has_key?(:assign_to)).to be true
    end
  end

  it "should accept a pre increment as statement" do
    parse(%q{++temperature;},:statement) do |tree|
      expect(tree[:expression][:o].has_key?(:add_add)).to be true
    end
  end

  it "should accept a pre decrement as statement" do
    parse(%q{--temperature;},:statement) do |tree|
      expect(tree[:expression][:o].has_key?(:minus_minus)).to be true
    end
  end

  it "should accept a post increment as statement" do
    parse(%q{temperature++;},:statement) do |tree|
      expect(tree[:expression][:o].has_key?(:add_add)).to be true
    end
  end

  it "should accept a post decrement as statement" do
    parse(%q{temperature--;},:statement) do |tree|
      expect(tree[:expression][:o].has_key?(:minus_minus)).to be true
    end
  end

  it "should accept a method invocation as statement" do
    parse(%q{andWaitFor(180);},:statement) do |tree|
      expect(tree[:expression][:id]).to eq "andWaitFor"
    end
  end

  it "should accept a instance creation as statement" do
    parse(%q{new Stove();},:statement) do |tree|
      expect(tree[:expression].has_key?(:new)).to be true
    end
  end

  it "should accept a try catch as statement" do
    parse(%q{try {
          } catch(SoupToHotException e) {
          }
        },:statement) do |tree|
      expect(tree[:try].has_key?(:block)).to be true
      expect(tree[:try][:catch][0].has_key?(:block)).to be true
    end
  end

  it "should accept a try catch with multiple catches as statement" do
    parse(%q{try {
          } catch(SoupToHotException e) {
            return false;
          }
          catch(StoveOutOfOrderException e) {
          }
        },:statement) do |tree|
      expect(tree[:try].has_key?(:block)).to be true
      expect(tree[:try][:catch][0].has_key?(:block)).to be true
      expect(tree[:try][:catch][1].has_key?(:block)).to be true
    end
  end

  it "should accept a try with a finally clause as statement" do
    parse(%q{try {
          } finally {
          }
        },:statement) do |tree|
      expect(tree[:try].has_key?(:block)).to be true
      expect(tree[:try][:finally].has_key?(:block)).to be true
    end
  end

  it "should accept a try-catch with a finally clause as statement" do
    parse(%q{try {
          } catch(SoupToHotException e) {
          } finally {
          }
        },:statement) do |tree|
      expect(tree[:try].has_key?(:block)).to be true
      expect(tree[:try][:catch][0].has_key?(:block)).to be true
      expect(tree[:try][:finally].has_key?(:block)).to be true
    end
  end

  it "should accept a try catch finally with multiple catches as statement" do
    parse(%q{try {
          } catch(SoupToHotException e) {
          }
          catch(StoveOutOfOrderException e) {
          } finally {
          }
        },:statement) do |tree|
      expect(tree[:try].has_key?(:block)).to be true
      expect(tree[:try][:catch][0].has_key?(:block)).to be true
      expect(tree[:try][:catch][1].has_key?(:block)).to be true
      expect(tree[:try][:finally].has_key?(:block)).to be true
    end
  end

  it "should accept an empty statement" do
    parse(%q{;},:statement) do |tree|
      expect(tree.has_key?(:empty)).to be true
    end
  end

  it "should accept a labeled statement" do
    parse(%q{start: temperature = 30;},:statement) do |tree|
      expect(tree[:label]).to eq "start"
    end
  end

  it "should accept a break statement" do
    parse(%q{break;},:statement) do |tree|
      expect(tree.has_key?(:break)).to be true
    end
  end

  it "should accept a labeled break statement" do
    parse(%q{break start;},:statement) do |tree|
      expect(tree[:break][:label]).to eq "start"
    end
  end

  it "should accept a continue statement" do
    parse(%q{continue;},:statement) do |tree|
      expect(tree.has_key?(:continue)).to be true
    end
  end

  it "should accept a labeled continue statement" do
    parse(%q{continue start;},:statement) do |tree|
      expect(tree[:continue][:label]).to eq "start"
    end
  end

  it "should accept a do while statement" do
    parse(%q{do i--; while (i > 0);},:statement) do |tree|
      expect(tree[:do].has_key?(:statement)).to be true
      expect(tree[:do].has_key?(:expression)).to be true
    end
  end

  it "should accept a do while statement with a block" do
    parse(%q{do {
          } while (i > 0);
        },:statement) do |tree|
      expect(tree[:do][:statement].has_key?(:block)).to be true
      expect(tree[:do].has_key?(:expression)).to be true
    end
  end

end
