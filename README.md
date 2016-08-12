#### Get the code and create a Heroku app
```
git clone
cd kafka-connect-twitter
heroku create
```

#### Create Kafka cluster or attach existing cluster
- Create: `heroku addons:create heroku-kafka:beta-standard-0`
- Attach: `heroku addons:attach my-originating-app::KAFKA` (where "my-originating-app" is an app to which the cluster is already attached)

#### Setup required Kafka environment variables
```
heroku config:set KAFKA_HEAP_OPTS=-Xmx4g
heroku config:set KEYSTORE_PASSWORD=changeit
heroku config:set TRUSTSTORE_PASSWORD=changeit
```

#### Setup required Twitter environment variables after creating a Twitter application
To obtain the required keys, visit https://apps.twitter.com/ and `Create a New App`. Fill in an application name & description & web site and accept the developer aggreement. Click on `Create my access token` and populate the below environment variables with consumer key & secret and the access token & token secret.
```
heroku config:set TWITTER_CONSUMER_KEY=
heroku config:set TWITTER_CONSUMER_SECRET=
heroku config:set TWITTER_SECRET=
heroku config:set TWITTER_TOKEN=
```

#### Define environment variable containing terms to track in tweets ([more details](https://dev.twitter.com/streaming/overview/request-parameters#track))
```
heroku config:set TWITTER_TRACK_TERMS=news,music,hadoop,clojure,scala,fp,golang,python,fsharp,cpp,java
```

#### Deploy to Heroku
```
git push heroku master
```
