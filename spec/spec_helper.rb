require 'jparsr'
require 'pp'


def parse(s, rule=:root, debug=false, &block)
  begin
    result = JParsr::Grammar.new.send(rule).parse(s,reporter: Parslet::ErrorReporter::Deepest.new)
    if debug
      puts "PARSED(#{s})\n\nRESULT:\n"
      PP.pp(result.to_hash)
    end
    yield result if block_given?
    result.to_hash
  rescue Parslet::ParseFailed => failure
    puts failure.cause.ascii_tree if debug
    raise failure
  end
end
