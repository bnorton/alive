# alive
A Deployable Service™ that runs scheduled assertions on fetched HTTP content.

[![Build Status](https://semaphoreci.com/api/v1/projects/78e05d06-ff0e-49b8-80af-eef7f10078a4/468309/badge.svg)](https://semaphoreci.com/bnorton/alive)  
[![Circle CI](https://circleci.com/gh/bnorton/alive.svg?style=svg)](https://circleci.com/gh/bnorton/alive)
<!-- [![Build Status](https://semaphoreci.com/api/v1/projects/{{semaphoreci project id}}/badge.svg)](https://semaphoreci.com/{{username}}/alive) -->
<!-- [![Circle CI](https://circleci.com/gh/{{username}}/alive.svg?style=svg)](https://circleci.com/gh/{{username}}/alive) -->

#Direct Usage

- Fork bnorton/alive from GitHub to {{username}}
- Rename all instances of `{{username}}` with yours

```bash
git clone git@github.com:{{username}}/alive.git
heroku create {{username}}-alive
```

- Add a MongoDB database => `heroku addons:create mongohq`
- Add a username and password for the new mongo database
- Add a Redis database => `heroku addons:create heroku-redis:hobby-dev`

```bash
heroku config # and grab your mongodb url
heroku config:set RAILS_ENV=production RACK_ENV=production
heroku config:set MONGODB_URL={{mongodb url}}
heroku config:set REDIS_URL={{redis url}}
heroku config:set SECRET_KEY_BASE=$(rake secret)
```

- Deploy your first version with `git push heroku master`
- If setting up CircleCI with heroku deployment modify `circle.yml` to have your app-name

# Making Customizations (+ pull request)

To run the RSpec / Capybara tests you'll need:
- `phantomjs` installed
- `bundle install` (maybe `gem install bundler` first)
- `rake` runs the existing test suite
- Add tests
- Run tests
- Add implementation
- Run tests
- Commit / Push / Pull request

# Reporting Complex Issues
- Isolate the problem logically
- Isolate the problem with a failing test
