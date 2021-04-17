# origin-api

### Description
Api to determines the user’s risk profile using the data provided and then suggests an insurance plan `("economic", "regular", "responsible")` corresponding to her risk profile.

This api runs on docker with MYSQL and Ruby on Rails.


### Model description

The project has 4 tables:
`personal_informations, risk_questions, vehicles, houses`

The personal_informations table has many vehicles, houses and one risk_questions with 3 questions.

With this information we can run the risk algorithm and suggests an insurance plan.

### Important folders
```
app 
* controllers
* models
* services

db 
* migrate
* schema

spec 
* api
* services

coverage
* index.html -> we can see the coverage from the test

config
* routes.rb
* database.yml
```

### Executing the project:

Run the `run_origin.sh` script
```
$ sh run_origin.sh
```

Or do the manual steps

Build the container images
```
$ docker-compose build
```

Start running the containers
```
$ docker-compose up -d
```

Create the database
```
$ docker-compose run api rake db:create
```

Execute database migration
```
$ docker-compose run api rake db:migrate
```

Migrate database for test env
```
$ docker-compose run api rake db:migrate RAILS_ENV=test
```

Executing tests
```
$ docker-compose run -e RAILS_ENV=test api rspec
```

The service will run on `port 3000` and you can see the test coverage page in `coverage/index.html`

To see the logs you can attach
```
$ docker attach origin_api 
```

You can stop the docker running
```
$ docker-compose stop
```


### Create risk profile:

#### Route: /personal_informations

Method: POST

Parameters:

```
{
  "age": 35,
  "dependents": 2,
  "house": {"ownership_status": "owned"},
  "income": 0,
  "marital_status": "married",
  "risk_questions": [0, 1, 0],
  "vehicle": {"year": 2018}
}
```

Success return example:

```
{
    "auto": "regular",
    "disability": "ineligible",
    "home": "economic",
    "life": "regular"
}
```

You can run the CURL to see the same result
```
curl -X POST \
  http://localhost:3000/personal_informations \
  -H 'content-type: application/json' \
  -d '{
  "age": 35,
  "dependents": 2,
  "house": {"ownership_status": "owned"},
  "income": 0,
  "marital_status": "married",
  "risk_questions": [0, 1, 0],
  "vehicle": {"year": 2018}
}'
```