#### Get the code and create a Heroku app
```
git clone git@github.com:crcastle/kafka-tweet-producer.git
cd kafka-tweet-producer
heroku create
```

#### Create Kafka cluster *or* attach existing cluster
- Create: `heroku addons:create heroku-kafka:beta-standard-0`
- Attach: `heroku addons:attach my-originating-app::KAFKA` (where "my-originating-app" is an app to which the cluster is already attached)
If you created a new cluster, wait until it is ready to use.  This command will finish when the cluster is ready to use.
```
heroku kafka:wait
```

#### Create a Kafka topic and configure. I use the name `test` here but you can use any [valid Kafka topic name](https://github.com/apache/kafka/blob/trunk/core/src/main/scala/kafka/common/Topic.scala#L29-L31).
```
heroku kafka:create test
heroku config:set KAFKA_TOPIC=test
```

#### Setup the required environment variables for this Kafka Producer
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

#### Deploy to Heroku and scale-up the dyno type!
```
git push heroku master
h ps:scale web=1
heroku dyno:type standard-2x
```

### Thanks and License
This repo is mostly code from [Eneco/kafka-connect-twitter](https://github.com/Eneco/kafka-connect-twitter) but configured to be easily deployable to Heroku and use an Apache Kafka on Heroku cluster.  The license for that code can be found [here](https://github.com/Eneco/kafka-connect-twitter/LICENSE).

Additionally, [check here](https://github.com/Eneco/kafka-connect-twitter/compare/217b89cba3d90b9c6335672597fc828ff2e0c334...HEAD) to see what, if any, changes have been made to the [Eneco/kafka-connect-twitter](https://github.com/Eneco/kafka-connect-twitter) repo since its code was copied to this repo.
