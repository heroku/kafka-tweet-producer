#### Get the code
```
git clone git@github.com:heroku/kafka-tweet-producer.git
cd kafka-tweet-producer
```

#### Create a Heroku app
You can create an app in one of the following two ways.  If you're ok with Heroku's randomly generated app name
```
heroku create
```

If you want to create your own app name
```
heroku create my-awesome-app-name
```
#### Create Kafka cluster *or* attach existing cluster
- Create: `heroku addons:create heroku-kafka:standard-0`
- Attach: `heroku addons:attach my-originating-app::KAFKA` (where "my-originating-app" is an app to which the cluster is already attached) If you created a new cluster, wait until it is ready to use.
This command will read you a quote from Franz Kafka when the cluster is ready to use.
_Note: if you do not already have the heroku-kafka plugin installed, you will need to do so._```
heroku plugins:install heroku-kafka
```

```
heroku kafka:wait; say $(curl kafkafra.nz)
```

#### Create a Kafka topic and configure. I use the name `test` here but you can use any [valid Kafka topic name](https://github.com/apache/kafka/blob/trunk/core/src/main/scala/kafka/common/Topic.scala#L29-L31).
```
heroku kafka:topics:create test --partitions 1
```
Creating a new topic takes some time.  Use the same command "wait" command to wait until it's done, then set this environment variable with the name of the topic.
```
heroku kafka:wait; say $(curl kafkafra.nz)
heroku config:set KAFKA_TOPIC=test
```

#### Setup the required environment variables for this Kafka Producer
```
heroku config:set KAFKA_HEAP_OPTS=-Xmx1g
heroku config:set KEYSTORE_PASSWORD=changeit
heroku config:set TRUSTSTORE_PASSWORD=changeit
heroku config:set CLASSPATH="/app/target/kafka-connect-twitter-0.1-jar-with-dependencies.jar"
```

#### Setup required Twitter environment variables after creating a Twitter application
To obtain the required keys, visit https://apps.twitter.com/ and `Create a New App`. Fill in an application name & description & web site and accept the developer aggreement. Click on `Create my access token` and populate the below environment variables with consumer key & secret and the access token & token secret.

```
heroku config:set TWITTER_CONSUMER_KEY=
heroku config:set TWITTER_CONSUMER_SECRET=
heroku config:set TWITTER_ACCESS_TOKEN=
heroku config:set TWITTER_ACCESS_TOKEN_SECRET=
```

#### Define environment variable containing terms to track in tweets ([more details](https://dev.twitter.com/streaming/overview/request-parameters#track))
```
heroku config:set TWITTER_TRACK_TERMS=news,music,hadoop,clojure,scala,fp,golang,python,fsharp,cpp,java
```

#### Deploy to Heroku and scale-up the dyno type! (A dyno with at least 1GB of RAM -- i.e standard-2x -- is recommended.)
```
git push heroku master
heroku ps:scale web=1:standard-2x
```

### Thanks and License
This repo is mostly code from [Eneco/kafka-connect-twitter](https://github.com/Eneco/kafka-connect-twitter) but configured to be easily deployable to Heroku and use an [Apache Kafka on Heroku](https://heroku.com/kafka) cluster.  The license for that code can be found [here](https://github.com/Eneco/kafka-connect-twitter/blob/develop/LICENSE).

Additionally, [check here](https://github.com/Eneco/kafka-connect-twitter/compare/af63e4c...HEAD) to see what, if any, changes have been made to the [Eneco/kafka-connect-twitter](https://github.com/Eneco/kafka-connect-twitter) repo since its code was copied to this repo.
