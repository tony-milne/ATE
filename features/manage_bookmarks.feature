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

  # Rails generates Delete links that use Javascript to pop up a confirmation
  # dialog and then do a HTTP POST request (emulated DELETE request).
  #
  # Capybara must use Culerity/Celerity or Selenium2 (webdriver) when pages rely
  # on Javascript events. Only Culerity/Celerity supports clicking on confirmation
  # dialogs.
  #
  # Since Culerity/Celerity and Selenium2 has some overhead, Cucumber-Rails will
  # detect the presence of Javascript behind Delete links and issue a DELETE request 
  # instead of a GET request.
  #
  # You can turn this emulation off by tagging your scenario with @no-js-emulation.
  # Turning on browser testing with @selenium, @culerity, @celerity or @javascript
  # will also turn off the emulation. (See the Capybara documentation for 
  # details about those tags). If any of the browser tags are present, Cucumber-Rails
  # will also turn off transactions and clean the database with DatabaseCleaner 
  # after the scenario has finished. This is to prevent data from leaking into 
  # the next scenario.
  #
  # Another way to avoid Cucumber-Rails javascript emulation without using any
  # of the tags above is to modify your views to use <button> instead. You can
  # see how in http://github.com/jnicklas/capybara/issues#issue/12
  #
  Scenario: Delete bookmark
    Given the following bookmarks:
      |url|tags|
      |http://www.lifehacker.com|tips money-saving diy|
      |http://www.facebook.com|social-networking|
      |http://www.spotify.com/uk|music social free|
      |http://www.slashdot.com|news nerds current|
    When I delete the 3rd bookmark
    Then I should see the following bookmarks:
      |Url|Tags|
      |http://uk.lifehacker.com/|tips money-saving diy|
      |http://www.facebook.com/|social-networking|
      |http://slashdot.org/|news nerds current|
