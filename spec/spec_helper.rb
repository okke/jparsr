require 'jparsr'

def parse(s)
  begin
    JParsr::Grammar.new.parse(s)
  rescue Parslet::ParseFailed => failure
    puts failure.cause.ascii_tree
    raise failure
  end
end
