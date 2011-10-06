require 'rubygems'
require 'mdprev'
require 'minitest/autorun'

class MarkdownPreviewTest < MiniTest::Unit::TestCase
  def test_build_anchors
    body, anchors = MarkdownPreview.build_body_and_anchors("
      # Header !@%^_ 1\n
      Paragraph\n
      # Header 2\n
      Paragraph 2\n
    ".gsub(/^ +/, ''))
    assert_equal(
      [['header-1', 'Header !@%^_ 1'], ['header-2', 'Header 2']],
      anchors)
  end

  def test_build_body
    body, anchors = MarkdownPreview.build_body_and_anchors("
      # Header
      Sample Text
    ".gsub(/^\s+/, ''))
    assert_match(/<h1>Header<\/h1>/, body)
    assert_match(/<p>Sample Text<\/p>/, body)
  end

  def test_title
    assert_equal('Sample', MarkdownPreview.title_from_files(['sample.md']))
    assert_equal(
      'League Of Extraordinary Gentlemen',
      MarkdownPreview.title_from_files([
        'league-of-extraordinary-_^Gentlemen',
        'ignoreothernames'
      ]))
  end

  def test_build_nav
    nav = MarkdownPreview.build_nav([
      ['first-id', 'First ID'],
      ['second-item', 'Second Item'],
      ['third', 'Third'],
      ['fourth', 'Fourth'],
      ['fifth', 'Fifth']
    ])
    assert_match(/^<ul id="main-nav">/, nav)
    assert_match(/<li><a href="#first-id">First ID<\/a><\/li>/, nav)
    assert_match(/<li><a href="#second-item">Second Item<\/a><\/li>/, nav)
    assert_match(/<li><a href="#third">Third<\/a><\/li>/, nav)
    assert_match(/<li><a href="#fourth">Fourth<\/a><\/li>/, nav)
    assert_match(/<\/ul>$/, nav)
  end

  def test_body_class
    assert_equal('', MarkdownPreview.body_class(:pdf => false, :nav => false))
    assert_equal('pdf-layout', MarkdownPreview.body_class(:pdf => true))
    assert_equal('nav-layout', MarkdownPreview.body_class(:nav => true))
  end
end
