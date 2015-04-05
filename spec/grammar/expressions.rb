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

shared_examples :expressions do

  it "should accept a literal integer as expression" do
    parse("33",:expression)
  end

  it "should accept a string as expression" do
    parse('"soup"',:expression)
  end

  it "should accept an identifier as expression" do
    parse('soup',:expression)
  end

  it "should accept a qualified identifier as expression" do
    tree = parse('hot.soup',:expression)
    expect(tree[:l][:id].str).to eq "hot"
    expect(tree[:r][:id].str).to eq "soup"
  end

  it "should accept a multiple qualifiers in expression" do
    tree = parse('very.hot.soup',:expression)
    expect(tree[:l][:l][:id].str).to eq "very"
    expect(tree[:l][:r][:id].str).to eq "hot"
    expect(tree[:r][:id].str).to eq "soup"
  end

  it "should accept a multiplicative '*' expression" do
    tree = parse('3*5',:expression)
    expect(tree[:l][:number].str).to eq "3"
    expect(tree[:o].has_key?(:multiply)).to be true
    expect(tree[:r][:number].str).to eq "5"
  end

  it "should accept a multiplicative '/' expression" do
    tree = parse('10/2',:expression)
    expect(tree[:l][:number].str).to eq "10"
    expect(tree[:o].has_key?(:divide)).to be true
    expect(tree[:r][:number].str).to eq "2"
  end

  it "should accept a multiplicative '%' expression" do
    tree = parse('10 % 2',:expression)
    expect(tree[:l][:number].str).to eq "10"
    expect(tree[:o].has_key?(:modulo)).to be true
    expect(tree[:r][:number].str).to eq "2"
  end

  it "should accept an additive '+' expression" do
    tree = parse('8 + 4',:expression)
    expect(tree[:l][:number].str).to eq "8"
    expect(tree[:o].has_key?(:add)).to be true
    expect(tree[:r][:number].str).to eq "4"
  end

  it "should accept an additive '-' expression" do
    tree = parse('8 - 4',:expression)
    expect(tree[:l][:number].str).to eq "8"
    expect(tree[:o].has_key?(:minus)).to be true
    expect(tree[:r][:number].str).to eq "4"
  end

  it "should apply a higher precedence for multplicative operators than for additive operators" do
    tree = parse('1 + 2 * 3',:expression)
    expect(tree[:o].has_key?(:add)).to be true
    expect(tree[:r][:o].has_key?(:multiply)).to be true

    tree = parse('1 * 2 + 3',:expression)
    expect(tree[:l][:o].has_key?(:multiply)).to be true
    expect(tree[:o].has_key?(:add)).to be true
  end

  it "should accept an shift left  expression" do
    tree = parse('8 << 1',:expression)
    expect(tree[:l][:number].str).to eq "8"
    expect(tree[:o].has_key?(:shift_left)).to be true
    expect(tree[:r][:number].str).to eq "1"
  end

  it "should accept an shift right  expression" do
    tree = parse('8 >> 1',:expression)
    expect(tree[:l][:number].str).to eq "8"
    expect(tree[:o].has_key?(:shift_right)).to be true
    expect(tree[:r][:number].str).to eq "1"
  end

  it "should accept an unsigned shift right expression" do
    tree = parse('8 >>> 1',:expression)
    expect(tree[:l][:number].str).to eq "8"
    expect(tree[:o].has_key?(:u_shift_right)).to be true
    expect(tree[:r][:number].str).to eq "1"
  end

  it "should apply a higher precedence for additive operators than for shift operators" do
    tree = parse('1 << 2 + 3',:expression)
    expect(tree[:o].has_key?(:shift_left)).to be true
    expect(tree[:r][:o].has_key?(:add)).to be true

    tree = parse('1 - 2 >> 3',:expression)
    expect(tree[:l][:o].has_key?(:minus)).to be true
    expect(tree[:o].has_key?(:shift_right)).to be true
  end

  it "should accept a relational '<' expression" do
    tree = parse('41 < 42',:expression)
    expect(tree[:o].has_key?(:lt)).to be true
  end

  it "should accept a relational '<=' expression" do
    tree = parse('41 <= 42',:expression)
    expect(tree[:o].has_key?(:lte)).to be true
  end

  it "should accept a relational '>' expression" do
    tree = parse('41 > 42',:expression)
    expect(tree[:o].has_key?(:gt)).to be true
  end

  it "should accept a relational '>=' expression" do
    tree = parse('41 >= 42',:expression)
    expect(tree[:o].has_key?(:gte)).to be true
  end

  it "should accept a relational instanceof expression" do
    tree = parse('soep instanceof Food',:expression)
    expect(tree[:o].has_key?(:instanceof)).to be true
  end

  it "should apply a higher precedence for shift operators than for relational operators" do
    tree = parse('1 < 2 << 3',:expression)
    expect(tree[:o].has_key?(:lt)).to be true
    expect(tree[:r][:o].has_key?(:shift_left)).to be true

    tree = parse('1 >> 2 > 3',:expression)
    expect(tree[:l][:o].has_key?(:shift_right)).to be true
    expect(tree[:o].has_key?(:gt)).to be true
  end

  it "should accept a equality '==' expression" do
    tree = parse('41 == 42',:expression)
    expect(tree[:o].has_key?(:eq)).to be true
  end

  it "should accept a equality '!=' expression" do
    tree = parse('41 != 42',:expression)
    expect(tree[:o].has_key?(:ne)).to be true
  end

  it "should apply a higher precedence for relational operators than for equality operators" do
    tree = parse('1 == 2 < 3',:expression)
    expect(tree[:o].has_key?(:eq)).to be true
    expect(tree[:r][:o].has_key?(:lt)).to be true

    tree = parse('1 > 2 != 3',:expression)
    expect(tree[:l][:o].has_key?(:gt)).to be true
    expect(tree[:o].has_key?(:ne)).to be true
  end

  it "should accept a bitwise '&' expression" do
    tree = parse('41 & 42',:expression)
    expect(tree[:o].has_key?(:bw_and)).to be true
  end

  it "should apply a higher precedence for equality operators than for a bitwise and" do
    tree = parse('1 & 2 == 3',:expression)
    expect(tree[:o].has_key?(:bw_and)).to be true
    expect(tree[:r][:o].has_key?(:eq)).to be true

    tree = parse('1 != 2 & 3',:expression)
    expect(tree[:l][:o].has_key?(:ne)).to be true
    expect(tree[:o].has_key?(:bw_and)).to be true
  end

  it "should accept a bitwise '^' expression" do
    tree = parse('41 ^ 42',:expression)
    expect(tree[:o].has_key?(:bw_xor)).to be true
  end

  it "should apply a higher precedence for a bitwise and than a bitwise xor" do
    tree = parse('1 ^ 2 & 3',:expression)
    expect(tree[:o].has_key?(:bw_xor)).to be true
    expect(tree[:r][:o].has_key?(:bw_and)).to be true

    tree = parse('1 & 2 ^ 3',:expression)
    expect(tree[:l][:o].has_key?(:bw_and)).to be true
    expect(tree[:o].has_key?(:bw_xor)).to be true
  end

  it "should accept a bitwise '|' expression" do
    tree = parse('41 | 42',:expression)
    expect(tree[:o].has_key?(:bw_or)).to be true
  end

  it "should apply a higher precedence for a bitwise xor than a bitwise or" do
    tree = parse('1 | 2 ^ 3',:expression)
    expect(tree[:o].has_key?(:bw_or)).to be true
    expect(tree[:r][:o].has_key?(:bw_xor)).to be true

    tree = parse('1 ^ 2 | 3',:expression)
    expect(tree[:l][:o].has_key?(:bw_xor)).to be true
    expect(tree[:o].has_key?(:bw_or)).to be true
  end

  it "should accept a conditional '&&' expression" do
    tree = parse('true && false',:expression)
    expect(tree[:o].has_key?(:and)).to be true
  end

  it "should apply a higher precedence for a bitwise or than a conditional and" do
    tree = parse('1 && 2 | 3',:expression)
    expect(tree[:o].has_key?(:and)).to be true
    expect(tree[:r][:o].has_key?(:bw_or)).to be true

    tree = parse('1 | 2 && 3',:expression)
    expect(tree[:l][:o].has_key?(:bw_or)).to be true
    expect(tree[:o].has_key?(:and)).to be true
  end

  it "should accept a conditional '||' expression" do
    tree = parse('true || false',:expression)
    expect(tree[:o].has_key?(:or)).to be true
  end

  it "should apply a higher precedence for a conditional and than a conditional or" do
    tree = parse('1 || 2 && 3',:expression)
    expect(tree[:o].has_key?(:or)).to be true
    expect(tree[:r][:o].has_key?(:and)).to be true

    tree = parse('1 && 2 || 3',:expression)
    expect(tree[:l][:o].has_key?(:and)).to be true
    expect(tree[:o].has_key?(:or)).to be true
  end

  it "should accept a conditional '?' expression" do
    tree = parse('false ? true : false',:expression)
    expect(tree[:cnd][:boolean].has_key?(:false)).to be true
    expect(tree[:true][:boolean].has_key?(:true)).to be true
    expect(tree[:false][:boolean].has_key?(:false)).to be true
  end

  it "should apply a higher precendence for a conditional or than a conditional '?' expression" do
    tree = parse('true || false ? true : false',:expression)
    expect(tree[:cnd][:o].has_key?(:or)).to be true

    tree = parse('false ? true : false || true',:expression)
    expect(tree[:false][:o].has_key?(:or)).to be true
  end

  it "should accept an assignment expression" do
    {'=' =>  :assign_to,
     '+=' => :add_assign_to,
     '-=' => :minus_assign_to,
     '*=' => :multiply_assign_to,
     '/=' => :divide_assign_to,
     '%=' => :modulo_assign_to,
     '&=' => :bw_and_assign_to,
     '^=' => :bw_xor_assign_to,
     '|=' => :bw_or_assign_to,
     '<<=' => :shift_left_assign_to,
     '>>=' => :shift_right_assign_to,
     '>>>=' => :u_shift_right_assign_to}.each do |k,v|

      tree = parse("a#{k}b",:expression)
      expect(tree[:o].has_key?(v)).to be true
     end
  end


  it "should accept a multi field '=' assignment expression" do
    tree = parse('a.b = c',:expression)
    expect(tree[:o].has_key?(:assign_to)).to be true
  end

  it "should accept an array '=' assignment expression" do
    tree = parse('a.b[3] = c',:expression)
    expect(tree[:o].has_key?(:assign_to)).to be true
  end

  it "should accept an multi array '=' assignment expression" do
    tree = parse('a.b[3][4] = c',:expression)
    expect(tree[:o].has_key?(:assign_to)).to be true
  end

  it "should accept a multi array in combination with field access '=' assignment expression" do
    tree = parse('a.b[3][4].d[5] = c',:expression)
    expect(tree[:o].has_key?(:assign_to)).to be true
  end

  it "should accept a parenthesized expressions" do
    tree = parse('(1+2)',:expression)
    expect(tree[:o].has_key?(:add)).to be true
  end

  it "should accept a parenthesized expression within an expression" do
    tree = parse('(1 + 2 ) * 3',:expression)
    expect(tree[:o].has_key?(:multiply)).to be true
    expect(tree[:l][:o].has_key?(:add)).to be true
  end

  it "should accept a method invocation without arguments as an expression" do
    tree = parse('boil()',:expression)
  end

  it "should accept a method invocation with one argument as an expression" do
    tree = parse('boil(95)',:expression)
  end

  it "should accept a method invocation with muitple arguments as an expression" do
    tree = parse('boil(95,"salt")',:expression)
  end

  it "should accept a method invocation on an object with muitple arguments contaning complex expressions as an expression" do
    tree = parse('this.use("stock").boil((c * 1.8f)+32,"salt")',:expression)
  end

  it "should accept a method invocation on an array element as an expression" do
    tree = parse('soups[3].boil()',:expression)
  end

  it "should accept a postfix add expression" do
    parse('a++',:expression) do |tree|
      expect(tree[:o].has_key?(:add_add)).to be true
    end
  end

  it "should accept a postfix minus expression" do
    parse('a--',:expression) do |tree|
      expect(tree[:o].has_key?(:minus_minus)).to be true
    end
  end

  it "should accept a postfix add expression inside an expression without spaces" do
    parse('a+++3',:expression) do |tree|
      expect(tree[:o].has_key?(:add)).to be true
      expect(tree[:l][:o].has_key?(:add_add)).to be true
    end
  end

  it "should accept a postfix minus expression inside an expression without spaces" do
    parse('a---3',:expression) do |tree|
      expect(tree[:o].has_key?(:minus)).to be true
      expect(tree[:l][:o].has_key?(:minus_minus)).to be true
    end
  end

  it "should accept unary add assignment expression" do
    parse('++a',:expression) do |tree|
      expect(tree[:o].has_key?(:add_add)).to be true
    end
  end

  it "should accept unary add expression" do
    # will not fail because empty is a valid expression due to
    # current number rule
    #
    parse('+a',:expression) do |tree|
      expect(tree[:o].has_key?(:add)).to be true
    end
  end


  it "should accept unary minus asignment expression" do
    parse('--a',:expression) do |tree|
      expect(tree[:o].has_key?(:minus_minus)).to be true
    end
  end

  it "should accept unary minus expression" do
    # will not fail because empty is a valid expression due to
    # current number rule
    #
    parse('-a',:expression) do |tree|
      expect(tree[:o].has_key?(:minus)).to be true
    end
  end

  it "should accept a postfix add and an unary add assignment inside an expression" do
    parse('a++ + ++a',:expression) do |tree|
      expect(tree[:o].has_key?(:add)).to be true
      expect(tree[:l][:o].has_key?(:add_add)).to be true
      expect(tree[:r][:o].has_key?(:add_add)).to be true
    end
  end

  it "should accept a postfix add, a regular add and an unary add assignment inside an expression" do
    parse('a+++ ++a',:expression) do |tree|
      expect(tree[:o].has_key?(:add)).to be true
      expect(tree[:l][:o].has_key?(:add_add)).to be true
      expect(tree[:r][:o].has_key?(:add_add)).to be true
    end
  end

  it "should accept unary not expression" do
    parse('!true',:expression) do |tree|
      expect(tree[:o].has_key?(:not)).to be true
    end
  end

  it "should accept unary bitwise complement expression" do
    parse('~x',:expression) do |tree|
      expect(tree[:o].has_key?(:bw_complement)).to be true
    end
  end

  it "should accept a cast to class expression" do
    parse('(Object)j',:expression) do |tree|
      expect(tree[:o][:cast]).to eq "Object"
    end
  end

  it "should accept a cast to primitive expression" do
    parse('(int)j',:expression) do |tree|
      expect(tree[:o][:cast]).to eq "int"
    end
  end

  it "should accept a cast folowed by a  parenthesized  expression" do
    parse('(float)(3+4)',:expression) do |tree|
      expect(tree[:o][:cast]).to eq "float"
    end
  end

  it "should accept a new operator as expression" do
    parse('new Object()',:expression) do |tree|
      expect(tree.has_key?(:new)).to be true
    end
  end

  it "should accept a new operator with arguments as expression" do
    parse('new Soup(new Stock("chicken"))',:expression) do |tree|
      expect(tree.has_key?(:new)).to be true
    end
  end

  it "should accept the creation of an anonymous class as expression" do
    parse('new Soup() {}',:expression) do |tree|
      expect(tree.has_key?(:new)).to be true
      expect(tree[:new][:type]).to eq "Soup"
      expect(tree[:new].has_key?(:block)).to be true
    end
  end

  it "should accept the creation of an anonymous class with methods as expression" do
    parse(%q{this.eat(new Soup() {
        public void boil(int temperature) {
        }
      })
    },:expression)
  end

end
