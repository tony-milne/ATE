Feature: Manage bookmarks
  In order to manage bookmarks
  I want to be able to add and remove bookmarks
  
  Scenario: Register new bookmark
    Given I am on the new bookmark page
    When I fill in "Url" with "http://www.slashdot.org/"
    And I fill in "Tags" with "news nerds"
    And I press "Create"
    Then I should see "http://slashdot.org"
    And I should see "news nerds"

  Scenario: Delete bookmark
    Given the following bookmarks:
      |url|tags|
      |http://www.lifehacker.com|tips money-saving diy|
      |http://www.facebook.com|social-networking|
      |http://www.spotify.com/uk|music social free|
      |http://www.slashdot.com|news nerds current|
    When I delete the 3rd bookmark
    When I go to the bookmarks page
    Then show me the page
