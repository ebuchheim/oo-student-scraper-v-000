require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = File.read("./fixtures/student-site/index.html")
    student = Nokogiri::HTML(html)
    students = []
    student.css(".student-card").each do |student|
      student_hash = {
        #pull in the stuff here
        name: student.css("h4.student-name").text,
        location: student.css("p.student-location").text,
        profile_url: student.css("a").attribute("href").value
      }
      students << student_hash
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    html = File.read(profile_url)
    student = Nokogiri::HTML(html)
    student_attributes = {
      profile_quote: student.css(".profile-quote").text,
      bio: student.css(".description-holder p").text
    }
    student_social_sites = student.css(".social-icon-container a").collect do |site|
      site.attribute("href").value
    end
    student_social_sites.each do |site|
      if site.match(/linked/)
        student_attributes[:linkedin] = site
      elsif site.match(/twitter/)
        student_attributes[:twitter] = site
      elsif site.match(/github/)
        student_attributes[:github] = site
      else
        student_attributes[:blog] = site
      end
    end
    student_attributes
  end
end


