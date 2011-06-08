namespace :yin11 do
  desc "db:drop then db:seed"
  task :reset => :environment do
    Rake::Task['db:drop'].invoke
    Rake::Task['db:seed'].invoke
    puts "The database has been reset."
  end

  desc "create some testing articles"
  task :fetch_articles => :environment do
    File.open(File.join(RAILS_ROOT, 'app/assets/article_source.txt')).each_line do |url|
      agent = Mechanize.new
      agent.get(url)

      puts agent.page.search(".catlist_li a").size.to_s
      agent.page.search(".catlist_li").each do |item|
        href = item.at_css('a').attributes['href']
        time = item.at_css('.f_gray').content
        agent.get(href)
        title = agent.page.at(".title").content
        content = agent.page.at("#article").content
        puts title
        Article.find_or_create_by(:title => title, :content => content)
      end
    end
  end
end