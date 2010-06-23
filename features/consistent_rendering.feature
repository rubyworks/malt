Feature: Consistant rendering across all template engines.
  As a developer
  In order to render templates
  I want to have my choice of template engines
  And I want all templates to behave consistently

  Scenario: Template with Binding Data Source
    Given an equivalent template for each engine
    And a Binding for a data source
    When the template is rendered
    Then the result is the same for each

  Scenario: Template with Object Data Source
    Given an equivalent template for each engine
    And a Object for a data source
    When the template is rendered
    Then the result is the same for each

  Scenario: Template with Struct Data Source
    Given an equivalent template for each engine
    And a Struct for a data source
    When the template is rendered
    Then the result is the same for each

  Scenario: Template with Hash Date Source
    Given an equivalent template for each engine
    And a Hash for a data source
    When the template is rendered
    Then the result is the same for each

  Scenario: Template with OpenStruct Locals
    Given an equivalent template for each engine
    And a OpenStruct for a data source
    When the template is rendered
    Then the result is the same for each

