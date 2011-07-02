#encoding utf-8

namespace :yin11 do
  class Site
    attr_accessor :name, :url_list, :count
    def initialize(site_name, url_list)
      self.count = 0
      self.name = site_name
      self.url_list = url_list.uniq
    end

    def generate_article(title, time_str, content, source_name, url)
      time = DateTime.parse(time_str)
      title.strip! #gsub(/^\s+/,"").gsub(/\s+$/,"").gsub(/\r/,"").gsub(/\n/,"")
      part = I18n.t("fetch_sites.normal_source_prefix")
      source_name.scan(/#{part}(.+)\s*/) do
        source_name = $1
      end
      source_name = source_name.delete(":", I18n.t("fetch_sites.cn_colon")).strip
      puts title + " -> " + time.strftime('%m/%d/%Y') + " from " + source_name

      article = Article.first(conditions: {title: title})
      if article
        self.log "Already have: " + title
        return
      end

      tags = InfoItem.tags.inject([]){|memo, e| title.include?(e) ? (memo << e) : memo }

      article = Article.new(title: title) do |a|
        a.content = content.html_safe
        a.reported_on = time
        #a.disabled = true
        a.tags = tags
        a.build_source
        a.source.name = source_name.present? || "Unknown Media"
        a.source.site = self.name
        a.source.url = url.to_s
      end
      if article.valid?
        article.save
        self.count += 1
      else
        p "*** invalid" + article.errors.to_s
        p url.to_s
      end
    end

    def log(msg)
      makeup_msg = "*** " + msg + " *** " + self.name
      p makeup_msg
      Rails.logger.info makeup_msg
    end
  end

  desc "create some testing articles"
  task :fetch_articles => :environment do
    deal_techfood(true, 10)
    deal_21food(true, 10)
    deal_southcn
    deal_xinhuanet
    deal_foodmate(true, 10)
  end

  def deal_site(name, url_list, go_next_page, go_pages)
    begin
      site = Site.new(name, url_list)
      site.url_list.each do |gate_page_url|
        agent = Mechanize.new
        pages_count = 0
        next_link = nil
        begin
          next_link.nil? ? agent.get(gate_page_url) : agent.click(next_link)
          p agent.page.uri.to_s
          pages_count += 1
          yield site, agent

          next_link = agent.page.link_with(:text => I18n.t("fetch_sites.normal_next_page"))

          #for foodmate
          if next_link.nil? && site.name == I18n.t("fetch_sites.foodmate")
            agent.page.links.each do |l|
              if l.attributes['title'] ==  I18n.t("fetch_sites.normal_next_page")
                next_link = l
                break
              end
            end
          end

        end while go_next_page and pages_count < go_pages and next_link
      end
    rescue Exception => exc
      site.log exc.message
      p exc.backtrace
    ensure
      site.log "Got " + site.count.to_s + " articles."
    end
  end

  #中国食品科技网
  def deal_techfood(go_next_page = false, go_pages = 999)
    deal_site(I18n.t("fetch_sites.techfood"), ["http://www.tech-food.com/news/rule/list.html"], go_next_page, go_pages) do |site, agent|
      site.log "See " + agent.page.search(".newsmore_title3").size.to_s + " articles."
      agent.page.search(".newsmore_title3").each do |item|
        link = item.at_css('a')
        next unless link
        href = link.attributes['href']
        time_str = item.at_css('i').content
        agent.get(href)
        title = agent.page.at(".biaoti1").content
        content = agent.page.at("#zoom").content
        url = agent.page.uri

        source_element = agent.page.at("div.dibu_sr")
        source_name = source_element ? source_element.content : ""

        site.generate_article(title, time_str, content, source_name, url)
      end
    end
  end

  #食品商务网
  def deal_21food(go_next_page = false, go_pages = 999)
    deal_site(I18n.t("fetch_sites.twentyone_food"), ["http://www.21food.cn/news/list_g26_chnl-%B3%E9%BC%EC%C6%D8%B9%E2.html",
                            "http://www.21food.cn/news/list_g26_chnl-%CF%FB%B7%D1%BE%AF%CA%BE.html"], go_next_page, go_pages) do |site, agent|
      site.log "See " + agent.page.search(".news-list-left .cate-ul li").size.to_s + " articles."
      agent.page.search(".news-list-left .cate-ul li").each do |item|
        link = item.at_css('a')
        next unless link
        href = link.attributes['href']
        time_str = item.at_css('span').content
        agent.get(href)
        title = agent.page.at(".ndetail-nr-title").content
        content = agent.page.at("#newsContent").content
        url = agent.page.uri

        source_element = agent.page.at(".p-nr p")
        source_name = source_element ? source_element.content : ""

        site.generate_article(title, time_str, content, source_name, url)
      end
    end
  end

  #南方网
  def deal_southcn(go_next_page = false, go_pages = 999)
    deal_site(I18n.t("fetch_sites.southcn"), ["http://food.southcn.com/c/node_143373.htm",
                        "http://food.southcn.com/c/node_143382.htm"], go_next_page, go_pages) do |site, agent|
      site.log "See " + agent.page.search(".GsTitleList6 dt").size.to_s + " articles."
      agent.page.search(".GsTitleList6 dt").each do |item|
        link = item.at_css('a')
        next unless link
        href = link.attributes['href']
        time_str = item.at_css('.time').content
        agent.get(href)
        title = agent.page.at("#ScDetailTitle").content
        content = agent.page.at("#ScDetailContent").content
        url = agent.page.uri

        source_element = agent.page.at("span.source")
        source_name = source_element ? source_element.content : ""

        site.generate_article(title, time_str, content, source_name, url)
      end
    end
  end

  #新华网
  #could be multiple pages
  def deal_xinhuanet(go_next_page = false, go_pages = 999)
    deal_site(I18n.t("fetch_sites.xinhuanet"), ["http://www.news.cn/food/baoguang.htm",
                        "http://www.news.cn/food/yaowen.htm",
                        "http://www.news.cn/food/yinliao.htm",
                        "http://www.news.cn/food/nongfu.htm",
                        "http://www.news.cn/food/rupin.htm",
                        "http://www.news.cn/food/xiaofei.htm"], go_next_page, go_pages) do |site, agent|
      site.log "See " + agent.page.search(".black14 a").size.to_s + " articles."
      agent.page.search(".black14").each do |item|
        link = item.at_css('a')
        next unless link
        href = link.attributes['href']
        time_str = item.at_css('.sj').content
        agent.get(href)
        title = agent.page.at("#Title").content
        content = agent.page.at("#Content").content
        url = agent.page.uri

        site.generate_article(title, time_str, content, "", url)
      end
    end
  end

  #deal foodmate site
  def deal_foodmate(go_next_page = false, go_pages = 999)
    deal_site(I18n.t("fetch_sites.foodmate"), ["http://www.foodmate.net/foodsafe/knowledge/",
                            "http://www.foodmate.net/foodsafe/case/",
                            "http://www.foodmate.net/news/guonei/",
                            "http://www.foodmate.net/news/guoji/",
                            "http://www.foodmate.net/news/yujing/"], go_next_page, go_pages) do |site, agent|
      site.log "See " + agent.page.search(".catlist_li a").size.to_s + " articles."
      agent.page.search(".catlist_li").each do |item|
        href = item.at_css('a').attributes['href']
        time_str = item.at_css('.f_gray').content
        agent.get(href)
        title = agent.page.at(".title").content
        content = agent.page.at("#article").content
        url = agent.page.uri

        source_element = agent.page.at(".info")
        source_name = source_element ? source_element.content : ""

        site.generate_article(title, time_str, content, source_name, url)
      end
    end
  end

end