require 'spec_helper'

describe Resque::Plugins::Director::Config do
  let(:options) { {} }
  subject { Resque::Plugins::Director::Config.new(options) }

  describe "#initialize" do
    context "if no options are specified" do
      subject { Resque::Plugins::Director::Config.new }

      it "should set the variables to defaults" do
        Resque::Plugins::Director::Config::DEFAULT_OPTIONS.each do |key, value |
          expect(subject.send(key)).to eq value
        end
      end
    end

    context "when valid options are provided" do
      let(:options) { {:min_workers => 3, :wait_time => 30} }

      it "should set the variables to the specified values" do
        subject.min_workers.should == 3
        subject.wait_time.should == 30
      end
    end

    context "when bogus config options are given" do
      let(:options) { {:bogus => 3} }

      it "should handle gracefully" do
        expect { subject }.not_to raise_error
      end
    end

    context "if max_workers is less than min_workers" do
      let(:options) { {:min_workers => 3, :max_workers => 2} }

      it "should set max_workers to default" do
        subject.min_workers.should == 3
        subject.max_workers.should == 0
      end
    end

    context "if min_workers is less than 0" do
      let(:options) { {:min_workers => -1} }

      it "should set min_workers to 1" do
        subject.min_workers.should == 0
      end
    end
  end

  describe "queue" do
    it "allows reading and writing the queue attribute" do
      subject.queue = "penguins"
      expect(subject.queue).to eq "penguins"
    end
  end

  describe "log" do
    context "if specified a logger is specified" do
      let(:log) { double('Logger') }

      context "and a log level is specified" do
        let(:options) { {:logger => log, :log_level => :info} }

        it "logs message to a logger using given log level" do
          log.should_receive(:info).with("DIRECTORS LOG: test message")
          subject.log("test message")
        end
      end

      context "but no log level is specified" do
        let(:options) { {:logger => log} }

        it "defaults log level to debug" do
          log.should_receive(:debug).with("DIRECTORS LOG: test message")
          subject.log("test message")
        end
      end
    end


  end
end
