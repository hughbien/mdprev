#!/usr/bin/env ruby

require 'rubygems'
require 'bluecloth'

module MarkdownPreview
  VERSION       = '1.0.1'
  OPEN_HTML     = ENV['MDPREV_OPEN_HTML'] || 'open'
  OPEN_PDF      = ENV['MDPREV_OPEN_PDF'] || 'open'
  CONVERT_PDF   = ENV['MDPREV_CONVERT_PDF'] || 'wkhtmltopdf $input $output'
  PREVIEW_HTML  = "#{Dir.pwd}/.preview.html"
  PREVIEW_PDF   = "#{Dir.pwd}/.preview.pdf"

  def self.run(fnames, flags = {})
    html = File.open(PREVIEW_HTML, 'w')
    html.write(to_html(
      fnames.map {|f| File.read(f)}.join("\n"),
      title_from_files(fnames), 
      flags))
    html.close

    if flags[:pdf]
      command = CONVERT_PDF.
        sub('$input', PREVIEW_HTML).
        sub('$output', PREVIEW_PDF)
      `#{command} && #{OPEN_PDF} #{PREVIEW_PDF}`
      sleep(1)
      File.delete(PREVIEW_HTML)
      File.delete(PREVIEW_PDF)
    else
      `#{OPEN_HTML} #{PREVIEW_HTML}`
      sleep(1)
      File.delete(PREVIEW_HTML)
    end
  rescue StandardError => e
    puts e.message
  ensure
    html.close if html && !html.closed?
  end

  def self.to_html(str, title = 'Preview', flags = {})
    body, anchors = build_body_and_anchors(str)
    TEMPLATE.
      sub('$nav$', flags[:nav] ? build_nav(anchors) : '').
      sub('$body$', body).
      sub('$class$', body_class(flags)).
      sub('$title$', title).
      gsub('<div class="section"></div>', '')
  end

  def self.build_body_and_anchors(str)
    html = BlueCloth.new(str).to_html
    anchors = []
    html.gsub!('<h1>', '</div><div class="section"><h1>')
    html.scan(/<h1>[^<]+<\/h1>/).each do |match|
      text = match.gsub(/<\/?h1>/, '')
      anchor = text.
        gsub(/[^a-zA-Z0-9\- ]/, '').
        gsub(/\s+/, '-').
        downcase
      anchors.push([anchor, text])
      html.sub!(match, 
        "<a class=\"fragment-anchor\" name=\"#{anchor}\"></a>#{match}")
    end
    [html, anchors]
  end

  def self.title_from_files(fnames)
    File.basename(fnames.first).
      gsub(/#{File.extname(fnames.first)}$/, '').
      gsub(/[^a-zA-Z0-9\-_ ]/, '').
      gsub(/[\-_]/, ' ').
      split(/\s+/).
      map {|s| s.capitalize}.
      join(' ')
  end

  def self.body_class(flags)
    if flags[:pdf]
      'pdf-layout'
    elsif flags[:nav]
      'nav-layout'
    else
      ''
    end
  end

  def self.build_nav(anchors)
    html = ['<ul id="main-nav">']
    anchors.each do |anchor, text|
      html << "<li><a href=\"##{anchor}\">#{text}</a></li>"
    end
    html << '</ul>'
    html.join('')
  end
end

MarkdownPreview::TEMPLATE = <<END
<!doctype html>
<head>
<title>$title$</title>
<style>
html, body, div, span, object, iframe,h1, h2, h3, h4, h5, h6, p, blockquote, 
pre,a, abbr, acronym, address, big, cite, code,del, dfn, em, img, ins, kbd, q, 
s, samp,small, strike, strong, sub, sup, tt, var,dl, dt, dd, ol, ul, li,
fieldset, form, label, legend,table, caption, tbody, tfoot, thead, tr, th, td { 
  margin: 0; padding: 0; border: 0; outline: 0; font-weight: inherit;
  font-style: inherit;
  vertical-align: baseline; 
}
body { text-align: center; font-size: 11.5px; background: #e0e0e0;
  line-height: 1.7em; color: #333; width: 100%; height: 100%;
  font-family: lucida grande, helvetica, sans-serif; }
h1,h2,h3,h4,h5,h6 { font-weight: bold; font-family: Copperplate / Copperplate Gothic Light, sans-serif; }
h1 { margin: 36px 0 24px; color: #111; border-bottom: 1px dashed #aaa; 
  padding-bottom: 6px; font-size: 2.2em; }
h1 + p, h1 + ol, h1 + ul { margin-top: -12px; }
h2, h3, h4, h5, h6 { margin: 24px 0; color: #111; }
h2 + p, h2 + ol, h2 + ul,
h3 + p, h3 + ol, h3 + ul,
h4 + p, h4 + ol, h4 + ul,
h5 + p, h5 + ol, h5 + ul,
h6 + p, h6 + ol, h6 + ul { margin-top: -12px; }
h2 { font-size: 1.8em; }
h3 { font-size: 1.6em; }
h3 { font-size: 1.4em; }
h4 { font-size: 1.2em; }
h5 { font-size: 1.1em; }
h6 { font-size: 1em; }
a { color: #a37142; text-decoration: none; }
a:hover { color: #234f32; }
.fragment-anchor + h1, h1:first-child { margin-top: 0; }
select, input, textarea { font: 99% lucida grande, helvetica, sans-serif; }
pre, code { font-family: Lucida Console, Monaco, monospace; }
ol { list-style: decimal; }
ul { list-style: disc; }
ol, ul { margin: 24px 0 24px 1.7em; }
p + ol, p + ul { margin-top: -16px; }
ol:last-child, ul:last-child { margin-bottom: 0; }
table { border-collapse: collapse; border-spacing: 0; }
caption, th, td { text-align: left; font-weight: normal; }
blockquote:before, blockquote:after,q:before, q:after { content: ""; }
blockquote, q { quotes: "" ""; }
em { font-style: italic; }
strong { font-weight: bold; }
p { margin: 24px 0; }
p:first-child { margin-top: 0; }
p:last-child { margin-bottom: 0; }
#main { width: 574px; margin: 60px auto; text-align: left; position: relative;
  left: 0; }
.section { padding: 36px; background: #fff; border: 1px solid #bcbcbc; 
  -webkit-box-shadow: 2px 2px 4px #ccc; 
  -moz-box-shadow: 2px 2px 4px #ccc; margin-bottom: 36px; }
.section pre { border-top: 1px solid #000; border-bottom: 1px solid #000;
   color: #fff; background: #555; width: 100%; padding: 12px 36px;
   position: relative; right: 36px; font-family: Monaco, monospace; }
.section pre code { font-weight: normal; }
.section code { font-family: Monaco, monospace; font-weight: bold; }
.section strong { border-bottom: 1px dashed #aaa; }

#main-nav { position: fixed; top: 40px; text-align: left; list-style: none; 
  text-align: right; margin-left: -170px; width: 240px; }
#main-nav li { margin-bottom: 4px; }
.nav-layout #main { left: 100px; }

body.pdf-layout { background: #fff; line-height: 1.4em; font-size: 10px; }
.pdf-layout #main { width: 420px; }
.pdf-layout h1, .pdf-layout h2, .pdf-layout h3, .pdf-layout h4, 
.pdf-layout h5, .pdf-layout h6 { margin: 12px 0 -6px; color: #000; }
.pdf-layout h1 { font-size: 1.4em; border-bottom: none; }
.pdf-layout h2 { font-size: 1.3em; }
.pdf-layout h3 { font-size: 1.2em; }
.pdf-layout h4 { font-size: 1.1em; }
.pdf-layout h5 { font-size: 1em; }
.pdf-layout .section { border: none; margin-bottom: 0; padding: 12px 0 0 0;
  -webkit-box-shadow: none; -moz-box-shadow: none; }
.pdf-layout .section:first-child { padding-top: 0; }
.pdf-layout .section pre { position: static; padding: 6px 12px; width: 396px;
  background: #e0e0e0; color: #000; font-size: 0.95em; border: none; }
.pdf-layout .section pre:last-child { margin-bottom: 24px; }
.pdf-layout .section code { font-weight: normal; }
.pdf-layout p { text-align: justify; }
.pdf-layout p, .pdf-layout ol, .pdf-layout ul { margin-top: 16px;
  margin-bottom: 16px; }
</style>
</head>
<body class="$class$">
  <div id="main">
    <div class="section">$body$</div>
    $nav$
  </div>
</body>
</html>
END
