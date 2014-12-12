require 'mechanize'

agent = Mechanize.new

agent.get("http://www.guanabara.info/guanacast/") do |page|
  podcasts = []
  page.links.each do |link|
    podcasts << link if (link.text == "") && (link.href.include? "http://www.guanabara.info")
  end

  podcasts.each do |podcast|
    begin
      child_page = podcast.click
      article_title = child_page.search(".article_title").text.gsub("/", "-")
      mp3_link = child_page.link_with(text: "Baixar Podcast")
      mp3_link.click.save_as("podcasts/#{article_title}.mp3")
      puts "episode #{article_title} saved"
    rescue
      puts "episode #{article_title} not found"
    end
  end
end