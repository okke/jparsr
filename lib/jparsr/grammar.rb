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


require 'jparsr/parslet_ext'

module JParsr 

  class Grammar < Parslet::Parser

    @@keywords = {}

    rule(:space)       { match[" \t\n\r"].repeat }
    rule(:space?)      { space.maybe }

    rule(:line_comment) { str('//') >> (match["\n"].absnt? >> any).repeat}
    rule(:block_comment){ str('/*') >> (str('*/').absnt? >> any).repeat >> str('*/')} 


    rule(:comment) do
      (line_comment | block_comment)
    end

    rule(:skip)        { space? >> (comment >> skip).maybe >> space?}

    rule(:dot)         { str('.') >> str('.').absnt? >> skip}
    rule(:dotdotdot)   { str('...') >> skip}
    rule(:semicolon)   { str(';') >> skip}
    rule(:colon)       { str(':') >> skip}
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
    rule(:at)          { str('@') >> skip}
    rule(:and_sign)    { str('&') >> skip}

    rule(:multiply_op)    { (str('*') >> str('=').absnt?).as(:multiply) >> skip}
    rule(:divide_op)      { (str('/') >> str('=').absnt?).as(:divide) >> skip}
    rule(:modulo_op)      { (str('%') >> str('=').absnt?).as(:modulo) >> skip}
    rule(:add_op)         { (str('+') >> match('[+=]').absnt?).as(:add) >> skip}
    rule(:minus_op)       { (str('-') >> match('[-=]').absnt?).as(:minus) >> skip}
    rule(:shift_left_op)  { (str('<<') >> str('=').absnt?).as(:shift_left) >> skip}
    rule(:u_shift_right_op) { (str('>>>') >> str('=').absnt?).as(:u_shift_right) >> skip}
    rule(:shift_right_op) { (str('>>') >> match('[>=]').absnt?).as(:shift_right) >> skip}

    rule(:multiply_assign_op)  { str('*=').as(:multiply_assign_to) >> skip}
    rule(:divide_assign_op)  { str('/=').as(:divide_assign_to) >> skip}
    rule(:modulo_assign_op)  { str('%=').as(:modulo_assign_to) >> skip}
    rule(:add_assign_op)  { str('+=').as(:add_assign_to) >> skip}
    rule(:minus_assign_op)  { str('-=').as(:minus_assign_to) >> skip}
    rule(:shift_left_assign_op)  { str('<<=').as(:shift_left_assign_to) >> skip}
    rule(:shift_right_assign_op)  { str('>>=').as(:shift_right_assign_to) >> skip}
    rule(:u_shift_right_assign_op)  { str('>>>=').as(:u_shift_right_assign_to) >> skip}
    rule(:bw_and_assign_op) { str('&=').as(:bw_and_assign_to) >> skip}
    rule(:bw_xor_assign_op) { str('^=').as(:bw_xor_assign_to) >> skip}
    rule(:bw_or_assign_op)  { str('|=').as(:bw_or_assign_to) >> skip}

    rule(:assign_op)      { str('=').as(:assign_to) >> skip}

    rule(:lt_op)          { (str('<') >> match('[<=]').absnt?).as(:lt) >> skip}
    rule(:lte_op)         { str('<=').as(:lte) >> skip}
    rule(:gt_op)          { (str('>') >> match('[>=]').absnt?).as(:gt) >> skip}
    rule(:gte_op)         { str('>=').as(:gte) >> skip}
    rule(:instanceof_op)  { instanceof_kw.as(:instanceof) >> skip}
    rule(:eq_op)          { str('==').as(:eq) >> skip}
    rule(:ne_op)          { str('!=').as(:ne) >> skip}
    rule(:bw_and_op)      { (str('&') >> match('[&=]').absnt?).as(:bw_and) >> skip}
    rule(:bw_xor_op)      { (str('^') >> str('=').absnt?).as(:bw_xor) >> skip}
    rule(:bw_or_op)       { (str('|') >> match('[|=]').absnt?).as(:bw_or) >> skip}
    rule(:and_op)         { str('&&').as(:and) >> skip}
    rule(:or_op)          { str('||').as(:or) >> skip}
    rule(:if_op)          { str('?') >> skip}
    rule(:else_op)        { str(':') >> skip}

    rule(:add_add_op)     { str('++').as(:add_add) >> skip}
    rule(:minus_minus_op) { str('--').as(:minus_minus) >> skip}

    rule(:not_op)         { (str('!') >> str('=').absnt?).as(:not) >> skip}
    rule(:bw_complement_op) { str('~').as(:bw_complement) >> skip}

    
    def self.define_keywords(words)
      words.each do |kw|
        rule((kw.to_s + "_kw").to_sym) { str(kw.to_s) >> skip }
        @@keywords[kw.to_s] = true
      end
    end


    define_keywords([
     :abstract,
     :boolean,
     :break,
     :byte,
     :case,
     :catch,
     :char,
     :class,
     :continue,
     :default,
     :double,
     :do,
     :else,
     :enum,
     :extends,
     :false,
     :finally,
     :final,
     :float,
     :for,
     :if,
     :implements,
     :import,
     :instanceof,
     :int,
     :interface,
     :long,
     :new,
     :null,
     :package, 
     :private,
     :protected,
     :public,
     :return,
     :short,
     :static,
     :synchronized,
     :switch,
     :throw,
     :throws,
     :transient,
     :try,
     :true,
     :volatile,
     :while
    ])

    rule(:id_chars)    { match('[a-zA-Z_]') >> match('[a-zA-Z0-9_]').repeat.maybe }

    rule(:id)          {
      id_chars.not_in(@@keywords,"keywords") >> skip.skip
    }

    rule(:numeric_part) {
      ( match('[0-9]').repeat(1) >> (str('.') >> match('[0-9]').repeat(1)).maybe ) |
      ( str('.') >> match('[0-9]').repeat(1) )
    }

    # TODO this also matches hexadecimal floating points
    # TODO this will match an empty string
    #
    rule(:numeric_literal) { 
      (str('0x').maybe >> 
      str('0X').maybe >> 
      numeric_part >>
      (match('[eE]') >> match('[+-]').maybe >> match('[0-9]').repeat).maybe >> 
      match('[lLdDfF]').maybe).as(:number).capture(:parsed_number) >> 
      skip
    }

    rule(:boolean_literal) { (true_kw.as(:true) | false_kw.as(:false)) }

    rule(:s_quote)      { str('"') }
    rule(:c_quote)    { str("'") }
    rule(:s_nonquote)   { str('"').absnt? >> any }
    rule(:c_nonquote) { str("'").absnt? >> any }
    rule(:escape)     { str('\\') >> any }
    rule(:string_literal) { s_quote >> (escape | s_nonquote).repeat >> s_quote >> skip}
    rule(:char_literal) { c_quote >> (escape | c_nonquote) >> c_quote >> skip}

    rule(:package_name) { id.as(:id) >> (dot >> id.as(:id)).repeat.maybe }

    rule(:class_parameter) do
      type >> (extends_kw >> type_name >> (and_sign >> type_name ).repeat).as(:extends).maybe 
    end

    rule(:class_parameters) do
      class_parameter.as(:parameter) >> (comma >> class_parameter.as(:parameter)).repeat
    end

    rule(:annotation) do
      at >> id.as(:id) >>
      (lparen >> arguments.as(:arguments).maybe >> rparen).maybe
    end

    rule(:annotations) do
      annotation.as(:annotation).repeat(1).as(:annotations)
    end

    # TODO generic type is been used for rela types and for class declaration
    # so now it may parse class A<B<C>> {} which is not correct.
    #
    rule(:generic_type) do
      lt >>
      class_parameters.as(:class) >>
      gt
    end

    rule(:type_name)   do 
      id.as(:id) >> (dot >> id.as(:id)).repeat >>
      generic_type.as(:generic).maybe
    end

    rule(:arguments) do
      expression >> (comma >> expression).repeat.maybe
    end

    rule(:array_argument) do
      (array_initializer | expression)
    end

    rule(:array_arguments) do
      array_argument >> (comma >> array_argument).repeat.maybe
    end

    rule(:array_initializer) do
      (lcurly >> array_arguments.as(:arguments).maybe >> rcurly)
    end

    rule(:instance_creation_expression) do
      new_kw >> 
      type >> 
      (lparen >> arguments.as(:arguments).maybe >> rparen >>
      class_block.as(:block).maybe).maybe >>
      array_initializer.maybe
    end

    rule(:term) do
      (instance_creation_expression.as(:new)     |
       (lparen >> expression >> rparen) |
       class_kw.as(:id)                 |
       id.as(:id)                       | 
       null_kw.as(:null)                |
       string_literal.as(:string)       |
       char_literal.as(:char)           |
       boolean_literal.as(:boolean)     |
       numeric_literal              
      ) >> 
      (lparen >> arguments.as(:arguments).maybe >> rparen).maybe >>
      (lbracket >> expression.as(:index) >> rbracket).repeat.maybe
    end

    rule(:postfix_expression) do
     term >> (add_add_op | minus_minus_op).as(:o).maybe
    end

    rule(:unary_expression) do
      (( add_add_op     |
         add_op         |
         minus_minus_op |
         minus_op       |
         not_op         |
         bw_complement_op).as(:o) >> postfix_expression.as(:r)) |
      postfix_expression 
    end

    rule(:cast_expression) do
      (lparen >> type.as(:cast) >> rparen >> unary_expression) |
      unary_expression
    end

    rule(:infix_j_expression) do
      infix_expression(cast_expression, 
        [dot, 99, :left],
        [(multiply_op | divide_op | modulo_op), 98, :left],
        [(add_op | minus_op), 97, :left],
        [(shift_left_op | shift_right_op | u_shift_right_op), 96, :left],
        [(lt_op | lte_op | gt_op | gte_op | instanceof_op), 95, :left],
        [(eq_op | ne_op), 94, :left],
        [bw_and_op, 93, :left],
        [bw_xor_op, 92, :left],
        [bw_or_op, 91, :left],
        [and_op, 90, :left],
        [or_op, 89, :left]) | cast_expression
    end


    rule(:cnd_if_expression) do
      (infix_j_expression.as(:cnd) >> 
       if_op >> 
       infix_j_expression.as(:true) >> 
       else_op >> 
       infix_j_expression.as(:false)) | infix_j_expression
    end

    rule(:assignment_expression) do
      (cnd_if_expression.as(:l) >> 
       (assign_op               |
        add_assign_op           | 
        minus_assign_op         |
        multiply_assign_op      |
        divide_assign_op        |
        modulo_assign_op        |
        shift_left_assign_op    |
        shift_right_assign_op   |
        u_shift_right_assign_op |
        bw_and_assign_op        |
        bw_xor_assign_op        |
        bw_or_assign_op).as(:o) >> 
       assignment_expression.as(:r) ) | cnd_if_expression
    end


    rule(:expression) do
      assignment_expression
    end

    rule(:package_declaration) do
      package_kw >>
      package_name >>
      semicolon >> 
      skip
    end

    rule(:import_declaration) do
      import_kw >>
      static_kw.as(:static).maybe >>
      (id.as(:id) >> (dot >> id.as(:id)).repeat).as(:import) >> (dot >> star.as(:all)).maybe >>
      semicolon >> 
      skip
    end

    rule(:type_modifier) do
      (public_kw.as(:public)     | 
       final_kw.as(:final)       |
       abstract_kw.as(:abstract) | 
       static_kw.as(:static)     | 
       private_kw.as(:private)   | 
       protected_kw.as(:protected)).repeat
    end

    rule(:extends) do
      extends_kw >>
      type_name.as(:class)
    end

    rule(:extends_multiple) do
      extends_kw >>
      type_name.as(:class) >> (comma >> type_name.as(:class)).repeat.maybe
    end

    rule(:implements) do
      implements_kw >>
      type_name.as(:class) >> (comma >> type_name.as(:class)).repeat.maybe
    end

    rule(:primitive_type) do
      (boolean_kw | byte_kw | short_kw | int_kw | long_kw | char_kw | float_kw | double_kw).as(:id)
    end

    # TODO: size is not part of type (but is used with the new array[x] 
    # construction
    #
    rule(:array) do
      (lbracket >> numeric_literal.as(:size).maybe >> rbracket).repeat(1)
    end

    rule(:type) do
      (primitive_type | type_name).as(:class) >> array.as(:array).maybe
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

    rule(:field_name) do
      array.maybe >> id >> array.maybe
    end

    rule(:field_names) do
      field_name >> (comma >> field_name).repeat.maybe
    end

    rule(:field_initializer) do
      assign >> (array_initializer | expression)
    end

    rule(:method_parameter) do
      final_kw.maybe >> annotations.maybe >> final_kw.maybe >> type >> dotdotdot.as(:variable).maybe >> field_name
    end

    rule(:method_parameters) do
      method_parameter >> (comma >> method_parameter).repeat
    end

    rule(:local_variable) do
      annotations.maybe >>
      type >> 
      (field_names >> field_initializer.maybe) >>
      (comma >> field_names >> field_initializer.maybe).repeat
    end

    rule(:return_statement) do
      return_kw >> expression.maybe.as(:expression)
    end

    rule(:throw_statement) do
      throw_kw >> expression.maybe.as(:expression)
    end

    rule(:synchronized_statement) do
      synchronized_kw >> lparen >> expression.as(:expression) >> rparen >> block.as(:block)
    end

    rule(:catch_clause) do
      (catch_kw >> lparen >> type >> id >> rparen >> block.as(:block)).repeat(1)
    end

    rule(:finally_clause) do
      finally_kw >> block.as(:block)
    end

    rule(:try_statement) do
      try_kw >>
      block.as(:block) >> 
      ((catch_clause.as(:catch).maybe >> finally_clause.as(:finally).maybe) || finally_clause.as(:finally))
    end

    rule(:break_statement) do
      break_kw >> id.as(:label).maybe
    end

    rule(:continue_statement) do
      continue_kw >> id.as(:label).maybe
    end

    rule(:do_statement) do
      do_kw >> 
      statement.as(:statement) >> 
      while_kw >> 
      lparen >> expression.as(:expression) >> rparen
    end

    rule(:while_statement) do
      while_kw >> lparen >> expression.as(:expression) >> rparen >>
      statement.as(:statement)
    end

    rule(:for_iterator) do
      ( 
        semicolon >>
        expression.as(:expression).maybe >>
        semicolon >> arguments.as(:update).maybe
      ) |
      ( colon >> expression.as(:iterable) )
    end

    rule(:for_statement) do
      for_kw >> lparen >>
      (local_variable | arguments).as(:init).maybe >>
      for_iterator >>
      rparen >> 
      statement.as(:statement)
    end

    rule(:if_statement) do
      if_kw >> lparen >> expression.as(:expression) >> rparen >> 
      statement.as(:true) >>
      (else_kw >> statement.as(:false)).maybe
    end

    rule(:switch_statements) do
      statement.repeat
    end

    rule(:switch_labels) do
      ( (( case_kw >> expression >> colon).as(:expression) |
        ( default_kw >> colon).as(:default)) >> 
        switch_statements.as(:statements)).repeat
    end

    rule(:switch_statement) do
      switch_kw >> lparen >> expression.as(:expression) >> rparen >> 
      lcurly >>
      switch_labels.as(:labels).maybe >>
      rcurly
    end

    rule(:statement) do
      (id.as(:label) >> colon).maybe >>
      ( synchronized_statement.as(:synchronized)            | 
       (return_statement.as(:return) >> semicolon)          |
       (throw_statement.as(:throw) >> semicolon)            |
       (try_statement.as(:try))                             |
       (assignment_expression.as(:expression) >> semicolon) |
       (break_statement.as(:break) >> semicolon)            |
       (continue_statement.as(:continue) >> semicolon)      |
       (do_statement.as(:do) >> semicolon)                  |
       (while_statement.as(:while))                         |
       (for_statement.as(:for))                             |
       (if_statement.as(:if))                               |
       (switch_statement.as(:switch))                       |
       block.as(:block)                                     |
       semicolon.as(:empty)
       )
    end

    # TODO semicolon should not be optional
    #
    rule(:block) do
      lcurly >> 
      ((local_variable.as(:variable) >> semicolon) | statement.as(:statement)).repeat.maybe >>
      rcurly
    end

    rule(:method_throws) do
      throws_kw >> type.as(:type) >> (comma >> type.as(:type)).repeat
    end

    rule(:method_declaration) do
      lparen >> 
      method_parameters.as(:parameters).maybe >>
      rparen >> 
      (default_kw >> expression).maybe >>
      method_throws.as(:throws).maybe >>
      block.as(:block).maybe >>
      semicolon.maybe
    end

    # TODO can parse multiple method names
    #
    rule(:member_field_or_method_declaration) do
      field_names.as(:name) >> 
      (method_declaration.as(:method) | (field_initializer.as(:initializer).maybe >> semicolon.maybe)) >>
      (comma >> member_field_or_method_declaration.as(:member)).maybe
    end

    rule(:member_declaration) do
      annotations.maybe >>
      member_modifier.as(:modifier).repeat.maybe >> 
      generic_type.as(:generic).maybe >>
      type.as(:type) >> 
      ( 
        method_declaration.as(:constructor) | # constructor
        member_field_or_method_declaration.as(:member) 
      )
    end

    rule(:static_block) do
      static_kw >> block
    end

    rule(:class_body_declaration) do
      (type_declaration.as(:inner) | member_declaration.as(:member) | static_block) >> skip
    end

    rule(:enum_constant) do
      id >> (lparen >> expression >> rparen).maybe
    end

    rule(:enum_constants) do
      enum_constant >> (comma >> enum_constant).repeat.maybe
    end

    rule(:class_block) do
      lcurly >>
      class_body_declaration.as(:class_body_declaration).repeat.maybe >>
      rcurly
    end

    rule(:pre_type_declaration) do
      annotations.as(:annotations).maybe >>
      type_modifier.as(:modifiers).maybe
    end

    rule(:class_declaration) do
      pre_type_declaration >>
      class_kw >>
      type_name.as(:name) >>
      extends.as(:extends).maybe >>
      implements.as(:implements).maybe >>
      class_block.as(:block) >>
      skip
    end

    # TODO: give interfaces their own body grammar
    #
    rule(:interface_declaration) do
      pre_type_declaration >>
      at.as(:is_annotation).maybe >> interface_kw >>
      type_name.as(:name) >>
      extends_multiple.as(:extends).maybe >>
      class_block.as(:block) >>
      skip
    end

    rule(:enum_declaration) do
      pre_type_declaration >>
      enum_kw >>
      type_name.as(:name) >>
      implements.as(:implements).maybe >>
      lcurly >>
      enum_constants.maybe >>
      (semicolon >> class_body_declaration.as(:class_body_declaration).repeat.maybe).maybe >>
      rcurly >>
      skip
    end

    rule(:type_declaration) do
      (class_declaration.as(:class)         | 
       interface_declaration.as(:interface) |
       enum_declaration.as(:enum))
    end

    rule(:source_file) do
      skip >>
      package_declaration.maybe.as(:package) >>
      import_declaration.repeat.as(:imports) >>
      type_declaration.repeat.maybe.as(:types)
    end

    root :source_file
  end
end
