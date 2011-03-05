Feature: Manage bookmarks
  In order to manage bookmarks
  I want to be able to add and remove bookmarks
  
  Scenario: Register new bookmark
    Given I am on the new bookmark page
    When I fill in "Url" with "url 1"
    And I fill in "Tags" with "tags 1"
    And I press "Create"
    Then I should see "url 1"
    And I should see "tags 1"

  Scenario: Delete bookmark
    Given the following bookmarks:
      |url|tags|
      |url 1|tags 1|
      |url 2|tags 2|
      |url 3|tags 3|
      |url 4|tags 4|
    When I delete the 3rd bookmark
    Then I should see the following bookmarks:
      |Url|Tags|
      |url 1|tags 1|
      |url 2|tags 2|
      |url 4|tags 4|
