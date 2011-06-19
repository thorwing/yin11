#encoding utf-8

namespace :yin11 do
  desc "db:drop then db:seed"
  task :reset => :environment do
    Rake::Task['db:drop'].invoke
    Rake::Task['db:seed'].invoke
    puts "The database has been reset."
  end

  #deal foodmate site
  def deal_foodmate
    agent = Mechanize.new
    count = 0
    url_list = ["http://www.foodmate.net/foodsafe/knowledge/"]
                #, "http://www.foodmate.net/foodsafe/knowledge/list_2.html", "http://www.foodmate.net/foodsafe/knowledge/list_3.html",
                #"http://www.foodmate.net/foodsafe/case/", "http://www.foodmate.net/foodsafe/case/list_2.html", "http://www.foodmate.net/foodsafe/case/list_3.html"]
    url_list.each do |url|
      agent.get(url)
      category = "case" #bydefault
      category = "knowledge" if url.include?("knowledge")
      category = "case" if url.include?("case")

      #number_of_articles = agent.page.search(".catlist_li a").size.to_s
      agent.page.search(".catlist_li").each do |item|
        href = item.at_css('a').attributes['href']
        time = item.at_css('.f_gray').content
        agent.get(href)
        title = agent.page.at(".title").content
        content = agent.page.at("#article").content
        puts title + " -> " + DateTime.parse(time).strftime('%m/%d/%Y')

        Article.find_or_create_by(:title => title, :content => content, :published_on => DateTime.parse(time), :category => category)
        count += 1
      end
    end
  end

  desc "create some testing articles"
  task :fetch_articles => :environment do
    deal_foodmate
  end

end