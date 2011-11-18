module SilverOauth
  class FakeFile  #duck type
     def initialize(path, content)
       @content = content
       @path = path
     end

     def read
        @content
     end

     def close
         #nothing
     end

     def path
        #@path
       "button16.png"
     end
  end
end