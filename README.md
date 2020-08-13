[![codecov](https://codecov.io/gh/openstax/openstax-salesforce-api/branch/master/graph/badge.svg)](https://codecov.io/gh/openstax/openstax-salesforce-api)

# OpenStax Salesforce API

### Getting Started
Make sure you have postgresql and ruby (>2.5) installed on your system.
 
```
$> git checkout https://github.com/openstax/openstax-salesforce-api.git
$> gem install bundler
$> bundle install
$> createdb openstax_salesforce_api_development
$> createdb openstax_salesforce_api_test
$> bundle exec rake db:migrate
$> bundle exec rake db:seed
```

### Running tests
You can run the tests with `$> bundle exec rspec`

#### Local development testing with .env file
Using a .env file with Salesforce credentials allows developers to test using data from the Salesforce sandbox. This should not be used for Travis and the .env file should not be committed to Github. There is a .env-sample file to get you started.

The steps are
 - Create a .env file and copy the Salesforce fields in .env-sample to your .env file
 - Fill in the needed credentials from the Salesforce sandbox. **DO NOT USE PRODUCTION CREDENTIALS.**
 - The .env file is already blocked in .gitignore. Make sure this does not change. **DO NOT COMMIT YOUR .env FILE.**
 - Code needing to connect via the openstax_salesforce gem should now have access to the Salesforce Sandbox.
 - Any specs should use mocked data, not the .env file 
 
### Pull Salesforce data using Rake task

There are 8 rake tasks to pull data from Salesforce. Seven of the tasks are for each object type and one to load all data.

The commands for the tasks are:

* books: `rake salesforce:update_books`
* campaign members: `rake salesforce:update_campaign_members`
* campaigns: `rake salesforce:update_campaigns`
* contacts: `rake salesforce:update_contacts`
* leads: `rake salesforce:update_leads`
* opportunities: `rake salesforce:update_opportunities`
* schools: `rake salesforce:update_schools`
* update all: `rake salesforce:update_all`


