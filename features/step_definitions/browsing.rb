Then /I should see a link to all posts tagged "([\w\s]+)"/ do |tag_name|
  page.should have_xpath("//a[contains(@href, \"/#{tag_name}\")]")
end
