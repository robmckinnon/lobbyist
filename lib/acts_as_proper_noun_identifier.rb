module Acts

  module ProperNounIdentifier

    def self.included(base) # :nodoc:
      base.extend ClassMethods
    end

    module ClassMethods
      def clean_last_word list
        if noun = list.last
          if part = noun.pop
            if part[/^(.+)(\.|,)$/]
              part = $1
            end
            noun << part
          end
        end
      end

      def add_word list, word
        noun = list.pop
        if noun
          noun << word
          list << noun
        end
      end

      def end_check list, word, state
        if word[/^(.+)(\;|\.)$/]
          noun = list.last
          word = noun.pop
          noun << $1
          state = :not_proper
        end
        state
      end

      CONJUNCTIONS = ['for', 'and'].inject({}) {|h,x| h[x]=true; h }

      def proper_nouns text, options={}
        ignore_list = options[:ignore] || []
        list = []
        conjunctions = []
        numbers = []
        state = :not_proper

        text.split.each do |word|
          if word[/^(\d+)(\.|\))?$/]
            case state
              when :proper
                add_word list, $1
              else
                numbers << word
                state = :number
            end
            state = end_check(list, word, state)
          elsif word[/^\(?[A-Z].+\)?$/]
            if ignore_list.include?(word)
              state = :not_proper
            else
              case state
                when :number
                  list << [numbers.pop]
                  state = :proper
                  add_word list, word
                when :conjunction
                  add_word list, conjunctions.pop
                  state = :proper
                  add_word list, word
                when :not_proper
                  clean_last_word list
                  state = :proper
                  list << [word]
                when :proper
                  add_word list, word
              end
            end
            state = end_check(list, word, state)
          elsif CONJUNCTIONS[word]
            conjunctions << word
            state = :conjunction
          else
            state = :not_proper
          end

          # puts "#{state}: #{word}#{list.last ? ' -> '+list.last.join(' ') : ''}"
        end

        clean_last_word list
        list.collect{|x| x.join(' ')}
      end
      # def acts_as_proper_noun_identifier(options={})
        # include Acts::ProperNounIdentifier::InstanceMethods
      # end
    end

    module InstanceMethods
      # def proper_nouns text
      # end
    end

  end
end

# ActiveRecord::Base.send(:include, Acts::ProperNounIdentifier)
