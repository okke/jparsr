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

  it "should accept a while statement without any statement" do
    parse(%q{while(true);},:statement) do |tree|
      expect(tree[:while].has_key?(:expression)).to be true
      expect(tree[:while][:statement].has_key?(:empty)).to be true
    end
  end

  it "should accept a while statement with a statement" do
    parse(%q{while(true) break;},:statement) do |tree|
      expect(tree[:while].has_key?(:expression)).to be true
      expect(tree[:while][:statement].has_key?(:break)).to be true
    end
  end

  it "should accept a while statement with an empty block" do
    parse(%q{while(true) {}},:statement) do |tree|
      expect(tree[:while].has_key?(:expression)).to be true
      expect(tree[:while][:statement].has_key?(:block)).to be true
    end
  end

  it "should accept a while statement with a block of statements" do
    parse(%q{while(true) {a = 3; b = 5; }},:statement) do |tree|
      expect(tree[:while].has_key?(:expression)).to be true
      expect(tree[:while][:statement][:block][0].has_key?(:statement)).to be true
      expect(tree[:while][:statement][:block][1].has_key?(:statement)).to be true
    end
  end

  it "should accept a for statement without init, condition and update" do 
    parse(%q{for(;;) {}},:statement) do |tree|
      expect(tree.has_key?(:for)).to be true
      expect(tree[:for][:statement].has_key?(:block)).to be true
    end
  end

  it "should accept a for statement without init and update" do 
    parse(%q{for(;true;) {}},:statement) do |tree|
      expect(tree[:for].has_key?(:expression)).to be true
      expect(tree[:for][:statement].has_key?(:block)).to be true
    end
  end

  it "should accept a for statement without init or expression but with single update" do 
    parse(%q{for(;;a++) {}},:statement) do |tree|
      expect(tree[:for].has_key?(:update)).to be true
      expect(tree[:for][:statement].has_key?(:block)).to be true
    end
  end

  it "should accept a for statement without init or expression but with multiple updates" do 
    parse(%q{for(;;a++,b++) {}},:statement) do |tree|
      expect(tree[:for][:update][0].has_key?(:o)).to be true
      expect(tree[:for][:update][1].has_key?(:o)).to be true
      expect(tree[:for][:statement].has_key?(:block)).to be true
    end
  end

  it "should accept a for statement with a single init and no expression nor update" do
    parse(%q{for(a=3;;) {}},:statement) do |tree|
      expect(tree[:for].has_key?(:init)).to be true
      expect(tree[:for][:statement].has_key?(:block)).to be true
    end
  end

  it "should accept a for statement with a multiple inits and no expression nor update" do
    parse(%q{for(a=3,b=4;;) {}},:statement) do |tree|
      expect(tree[:for][:init][0].has_key?(:o)).to be true
      expect(tree[:for][:init][1].has_key?(:o)).to be true
      expect(tree[:for][:statement].has_key?(:block)).to be true
    end
  end

  it "should accept a for statement with a local var init and no expression nor update" do
    parse(%q{for(int a=3;;) {}},:statement) do |tree|
      expect(tree[:for][:init].has_key?(:class)).to be true
      expect(tree[:for][:statement].has_key?(:block)).to be true
    end
  end

  it "should accept an iterator style for statement" do
    parse(%q{for(Soup s : Soups) {}},:statement) do |tree|
      expect(tree[:for][:statement].has_key?(:block)).to be true
      expect(tree[:for][:iterable][:id]).to eq "Soups"
    end
  end

  it "should accept the most well known for statement" do
    parse(%q{for(int i=0;i<100;i++) {}},:statement) do |tree|
      expect(tree[:for].has_key?(:init)).to be true
      expect(tree[:for].has_key?(:expression)).to be true
      expect(tree[:for].has_key?(:update)).to be true
    end
  end

  it "should accept a for in a while" do
    parse(%q{while(true) for(;;) {}},:statement) do |tree|
      expect(tree[:while][:statement].has_key?(:for)).to be true
    end
  end

  it "should accept a while in a for" do
    parse(%q{for(;;) while(true) {}},:statement) do |tree|
      expect(tree[:for][:statement].has_key?(:while)).to be true
    end
  end

  it "should accept a for in a while" do
    parse(%q{while(true) for(;;) {}},:statement) do |tree|
      expect(tree[:while][:statement].has_key?(:for)).to be true
    end
  end

  it "should accept an if without stament" do
    parse(%q{if(true);},:statement) do |tree|
      expect(tree[:if].has_key?(:expression)).to be true
      expect(tree[:if][:true].has_key?(:empty)).to be true
    end
  end

  it "should accept an if with a statement" do
    parse(%q{if(true) return;},:statement) do |tree|
      expect(tree[:if].has_key?(:expression)).to be true
      expect(tree[:if][:true].has_key?(:return)).to be true
    end
  end

  it "should accept an if with a block" do
    parse(%q{if(true) {}},:statement) do |tree|
      expect(tree[:if].has_key?(:expression)).to be true
      expect(tree[:if][:true].has_key?(:block)).to be true
    end
  end

  it "should accept an if without stament and an else without statement" do
    parse(%q{if(true); else;},:statement) do |tree|
      expect(tree[:if][:true].has_key?(:empty)).to be true
      expect(tree[:if][:false].has_key?(:empty)).to be true
    end
  end

  it "should accept an if with a block and an else without statement" do
    parse(%q{if(true) {} else;},:statement) do |tree|
      expect(tree[:if][:true].has_key?(:block)).to be true
      expect(tree[:if][:false].has_key?(:empty)).to be true
    end
  end

  it "should accept an if withouth statement and an else with a block" do
    parse(%q{if(true); else {}},:statement) do |tree|
      expect(tree[:if][:true].has_key?(:empty)).to be true
      expect(tree[:if][:false].has_key?(:block)).to be true
    end
  end

  it "should accept an if with a block and an else with a block" do
    parse(%q{if(true) {} else {}},:statement) do |tree|
      expect(tree[:if][:true].has_key?(:block)).to be true
      expect(tree[:if][:false].has_key?(:block)).to be true
    end
  end

  it "should accept an if with an if" do
    parse(%q{if(true) if(false);},:statement) do |tree|
      expect(tree[:if][:true][:if][:true].has_key?(:empty)).to be true
    end
  end

  it "should accept an if with an if and an else" do
    parse(%q{if(true) if(false); else;},:statement) do |tree|
      expect(tree[:if][:true][:if][:true].has_key?(:empty)).to be true
      expect(tree[:if].has_key?(:false)).to be false
      expect(tree[:if][:true][:if][:false].has_key?(:empty)).to be true
    end
  end

  it "should accept an if with an if and an else" do
    parse(%q{if(true) ; else if(false);},:statement) do |tree|
      expect(tree[:if][:true].has_key?(:empty)).to be true
      expect(tree[:if][:false][:if][:true].has_key?(:empty)).to be true
    end
  end

  it "should accept a switch with a single empty case" do
    parse(%q{switch(soup) {
              case hot:
             }},:statement) do |tree|
      expect(tree[:switch].has_key?(:expression)).to be true
      expect(tree[:switch][:labels][0].has_key?(:expression)).to be true
    end
  end

  it "should accept a switch with a multiple empty cases" do
    parse(%q{switch(soup) {
              case hot:
              case cold:
             }},:statement) do |tree|
      expect(tree[:switch].has_key?(:expression)).to be true
      expect(tree[:switch][:labels][0].has_key?(:expression)).to be true
      expect(tree[:switch][:labels][1].has_key?(:expression)).to be true
    end
  end

  it "should accept a switch with an empty default" do
    parse(%q{switch(soup) {
              default:
             }},:statement) do |tree|
      expect(tree[:switch].has_key?(:expression)).to be true
      expect(tree[:switch][:labels][0].has_key?(:default)).to be true
    end
  end

  it "should accept a switch with an empty case and an empty default" do
    parse(%q{switch(soup) {
              case hot:
              default:
             }},:statement) do |tree|
      expect(tree[:switch].has_key?(:expression)).to be true
      expect(tree[:switch][:labels][0].has_key?(:expression)).to be true
      expect(tree[:switch][:labels][1].has_key?(:default)).to be true
    end
  end

  it "should accept a switch with a case with a single statement" do
    parse(%q{switch(soup) {
              case hot: freeze(20);
             }},:statement) do |tree|
      expect(tree[:switch].has_key?(:expression)).to be true
      expect(tree[:switch][:labels][0].has_key?(:expression)).to be true
      expect(tree[:switch][:labels][0][:statements][0].has_key?(:expression)).to be true
    end
  end

  it "should accept a switch with a case with a multiple statements" do
    parse(%q{switch(soup) {
              case hot: freeze(20); break;
             }},:statement) do |tree|
      expect(tree[:switch].has_key?(:expression)).to be true
      expect(tree[:switch][:labels][0].has_key?(:expression)).to be true
      expect(tree[:switch][:labels][0][:statements][0].has_key?(:expression)).to be true
      expect(tree[:switch][:labels][0][:statements][1].has_key?(:break)).to be true
    end
  end

  it "should accept a switch with a default with a multiple statements" do
    parse(%q{switch(soup) {
              default: freeze(20); break;
             }},:statement) do |tree|
      expect(tree[:switch].has_key?(:expression)).to be true
      expect(tree[:switch][:labels][0].has_key?(:default)).to be true
      expect(tree[:switch][:labels][0][:statements][0].has_key?(:expression)).to be true
      expect(tree[:switch][:labels][0][:statements][1].has_key?(:break)).to be true
    end
  end

  it "should accept a switch with a case followed by a block" do
    parse(%q{switch(soup) {
              case cold: {boil(20); break;}
             }},:statement) do |tree|
      expect(tree[:switch].has_key?(:expression)).to be true
      expect(tree[:switch][:labels][0].has_key?(:expression)).to be true
      expect(tree[:switch][:labels][0][:statements][0].has_key?(:block)).to be true
    end
  end


end
