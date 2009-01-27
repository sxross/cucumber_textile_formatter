Feature: Cucumber textile output
  In order to communicate stories more rapidly
  Developers should be able to format them in textile
  So that they can splat them up onto Github real quick-like

  Scenario: Running a scenario produces textilized output
    When I run cucumber "examples -ftextile"
    Then it should format the feature as an h1
    Then value proposition should be a blockquote
    And it should format the feature name as an h2
    And it should format the scenario name as an h3
    And step names should be lists
    And it should format placeholders as emphasized
