require 'jparsr'
require 'pp'

def pretty_result(result)
  if result.respond_to?(:to_hash)
    return result.to_hash
  else 
    return result
  end
end

def parse(s, rule=:root, debug=false, &block)
  begin
    result = JParsr::Grammar.new.send(rule).parse(s,reporter: Parslet::ErrorReporter::Deepest.new)
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
