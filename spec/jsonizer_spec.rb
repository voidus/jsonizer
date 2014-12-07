require 'spec_helper'
require 'rspec/its'
require 'json'
require 'equalizer'

describe Jsonizer do
  it 'should have a version number' do
    expect(Jsonizer::VERSION).not_to be_nil
  end

  context 'When included without parameters' do
    class NoParamIncludeClass
      include Jsonizer.new
    end

    subject { NoParamIncludeClass.new }

    it {  is_expected.to respond_to :to_json }
    its(:class) { is_expected.to respond_to :json_create }
    it { is_expected.to be_same_class_after_json }
  end

  context 'With a jsonized and an unrelated attribute' do
    class WithUnrelated
      include Jsonizer.new :jsonized_attribute
      include Equalizer.new :jsonized_attribute, :unrelated_attribute
      attr_reader :jsonized_attribute, :unrelated_attribute

      def initialize(jsonized_attribute, unrelated_attribute = 'default_unrelated_attribute')
        @jsonized_attribute = jsonized_attribute
        @unrelated_attribute = unrelated_attribute
      end
    end

    let(:original) { WithUnrelated.new 'original_jsonized_attribute', 'original_unrelated_attribute' }
    subject { original }
    it { is_expected.to respond_to :to_json }
    its(:class) { is_expected.to respond_to :json_create }
    it { is_expected.to be_same_class_after_json }
    it { is_expected.not_to be_eql_after_json }

    describe 'after json conversion' do
      subject { JSON.load(JSON.dump(original)) }
      its(:jsonized_attribute) { is_expected.to eql original.jsonized_attribute }
      its(:unrelated_attribute) { is_expected.not_to eql original.unrelated_attribute }
      its(:unrelated_attribute) { is_expected.to eql 'default_unrelated_attribute' }
    end
  end

  context 'With multiple jsonized and unrelated attribute' do
    class Multiple
      include Jsonizer.new :jsonized_a, :jsonized_b
      include Equalizer.new :jsonized_a, :unrelated_attribute
      attr_reader :jsonized_a, :jsonized_b, :unrelated_attribute

      def initialize(jsonized_a, jsonized_b = 14, unrelated_attribute = 'default_unrelated_attribute')
        @jsonized_a = jsonized_a
        @jsonized_b = jsonized_a
        @unrelated_attribute = unrelated_attribute
      end
    end

    let(:original) { Multiple.new 'original_jsonized_a', 1024, 'original_unrelated_attribute' }
    subject { original }

    it { is_expected.to respond_to :to_json }
    its(:class) { is_expected.to respond_to :json_create }
    it { is_expected.to be_same_class_after_json }
    it { is_expected.not_to be_eql_after_json }

    describe 'after json conversion' do
      subject { JSON.load(JSON.dump(original)) }
      its(:jsonized_a) { is_expected.to eql original.jsonized_a }
      its(:jsonized_b) { is_expected.to eql original.jsonized_b }
      its(:unrelated_attribute) { is_expected.not_to eql original.unrelated_attribute }
      its(:unrelated_attribute) { is_expected.to eql 'default_unrelated_attribute' }
    end
  end

  context 'Anonymous classes' do
    it 'should throw when included' do
      expect { Class.new { include Jsonizer.new } }.to raise_error ArgumentError
    end
  end
end
