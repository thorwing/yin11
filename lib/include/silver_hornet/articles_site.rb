class SilverHornet::ArticlesSite < SilverHornet::Site
  attr_accessor :recursive, :recursive_pages

  def fetch_a
    if skipped.present? && skipped == true
      log "#{name} is skipped"
      return
    end

    agent = Mechanize.new
    begin
      self.entries.each do |entry_url|
        pages_count = 0
        next_link = nil
        begin
          next_link.nil? ? agent.get(entry_url) : agent.click(next_link)
          pages_count += 1
          process_page(agent)

          next_link = agent.page.link_with(:text => I18n.t("fetch_sites.normal_next_page"))

          ##for foodmate
          #if next_link.nil? && self.name == I18n.t("fetch_sites.foodmate")
          #  agent.page.links.each do |l|
          #    if l.attributes['title'] ==  I18n.t("fetch_sites.normal_next_page")
          #      next_link = l
          #      break
          #    end
          #  end
          #end
          log "Got #{count.to_s} articles on #{name}: #{agent.page.uri.to_s}"
        end while (recursive.present? && recursive == true) and pages_count < recursive_pages and next_link
      end
    rescue Exception => exc
      log exc.message
      log exc.backtrace
    end
  end

  def process_page(agent)
    log "Now dealing with #{name}: #{agent.page.uri.to_s}, see #{agent.page.search("#{elements["listed_article"]} a").size.to_s} articles."
    agent.page.search(elements["listed_article"]).each do |item|
      link = item.at_css('a')
      #there must be a link
      next unless link
      href = link.attributes['href']
      time_str = item.at_css(elements["listed_article_time"]).try(:content)
      agent.get(href)
      title = agent.page.at(elements["article_title"]).try(:content)
      content = agent.page.at(elements["article_content"]).try(:content)
      url = agent.page.uri

      source_element = agent.page.at(elements["article_source"]) if elements["article_source"].present?
      source_name = source_element ? source_element.content : ""

      generate_article(title, time_str, content, source_name, url)
    end
  end

  def generate_article(title, time_str, content, source_name, url)
    time = DateTime.parse(time_str)
    title.try(:strip!) #gsub(/^\s+/,"").gsub(/\s+$/,"").gsub(/\r/,"").gsub(/\n/,"")
    part = I18n.t("fetch_sites.normal_source_prefix")
    source_name.scan(/#{part}(.+)\s*/) do
      source_name = $1
    end
    source_name.gsub!(/[:#{I18n.t("fetch_sites.cn_colon")}]/, '')
    source_name = source_name.strip.split(" ").first

    article = Article.find_or_initialize_by(title: title)

    #title is mandatory
    if article.new_record? && title.present?
      article.content = content.try(:html_safe)
      article.reported_on = time
      article.enabled = false
      article.tags = InfoItem.tags.inject([]){|memo, e| title.include?(e) ? (memo << e) : memo }
      article.type = I18n.t("article_types.news")
      article.build_source
      article.source.name = source_name.present? ? source_name : "Unknown Media"
      article.source.site = self.name
      article.source.url = url.to_s
    end

    if article.new_record?
      if article.valid?
        article.save!
        self.count += 1
        log "#{article.title} -> #{article.reported_on_string} from #{article.source.name if article.source.present?}"
      else
        log "*** invalid #{article.errors.to_s} of #{url.to_s}"
      end
    else
      log "Already have: " + title
    end
  end

  def log(msg)
    p msg
    Rails.logger.info msg
  end
end
