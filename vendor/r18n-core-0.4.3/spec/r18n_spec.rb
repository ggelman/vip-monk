# encoding: utf-8
require File.join(File.dirname(__FILE__), 'spec_helper')

describe R18n do
  after do
    R18n.default_loader = R18n::Loader::YAML
  end

  it "should store I18n" do
    i18n = R18n::I18n.new('en')
    R18n.set(i18n)
    R18n.get.should == i18n
    
    R18n.set(nil)
    R18n.get.should be_nil
  end
  
  it "should set setter to I18n" do
    i18n = R18n::I18n.new('en')
    R18n.set(i18n)
    
    i18n = R18n::I18n.new('ru')
    R18n.set { i18n }
    
    R18n.get.should == i18n
  end
  
  it "should store default loader class" do
    R18n.default_loader.should == R18n::Loader::YAML
    R18n.default_loader = Class
    R18n.default_loader.should == Class
  end
  
  it "should store cache" do
    R18n.cache.should be_a(Hash)
    
    R18n.cache = { 1 => 2 }
    R18n.cache.should == { 1 => 2 }
    
    R18n.cache.clear
    R18n.cache.should == {}
  end
  
  it "should convert Time to Date" do
      R18n::Utils.to_date(Time.now).should == Date.today
  end
  
  it "should map hash" do
    R18n::Utils.hash_map({'a' => 1, 'b' => 2}) { |k, v| [k + 'a', v + 1] }.
      should == { 'aa' => 2, 'ba' => 3 }
  end
  
  it "should merge hash recursively" do
    a = { :a => 1,
          :b => {:ba => 1, :bb => 1},
          :c => 1 }
    b = { :b => {:bb => 2, :bc => 2},
          :c => 2 }
    
    R18n::Utils.deep_merge!(a, b)
    a.should == { :a => 1,
                  :b => { :ba => 1, :bb => 1, :bc => 2 },
                  :c => 1 }
  end

end
