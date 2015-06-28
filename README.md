# alive
A Deployable Service™ that runs scheduled assertions on fetched HTTP content.


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

