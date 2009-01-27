When /^I run cucumber "(.*)"$/ do |cmd|
  @dir = File.expand_path(File.join(File.dirname(__FILE__), '../..'))
  @full_cmd = "#{Cucumber::RUBY_BINARY} #{Cucumber::BINARY} #{cmd}"
  Dir.chdir(@dir)
  @out = `#{@full_cmd}`
end

Then /^value proposition should be a blockquote$/ do
  expected =<<EOS
<blockquote>
  In order to explain the velocity of domestic animals  
  Puts a dog in motion  
  So that people with short names can exclaim  
</blockquote>
EOS
  @out.should include(expected)
end

Then /^it should format the feature as an h1$/ do
  @out.should include('h1. Feature')
end

Then /^it should format the feature name as an h2$/ do
  @out.should include("h2. Feature: A children's book")
end

Then /^it should format the scenario name as an h3$/ do
  @out.should include("h3. Scenario: Running a scenario produces textilized output")
end

Then /^step names should be lists$/ do
  @out.should include('* 0 When "_Spot_" runs')
end

Then /^it should format placeholders as emphasized$/ do
  @out.should include('When "_Spot_" runs')
end
