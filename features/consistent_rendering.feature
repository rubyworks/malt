Feature: Consistant rendering across all template engines.
  As a developer
  In order to render templates
  I want to have my choice of template engines
  And I want all templates to behave consistently

  Scenario: Template with Binding Scope
    Given an equivalent template for each engine
    And a Binding for scope
    When the template is rendered
    Then the result is the same for each

  Scenario: Template with Object Scope
    Given an equivalent template for each engine
    And a Object for scope
    When the template is rendered
    Then the result is the same for each

  Scenario: Template with Struct Scope
    Given an equivalent template for each engine
    And a Struct for scope
    When the template is rendered
    Then the result is the same for each

  Scenario: Template with Hash Locals
    Given an equivalent template for each engine
    And only a Hash for locals
    When the template is rendered
    Then the result is the same for each

  Scenario: Template with OpenStruct Locals
    Given an equivalent template for each engine
    And only a OpenStruct for locals
    When the template is rendered
    Then the result is the same for each

  Scenario: Template with Binding Scope and Hash Locals
    Given an equivalent template for each engine
    And a Binding for scope
    And a Hash for locals
    When the template is rendered
    Then the result is the same for each

  Scenario: Template with Object Scope and Hash Locals
    Given an equivalent template for each engine
    And a Object for scope
    And a Hash for locals
    When the template is rendered
    Then the result is the same for each

  Scenario: Template with Stuct Scope and Hash Locals
    Given an equivalent template for each engine
    And a Struct for scope
    And a Hash for locals
    When the template is rendered
    Then the result is the same for each

  Scenario: Template with OpenStruct Scope and Hash Locals
    Given an equivalent template for each engine
    And a OpenStruct for scope
    And a Hash for locals
    When the template is rendered
    Then the result is the same for each

  Scenario: Template with Hash Scope and Hash Locals
    Given an equivalent template for each engine
    And a Hash for scope
    And a Hash for locals
    When the template is rendered
    Then the result is the same for each

