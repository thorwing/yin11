class PageRenderer
  attr_reader :revision
  def revision=(r)
    @revision = r
  end

  def initialize(revision = nil)
    self.revision = revision
  end

end