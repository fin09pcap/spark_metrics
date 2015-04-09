# Evaluation Spark Metric

This has been evalued with boot2docker and can be modified for a local docker
deployment on a docker compatible distribution or a vagrant instance.

The following docker images were utilized and can be pulled down from the
docker registry.

```
docker pull elasticsearch
docker pull logstash
```
The resources for the Docker Libary can be found below:
* [Logstash](https://github.com/docker-library/docs/tree/master/logstash)
* [ElasticSearch](https://github.com/docker-library/docs/tree/master/elasticsearch)

Within the directory contains an example of the _metrics.properties_ for a
Spark configuration. This is simply an example and should be modified to meet
the needs of the deployment.

## Docker Configuration

**NOTE:** This was tested with boot2docker on MacOSX. This should be modified for the
ports and url to point to the correct **_host ip_**.

### Logstash Container
The logstash configuration within the _/data_ directory labeled *spark.conf* contains
specific information for the graphite input and the output to ElasticSearch.

The following [code](./data/spark.conf) should be reviewed per the instructions above
for port configuration and ElasticSearch host. This correlates to the port
configuration for the docker command. The `-it` denotes that this will be ran
interactively and will output any errors to the console. It will additionally mount
the `./data` volume with the configuration file for within the logstash container.

The logstash container can be run via the command below:
```
docker run -it --rm -v "${PWD}/data":/data -p 8649:8649 -p 9292:9292 --name logstash
logstash:latest logstash -f /data/spark.conf web
```

### ElasticSearch Container
The configuration file, _elasticsearch.yml_ is the configuration file that is passed
to the container to run a specific configuration for ElasticSearch. This can be
modified based on the syntax from [Elastic](www.elastic.co)

The ElasticSearch container can be run via the command below:
```
docker run -d --name elasticseaerch -p 9200:9200 -p 9300:9300  -v "${PWD}/data":/data
elasticsearch:latest -Des.config=/data/elasticsearch.yml
```
Ensure the configuration has `http.cors.enabled=true` and allows for the respective
origins.

## Kibana 4
An alternative method is to download the existing Kibana 4 and following the
instructions provided and to point to the respective ElasticSearch container.

* Download [Kibana4](https://www.elastic.co/downloads/kibana)
* Configure the `elasticsearch_url` to point to the correct ElasticSearch instance or
    url.

The input of the metrics can be simulated by simply running a _spark-shell_ or
_spark-submit_ once the containers are running. The _spark-shell_ should
automatically start outputting errors based on inability to successfully post the
JSON payload.

...Questions and Comments are welcome...
