Given /^the following sites:$/ do |sites|
  Site.create!(sites.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) site$/ do |pos|
  visit sites_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following sites:$/ do |expected_sites_table|
  expected_sites_table.diff!(tableish('table tr', 'td,th'))
end
