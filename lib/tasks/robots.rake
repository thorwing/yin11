#encoding utf-8

namespace :yin11 do
  desc "create some testing articles"
  task :fetch_articles => :environment do
    deal_foodmate
  end

  #deal foodmate site
  def deal_foodmate
    agent = Mechanize.new
    count = 0
    site = "Foodmate"
    url_list = ["http://www.foodmate.net/foodsafe/knowledge/"]
                #, "http://www.foodmate.net/foodsafe/knowledge/list_2.html", "http://www.foodmate.net/foodsafe/knowledge/list_3.html",
                #"http://www.foodmate.net/foodsafe/case/", "http://www.foodmate.net/foodsafe/case/list_2.html", "http://www.foodmate.net/foodsafe/case/list_3.html"]
    url_list.each do |url|
      agent.get(url)

      #number_of_articles = agent.page.search(".catlist_li a").size.to_s
      agent.page.search(".catlist_li").each do |item|
        href = item.at_css('a').attributes['href']
        time = item.at_css('.f_gray').content
        agent.get(href)
        title = agent.page.at(".title").content
        content = agent.page.at("#article").content
        url = agent.page.uri

        puts title + " -> " + DateTime.parse(time).strftime('%m/%d/%Y')

        Article.find_or_create_by(title: title) do |a|
          a.content = content
          a.reported_on_string = time
          a.disabled = true
          a.build_source
          a.source.name = site
          a.source.site = site
          a.source.url = url.to_s
        end

        count += 1
      end
    end
  end
end