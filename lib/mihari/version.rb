module Mihari
  begin
    require "git-version-bump"
    VERSION = GVB.version(false, true)
  rescue
    VERSION = "0.0.0"
  end
end
