require 'helper'

class TestShibbolethsLilHelper < Test::Unit::TestCase
  should "have a Slh namespace that will contain all classes contained" do
    assert Slh.class == Module
  end
  should "provides class representing core shibboleth model-ish ideas" do
    assert Slh::Models::App.class == Class
    assert Slh::Models::Host.class == Class
    # TODO add more
  end
  should "provide some top level methods for using the tool" do
    assert_respond_to Slh, :define_entity_id
    # TODO add more
  end

  context "with :dummy1 strategy" do
    setup do
      require 'fixtures/dummy1.rb'
    end
    should "have an entity id" do
      assert_kind_of String, Slh.entity_id(:default) 
      assert_raises RuntimeError do 
        Slh.entity_id(:asdfewrjkjkj)
      end
    end
    should "load up a strategy" do
      assert_kind_of Slh::Models::Strategy, Slh.with(:dummy1)
      assert_raises RuntimeError do 
        Slh.with(:asldfjlaksdjflk)
      end
    end
    should "have a non-empty hosts array" do
      assert_kind_of Array, Slh.with(:dummy1).hosts
      assert Slh.with(:dummy1).hosts.length > 0, 'more than 1 host in the array'
      assert Slh.with(:dummy1).hosts.first.name == 'shib-local-vm1.asr.umn.edu'
    end
    should "have a non-empty apps array for the first host" do
      strategy = Slh.with(:dummy1)
      assert_kind_of Array, strategy.hosts.first.apps
      assert strategy.hosts.first.apps.length > 0
      assert strategy.hosts.first.apps.first.url == 'https://shib-local-vm1.asr.umn.edu'
    end
    should "have non-empty app_auth_rules array for first host and first app" do
      strategy = Slh.with(:dummy1)
      assert_kind_of Array, strategy.hosts.first.apps.first.auth_rules

      # First auth rule
      assert strategy.hosts.first.apps.first.auth_rules.first.url_path == '/secure'
      assert strategy.hosts.first.apps.first.auth_rules.first.rule_type == :location
      assert strategy.hosts.first.apps.first.auth_rules.first.flavor == :mandatory_authentication

      # Second auth rule
      assert strategy.hosts.first.apps.first.auth_rules[1].url_path == '/lazy'
      assert strategy.hosts.first.apps.first.auth_rules[1].rule_type == :location
      assert strategy.hosts.first.apps.first.auth_rules[1].flavor == :lazy_authentication

    end
  end
end
