[![codecov](https://codecov.io/gh/openstax/sfapi/branch/main/graph/badge.svg?token=3EZY8CK0ZE)](https://codecov.io/gh/openstax/sfapi)

# SFAPI \
The OpenStax Salesforce API - for easier access to Salesforce Org data.

### Getting Started
_Use the following checklist to get up and running with SFAPI for local development quickly!_

- [ ] Install PostgreSQL and Ruby (>3.0). It's recommended to use rbenv to manage your Ruby versions.
- [ ] Run the following where you'd like to install SFPI

```
$> git checkout https://github.com/openstax/sfapi.git
$> gem install bundler
$> bundle install
$> createdb sfapi_dev
$> createdb sfapi_test
$> bundle exec rake db:migrate
```

- [ ] Copy the .env.example file to .env and fill in the secrets needed.

### Running tests
You can run the tests with `$> bundle exec rspec`

### Project Documentation
Documentation is in the [repo wiki](https://github.com/openstax/openstax-salesforce-api/wiki)

## Deployment
To deploy SFAPI, you will need to use the [BIT Deployment Repo](https://github.com/openstax/bit-deployment).
You can find detailed deployment instructions in [this wiki entry](https://github.com/openstax/bit-deployment/wiki/Deploying-BIT-Applications)
