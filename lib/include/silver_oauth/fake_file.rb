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
        @path
     end
  end
end