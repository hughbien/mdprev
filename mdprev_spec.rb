require 'mdprev'

describe MarkdownPreview do
  it 'should build anchors from markdown' do
    body, anchors = MarkdownPreview.build_body_and_anchors("
      # Header !@%^_ 1\n
      Paragraph\n
      # Header 2\n
      Paragraph 2\n
    ".gsub(/^ +/, ''))
    anchors.should == [
      ['header-1', 'Header !@%^_ 1'],
      ['header-2', 'Header 2']
    ]
  end

  it 'should build body from markdown' do
    body, anchors = MarkdownPreview.build_body_and_anchors("
      # Header
      Sample Text
    ".gsub(/^\s+/, ''))
    body.should =~ /<h1>Header<\/h1>/
    body.should =~ /<p>Sample Text<\/p>/
  end

  it 'should generate title from filenames' do
    MarkdownPreview.title_from_files(['sample.md']).should == 'Sample'
    MarkdownPreview.title_from_files([
      'league-of-extraordinary-_^Gentlemen',
      'ignoreothernames'
    ]).should == 'League Of Extraordinary Gentlemen'
  end

  it 'should build nav from anchors' do
    nav = MarkdownPreview.build_nav([
      ['first-id', 'First ID'],
      ['second-item', 'Second Item'],
      ['third', 'Third'],
      ['fourth', 'Fourth'],
      ['fifth', 'Fifth']
    ])
    nav.should =~ /^<ul id="main-nav">/
    nav.should =~ /<li><a href="#first-id">First ID<\/a><\/li>/
    nav.should =~ /<li><a href="#second-item">Second Item<\/a><\/li>/
    nav.should =~ /<li><a href="#third">Third<\/a><\/li>/
    nav.should =~ /<li><a href="#fourth">Fourth<\/a><\/li>/
    nav.should =~ /<\/ul>$/
  end

  it 'should determine nav class from amount of anchors' do
    MarkdownPreview.body_class(:pdf => false, :nav => false).should == ''
    MarkdownPreview.body_class(:pdf => true).should == 'pdf-layout'
    MarkdownPreview.body_class(:nav => true).should == 'nav-layout'
  end
end
