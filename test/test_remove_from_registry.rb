require 'test_helper'

class TestRemoveFromRegistry < Test::Unit::TestCase
  def setup
    super
    FakeWeb.register_uri(:get, 'http://example.com', :body => "Example dot com!")
    FakeWeb.register_uri(:post, 'http://example.com', :body => "Example dot com!")
    FakeWeb.register_uri(:get, 'http://google.com', :body => "Google dot com!")
  end

  def test_removes_when_match_method_and_uri
    assert FakeWeb.registered_uri?(:get, 'http://example.com')
    FakeWeb.remove_from_registry(:get, 'http://example.com')
    assert !FakeWeb.registered_uri?(:get, 'http://example.com')
  end

  def test_removes_all_matching_uris_when_method_is_any
    assert FakeWeb.registered_uri?(:get, 'http://example.com')
    assert FakeWeb.registered_uri?(:post, 'http://example.com')
    FakeWeb.remove_from_registry(:any, 'http://example.com')
    assert !FakeWeb.registered_uri?(:get, 'http://example.com')
    assert !FakeWeb.registered_uri?(:post, 'http://example.com')
  end

  def test_does_not_remove_when_method_does_not_match
    assert FakeWeb.registered_uri?(:post, 'http://example.com')
    FakeWeb.remove_from_registry(:get, 'http://example.com')
    assert FakeWeb.registered_uri?(:post, 'http://example.com')
  end

  def test_does_not_not_remove_when_uri_does_not_match
    assert FakeWeb.registered_uri?(:get, 'http://google.com')
    FakeWeb.remove_from_registry(:any, 'http://example.com')
    assert FakeWeb.registered_uri?(:get, 'http://google.com')
  end
end
