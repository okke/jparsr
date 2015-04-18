require 'jparsr'
require 'pp'

def pretty_result(result)
  if result.respond_to?(:to_hash)
    return result.to_hash
  else 
    return result
  end
end

JAVA_GRAMMAR = JParsr::Grammar.new
JAVA_TRANSFORMER = JParsr::Transformer.new

def parse(s, rule=:root, debug=false, &block)
  begin
    result = JAVA_GRAMMAR.send(rule).parse(s,reporter: Parslet::ErrorReporter::Deepest.new)
    if debug
      puts "PARSED(#{s})\n\nRESULT:\n"
      PP.pp(pretty_result(result))
    end
    yield result if block_given?
    pretty_result(result)
  rescue Parslet::ParseFailed => failure
    puts failure.cause.ascii_tree if debug
    raise failure
  end
end

def transform(s, rule=:root, debug=false, &block)
  parse(s,rule,debug) do |tree| 
    result = JAVA_TRANSFORMER.apply(tree)
    if debug
      puts "TRANSFORMED INTO:\n\n"
      PP.pp(result)
    end
    yield result if block_given?
    result
  end
end

def find(tree,sym)
  if sym.is_a?(Array)
    found = find(tree,sym[0])
    return found if sym.size == 1 or found == nil
    find(found,sym.slice(1..-1))
  else
    return tree[sym] if tree.has_key?(sym)
    tree.each do |k,v|
      return find(v,sym) if v.is_a?(Hash)
      if v.is_a?(Array)
        v.each do |v_in|
          found = find(v_in, sym)
          return found if found != nil
        end
      end
    end
    nil
  end
end
