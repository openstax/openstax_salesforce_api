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

### Project Documentation
Documentation is in the [repo wiki](https://github.com/openstax/openstax-salesforce-api/wiki)

## Deployment
To deploy SFAPI, you will need to use the [BIT Deployment Repo](https://github.com/openstax/bit-deployment).
You can find detailed deployment instructions in [this wiki entry](https://github.com/openstax/bit-deployment/wiki/Deploying-BIT-Applications)
