#TODO
#temparay workarund to supress some warnings, this hsould be fixed with Rack 1.3
module Rack
  module Utils
    def escape(s)
      EscapeUtils.escape_url(s)
    end
  end
end