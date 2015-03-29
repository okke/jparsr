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

    rule(:line_comment) { str('//') >> (match["\n"].absnt? >> any).repeat}
    rule(:block_comment){ str('/*') >> (str('*/').absnt? >> any).repeat >> str('*/')} 


    rule(:comment) do
      (line_comment | block_comment)
    end

    rule(:skip)        { space? >> (comment >> skip).maybe >> space?}

    rule(:dot)         { str('.') >> skip}
    rule(:semicolon)   { str(';') >> skip}
    rule(:lcurly)      { str('{') >> skip}
    rule(:rcurly)      { str('}') >> skip}
    rule(:lparen)      { str('(') >> skip}
    rule(:rparen)      { str(')') >> skip}
    rule(:lbracket)    { str('[') >> skip}
    rule(:rbracket)    { str(']') >> skip}
    rule(:star)        { str('*') >> skip}
    rule(:comma)       { str(',') >> skip}
    rule(:assign)      { str('=') >> skip}
    rule(:lt)          { str('<') >> skip}
    rule(:gt)          { str('>') >> skip}

    
    def self.define_keywords(words)
      words.each do |kw|
        rule((kw.to_s + "_kw").to_sym) { str(kw.to_s) >> skip }
      end
      rule(:keyword) { match(words.map {|w| w.to_s}.join("|")) >> skip }
    end


    define_keywords([
     :abstract,
     :boolean,
     :byte,
     :char,
     :class,
     :double,
     :enum,
     :extends,
     :false,
     :final,
     :float,
     :implements,
     :import,
     :int,
     :interface,
     :long,
     :null,
     :package, 
     :private,
     :protected,
     :public,
     :return,
     :short,
     :static,
     :synchronized,
     :transient,
     :true,
     :volatile
    ])

    rule(:id)          { keyword.absnt? >> match('[a-zA-Z_]') >> match('[a-zA-Z0-9_]').repeat.maybe >> skip}

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


    rule(:class_parameter) do
      type >> (extends_kw >> type_name).maybe >> (comma >> class_parameter).maybe
    end

    # TODO generic type is been used for rela types and for class declaration
    # so now it may parse class A<B<C>> {} which is not correct.
    #
    rule(:generic_type) do
      lt >>
      class_parameter >>
      gt
    end

    rule(:type_name)   do 
      id >>
      generic_type.maybe
    end

    rule(:expression) do
      (id | 
       null_kw         |
       string_literal  |
       char_literal    |
       boolean_literal |
       numeric_literal
      )
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

    rule(:type_modifier) do
      (public_kw | final_kw | abstract_kw).repeat
    end

    rule(:extends) do
      extends_kw >>
      type_name
    end

    rule(:extends_multiple) do
      extends_kw >>
      type_name >> (comma >> type_name).repeat.maybe
    end

    rule(:implements) do
      implements_kw >>
      type_name >> (comma >> type_name).repeat.maybe
    end

    rule(:primitive_type) do
      (boolean_kw | byte_kw | short_kw | int_kw | long_kw | char_kw | float_kw | double_kw)
    end

    rule(:array) do
      (lbracket >> rbracket).repeat
    end

    rule(:type) do
      (primitive_type | type_name) >> array.maybe
    end

    rule(:member_modifier) do
      (public_kw    |
       private_kw   |
       protected_kw |
       static_kw    |
       final_kw     |
       transient_kw |
       volatile_kw  |
       abstract_kw  |
       synchronized_kw)
    end 

    rule(:field_names) do
      array.maybe >> id >> (comma >> array.maybe >> id).repeat.maybe
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
      return_kw >> expression.maybe.as(:expression)
    end

    rule(:synchronized_statement) do
      synchronized_kw >> lparen >> expression >> rparen >> block
    end

    rule(:statement) do
      (synchronized_statement | return_statement)
    end

    # TODO semicolon should not be optional
    #
    rule(:block) do
      lcurly >> 
      ((local_variable.as(:variable) | statement.as(:statement)) >> semicolon.maybe).repeat.maybe >>
      rcurly
    end

    rule(:method_declaration) do
      lparen >> 
      method_parameters.maybe >>
      rparen >> 
      block.maybe >>
      semicolon.maybe
    end

    # TODO can parse multiple method names
    #
    rule(:member_field_or_method_declaration) do
      field_names >> 
      (method_declaration | (field_initializer.maybe >> semicolon))
    end

    rule(:member_declaration) do
      member_modifier.repeat.maybe >> 
      generic_type.maybe >>
      type >> 
      ( 
        method_declaration | # constructor
        member_field_or_method_declaration
      )
    end

    rule(:static_block) do
      static_kw >> block
    end

    rule(:class_body_declaration) do
      (member_declaration | static_block) >> skip
    end

    rule(:enum_constant) do
      id >> (lparen >> expression >> rparen).maybe
    end

    rule(:enum_constants) do
      enum_constant >> (comma >> enum_constant).repeat.maybe
    end

    rule(:class_declaration) do
      class_kw >>
      type_name >>
      extends.maybe >>
      implements.maybe >>
      lcurly >>
      class_body_declaration.repeat.maybe >>
      rcurly >>
      skip
    end

    # TODO: give interfaces their own body grammar
    #
    rule(:interface_declaration) do
      interface_kw >>
      type_name >>
      extends_multiple.maybe >>
      lcurly >>
      class_body_declaration.repeat.maybe >>
      rcurly >>
      skip
    end

    rule(:enum_declaration) do
      enum_kw >>
      type_name >>
      implements.maybe >>
      lcurly >>
      enum_constants.maybe >>
      (semicolon >> class_body_declaration.repeat.maybe).maybe >>
      rcurly >>
      skip
    end

    rule(:type_declaration) do
      type_modifier.maybe >>
      (class_declaration | interface_declaration | enum_declaration)
    end

    rule(:source_file) do
      skip >>
      package_declaration.maybe.as(:package) >>
      import_declaration.maybe.as(:imports) >>
      type_declaration.repeat.maybe.as(:types)
    end

    root :source_file
  end
end
