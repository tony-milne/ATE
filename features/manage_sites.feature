Feature: View sites
  In order to browse sites
  I want to view bookmarks associated with a site
  
  Scenario: Register new site
    Given I am on the new bookmark page
    When I fill in "Url" with "http://yro.slashdot.org/story/11/03/08/0029211/China-Pledges-To-Step-Up-Internet-Administration/"
    And I press "Create"
    Then I go to the sites page
    And follow "Show"
    Then I should see "yro.slashdot.org"
    And I should see "http://yro.slashdot.org/story/11/03/08/0029211/China-Pledges-To-Step-Up-Internet-Administration/"
