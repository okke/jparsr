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


require 'parslet'

module JParsr 

  class Grammar < Parslet::Parser
    rule(:space)       { match["\s\n\r"].repeat }
    rule(:space?)      { space.maybe }
    rule(:skip)        { space? }

    rule(:dot)         { str('.') >> skip}
    rule(:semicolon)   { str(';') >> skip}
    rule(:lcurly)      { str('{') >> skip}
    rule(:rcurly)      { str('}') >> skip}
    rule(:lparen)      { str('(') >> skip}
    rule(:rparen)      { str(')') >> skip}
    rule(:star)        { str('*') >> skip}
    rule(:comma)       { str(',') >> skip}
    rule(:assign)      { str('=') >> skip}

    rule(:package_kw)  { str('package') >> skip }
    rule(:public_kw)   { str('public') >> skip }
    rule(:private_kw)  { str('private') >> skip }
    rule(:protected_kw){ str('protected') >> skip }
    rule(:transient_kw){ str('transient') >> skip }
    rule(:volatile_kw) { str('volatile') >> skip }
    rule(:final_kw)    { str('final') >> skip }
    rule(:abstract_kw) { str('abstract') >> skip }
    rule(:class_kw)    { str('class') >> skip }
    rule(:import_kw)   { str('import') >> skip }
    rule(:static_kw)   { str('static') >> skip }
    rule(:extends_kw)  { str('extends') >> skip }
    rule(:implements_kw)  { str('implements') >> skip }
    rule(:int_kw)      { str('int') >> skip }
    rule(:boolean_kw)  { str('boolean') >> skip }
    rule(:byte_kw)     { str('byte') >> skip }
    rule(:short_kw)    { str('short') >> skip }
    rule(:long_kw)     { str('long') >> skip }
    rule(:char_kw)     { str('char') >> skip }
    rule(:float_kw)    { str('float') >> skip }
    rule(:double_kw)   { str('double') >> skip }
    rule(:true_kw)     { str('true') >> skip }
    rule(:false_kw)    { str('false') >> skip }
    rule(:null_kw)     { str('null') >> skip }
    rule(:return_kw)   { str('return') >> skip }

    rule(:id)          { match('[a-zA-Z0-9_]').repeat(1) >> skip}

    # TODO this also matches hexadecimal floating points
    #
    rule(:numeric_literal) { 
      str('0x').maybe >> 
      str('0X').maybe >> 
      match('[0-9]').repeat >> 
      (str('.') >> match('[0-9]').repeat).maybe >> 
      (match('[eE]') >> match('[+-]').maybe >> match('[0-9]').repeat).maybe >> 
      match('[lLdDfF]').maybe >> 
      skip
    }

    rule(:boolean_literal) { (true_kw | false_kw) }

    rule(:s_quote)      { str('"') }
    rule(:c_quote)    { str("'") }
    rule(:s_nonquote)   { str('"').absnt? >> any }
    rule(:c_nonquote) { str("'").absnt? >> any }
    rule(:escape)     { str('\\') >> any }
    rule(:string_literal) { s_quote >> (escape | s_nonquote).repeat >> s_quote }
    rule(:char_literal) { c_quote >> (escape | c_nonquote) >> c_quote }

    rule(:package_name) { id >> (dot >> id).repeat.maybe }

    rule(:type_name)   { id }

    rule(:expression) do
      (null_kw | string_literal | char_literal | boolean_literal | numeric_literal)
    end

    rule(:package_declaration) do
      package_kw >>
      package_name >>
      semicolon >> 
      skip
    end

    # TODO, current import allows multiple '*'s in declaration
    #
    rule(:import_declaration) do
      import_kw >>
      static_kw.maybe >>
      (id >> (dot >> (star | id)).repeat.maybe) >>
      semicolon >> 
      skip
    end

    rule(:class_modifier) do
      (public_kw | final_kw | abstract_kw).repeat
    end

    rule(:extends) do
      extends_kw >>
      type_name
    end

    rule(:implements) do
      implements_kw >>
      type_name >> (comma >> type_name).repeat.maybe
    end

    rule(:primitive_type) do
      (boolean_kw | byte_kw | short_kw | int_kw | long_kw | char_kw | float_kw | double_kw)
    end

    rule(:type) do
      (primitive_type | type_name)
    end

    rule(:member_modifier) do
      (public_kw | private_kw | protected_kw | static_kw | final_kw | transient_kw | volatile_kw)
    end 

    rule(:field_names) do
      id >> (comma >> id).repeat.maybe
    end

    rule(:field_initializer) do
      assign >> expression
    end

    rule(:method_parameters) do
      type >> id >> (comma >> method_parameters).maybe
    end

    rule(:local_variable) do
      type >> 
      field_names >>
      field_initializer.maybe
    end

    rule(:return_statement) do
      return_kw >> expression.maybe
    end

    rule(:statement) do
      return_statement
    end

    rule(:block) do
      lcurly >> 
      ((local_variable | statement) >> semicolon).repeat.maybe >>
      rcurly
    end

    rule(:method_declaration) do
      lparen >> 
      method_parameters.maybe >>
      rparen >> 
      block >>
      semicolon.maybe
    end

    # TODO can parse multiple method names
    #
    rule(:member_declaration) do
      member_modifier.repeat.maybe >> 
      type >> 
      field_names >> 
      (method_declaration | (field_initializer.maybe >> semicolon))
    end

    rule(:static_block) do
      static_kw >> block
    end

    rule(:class_body_declaration) do
      (member_declaration | static_block) >> skip
    end

    rule(:class_declaration) do
      class_modifier.maybe >>
      class_kw >>
      type_name >>
      extends.maybe >>
      implements.maybe >>
      lcurly >>
      class_body_declaration.repeat.maybe >>
      rcurly >>
      skip
    end

    rule(:source_file) do
      skip >>
      package_declaration.maybe >>
      import_declaration.maybe >>
      class_declaration.repeat.maybe
    end

    root :source_file
  end
end
