require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'date'

def get_factory_menu(url)
  doc = Nokogiri::HTML(open(url))
  datestr = Time.now.strftime("%-d.%-m.%Y")
  doc.css(".lounaspaiva").each do |item|
    day = item.at_css(".ac-otsikko").text
    if day[datestr]
      menu = item.at_css("p")
      return menu
    end
  end
end

def get_perho_menu(url)
  day_names = { "Monday" => "Maanantai", "Tuesday" => "Tiistai",
    "Wednesday" => "Keskiviikko", "Thursday" => "Torstai", "Friday" => "Perjantai" }
  doc = Nokogiri::HTML(open(url))
  datestr = Time.now.strftime("%A")
  doc.css(".flex_column.av_one_half.flex_column_div.el_before_av_one_half").each do |item|
    if item.text[day_names[datestr]]
      menu = ""
      item.css("p").each do |item|
        menu = menu + item.text + "<br />"
      end
      return menu
    end
  end
end

factory_url = "http://www.factorykamppi.com/lounas/"
perho_url = "https://www.ravintolaperho.fi/lounaslista/"
epic_url = "http://epic.fi/#!/weeklymenu"
SCHEDULER.every '2h', :first_in => 0 do
  factory_menu = get_factory_menu(factory_url)
  perho_menu = get_perho_menu(perho_url)
  send_event('lunch', { factory_lunch: "#{factory_menu}", factory_title: "Factory Kamppi",
    perho_lunch: "#{perho_menu}", perho_title: "Ravintola Perho" })
end
