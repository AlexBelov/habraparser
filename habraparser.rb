require 'pdfkit'
require 'watir'


id_posts = [79790,79819,108992,79853,79882,79923,79962,80081,80268]
@html_doc = ""

def parse_post id
	page_url = "http://habrahabr.ru/post/#{id}/"

	browser = Watir::Browser.new
	browser.goto page_url

	page = browser.html
	browser.close

	page = page.to_s
	#page.delete!("\n")
	page.gsub!(/\n/, "new_line")
	page_title = "<h1>" + page.scan(/<span class="post_title">(.*?)<\/span>/).join + "</h1>"
	page = page.scan(/<div class="content html_format">(.*?)<\/div>/).join

	page = "<div class=""post"">" + page_title + page + "</div>"
	page.gsub!(/new_line/, "\n")
	@html_doc += page
end

id_posts.each {|id| parse_post id}

kit = PDFKit.new(@html_doc, :page_size => 'Letter')
kit.stylesheets << 'styles.css'
file = kit.to_file('NLP.pdf')