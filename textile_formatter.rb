require 'cgi'

module Cucumber
  module Formatters
    class TextileFormatter
      def initialize(io, step_mother)
        @io = io
        @step_mother = step_mother
        @errors = []
        @scenario_table_header = []
      end

      def visit_features(features)
        @io.puts "\nh1. #{Cucumber.language['feature']}"
        features.accept(self)
      end

      def visit_feature(feature)
        feature.accept(self)
      end
      
      def visit_header(header)
        feature_lines = header.split("\n")
        @io.puts %{\nh2. #{feature_lines.shift}}
        @io.puts "<blockquote>"
        feature_lines.each{|f| @io.puts "#{f}  "}
        @io.puts "</blockquote>"
      end

      def visit_regular_scenario(scenario)
        @newline = false
        @io.print "\nh3. "
        visit_scenario(scenario, Cucumber.language['scenario'])
      end

      def visit_scenario_outline(scenario)
        visit_scenario(scenario, Cucumber.language['scenario_outline'])
      end

      def visit_row_scenario(scenario)
        @io.puts "#{Cucumber.language['scenario']}: #{scenario.name}"
        @scenario_table_header.each do |column_header|
          @io.puts %{#{column_header}}    # Should be a table
        end
        scenario.accept(self)
      end

      def visit_row_step(step)
        _, args, _ = step.regexp_args_proc(@step_mother)
        args = step.visible_args if step.outline?
        args.each do |arg|
          @io.puts %{#{step.id} #{arg}}
        end
      end

      def visit_regular_step(step)
        @io.puts "\n" if !@newline
        @newline = true
        regexp, _, _ = step.regexp_args_proc(@step_mother)
        @io.puts %{* #{step.id} #{step.keyword} #{step.format(regexp, '_%s_')}}
      end

      def visit_step_outline(step)
        regexp, _, _ = step.regexp_args_proc(@step_mother)
        @io.puts %{* #{step.id} #{step.keyword} #{CGI.escapeHTML(step.format(nil))}}
      end
      
      def step_passed(step, regexp, args)
        return  # noop right now
        @io.puts("stepPassed(#{step.id})")
      end
      
      def step_failed(step, regexp, args)
        return  # noop right now
        @errors << step.error
        @io.puts("stepFailed(#{step.id}, #{step.error.message.inspect}, #{step.error.backtrace.join("\n").inspect})")
      end
      
      def step_pending(step, regexp, args)
        return  # noop right now
        @io.puts("stepPending(#{step.id})")
      end
      
      def step_skipped(step, regexp, args)
        # noop
      end
      
      def step_traced(step, regexp, args)
        # noop
      end
      
      def dump
        # noop
      end
      
      private
      
      def visit_scenario(scenario, scenario_or_scenario_outline_keyword)
        @scenario_table_header = scenario.table_header
        @io.puts %{#{scenario_or_scenario_outline_keyword}: #{scenario.name}}
        scenario.accept(self)
      end
            
    end
  end
end
