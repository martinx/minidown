module Minidown
  module Utils
    Regexp = {
      lines: /\n|\r\n/,
      blank_line: /\A\s*\z/,
      h1_or_h2: /\A([=-]{3,})(.*)/,
      start_with_shape: /\A(\#{1,6})\s*(.+?)\s*#*\z/,
    }
  end
end