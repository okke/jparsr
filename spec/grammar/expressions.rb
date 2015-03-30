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

end
