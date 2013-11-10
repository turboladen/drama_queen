require 'spec_helper'
require 'drama_queen/consumer'
require 'drama_queen/producer'


describe 'Draaaamaaaa' do
  before do
    DramaQueen.unsubscribe_all
  end

  context 'lots of action' do
    let(:one) { double 'one' }

    before do
      class A
        include DramaQueen::Producer

        def do_stuff
          publish 'stuff1', 'the stuff1'
          publish 'stuff2', 'the stuff2'
          publish 'stuff5', 'the stuff3'
          publish 'stuff3', 'the stuff4'
          publish 'stuff5', 'the stuff5'
        end
      end

      class B
        include DramaQueen::Consumer

        def initialize
          100000.times do
            subscribe 'stuff1', :call_me
            subscribe 'stuff2', :call_me2
            subscribe 'stuff3', :call_me
            subscribe 'stuff4', :call_me2
            subscribe 'stuff5', ->(arg) {
              #puts arg
            }
          end
        end

        def call_me(msg)
        end

        def call_me2(msg)
        end
      end
    end

    it 'calls all of the things' do
      a = A.new
      b = B.new

      a.do_stuff
      b.subscribe 'things', ->(arg) { puts arg }

      a.do_stuff
      a.publish 'things', 'hi'
    end
  end

  describe 'topic matching' do
    before do
      @@thing = Object.new
      class A
        include DramaQueen::Consumer

        def initialize
          subscribe 'root.*.children', :call_me
        end

        def call_me(*args)
          puts "A got called with args: #{args}"
        end
      end

      class B
        include DramaQueen::Producer

        def do_stuff
          publish 'root.parent', 1, 2, 3
        end
      end

      class C
        include DramaQueen::Producer

        def do_stuff
          publish 'root.parent.children', 1, 2, 3
        end
      end
    end

    it 'calls only the topics that match' do
      a = A.new
      b = B.new
      c = C.new

      b.do_stuff

      c.do_stuff
    end
  end
end
