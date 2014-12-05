require 'spec_helper'
require 'rspec/its'
require 'json'
require 'equalizer'

describe Jsonizer do
  it 'should have a version number' do
    Jsonizer::VERSION.should_not be_nil
  end

  context 'When included without parameters' do
    class NoParamIncludeClass
      include Jsonizer.new
    end

    subject {NoParamIncludeClass.new}

    it {should respond_to :to_json}
    its(:class) {should respond_to :json_create}
    it {should be_same_class_after_json}
  end

  context "With a jsonized and an unrelated attribute" do
    class WithUnrelated
      include Jsonizer.new :jsonized_attribute
      include Equalizer.new :jsonized_attribute, :unrelated_attribute
      attr_reader :jsonized_attribute, :unrelated_attribute

      def initialize jsonized_attribute, unrelated_attribute = 'default_unrelated_attribute'
        @jsonized_attribute = jsonized_attribute
        @unrelated_attribute = unrelated_attribute
      end
    end

    let(:original) {WithUnrelated.new 'original_jsonized_attribute', 'original_unrelated_attribute'}
    subject {original}
    it {should respond_to :to_json}
    its(:class) {should respond_to :json_create}
    it {should be_same_class_after_json}
    it {should_not be_eql_after_json}

    describe "after json conversion" do
      subject {JSON.load(JSON.dump(original))}
      its(:jsonized_attribute) {should eql original.jsonized_attribute}
      its(:unrelated_attribute) {should_not eql original.unrelated_attribute}
      its(:unrelated_attribute) {should eql 'default_unrelated_attribute'}
    end
  end

  context "With multiple jsonized and unrelated attribute" do
    class Multiple
      include Jsonizer.new :jsonized_a, :jsonized_b
      include Equalizer.new :jsonized_a, :unrelated_attribute
      attr_reader :jsonized_a, :jsonized_b, :unrelated_attribute

      def initialize jsonized_a, jsonized_b = 14, unrelated_attribute = 'default_unrelated_attribute'
        @jsonized_a = jsonized_a
        @jsonized_b = jsonized_a
        @unrelated_attribute = unrelated_attribute
      end
    end

    let(:original) {Multiple.new 'original_jsonized_a', 1024, 'original_unrelated_attribute'}
    subject {original}

    it {should respond_to :to_json}
    its(:class) {should respond_to :json_create}
    it {should be_same_class_after_json}
    it {should_not be_eql_after_json}

    describe "after json conversion" do
      subject {JSON.load(JSON.dump(original))}
      its(:jsonized_a) {should eql original.jsonized_a}
      its(:jsonized_b) {should eql original.jsonized_b}
      its(:unrelated_attribute) {should_not eql original.unrelated_attribute}
      its(:unrelated_attribute) {should eql 'default_unrelated_attribute'}
    end
  end

  context "Anonymous classes" do
    it "should throw when included" do
      expect {Class.new do include Jsonizer.new end}.to raise_error ArgumentError
    end
  end
end
