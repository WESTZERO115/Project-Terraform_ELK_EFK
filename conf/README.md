# ELK 스택과 Kafka을 이용한 로그 분석

<details>
<summary>  AWS 인스턴스 </summary>
<div markdown="1">
  <br>
  
  - 버지니아 북부(us-east-1) <br>
  - Ubuntu 20.04 버전 <br>
  - t2.xlarge(CPU 4개, RAM 8GB) 
  - 볼륨 15GB 
</div>
</details>

<details>
<summary>  JAVA 설치 </summary>
<div markdown="1">
  <br>
  Elasticsearch 가 Apache Lucene 기반으로 구축되어있어서 분산형 및 개방형이다.

Lucene이 JAVA로 개발되었고 Elasticsearch도 JAVA로 개발되었기 때문에 ELK스택을 사용하기 위해서는 JAVA를 설치해야 한다.
```shell
# apt 업데이트를 한다
sudo apt-get update && sudo apt-get upgrade

# java를 설치한다
sudo apt-get install openjdk-11-jdk

# 환경변수를 확인한다
ubuntu@ip-172-31-23-120:~$ echo $JAVA_HOME
/usr/local/jdk-11

ubuntu@ip-172-31-23-120:~$ $JAVA_HOME/bin/javac -version
javac 11
```
</div>
</details>

<details>
<summary>  ELK 설치 </summary>
<div markdown="1">
  <br>
  
 - Elasticsearch 설치

```bash
# GPG 키를 추가한다
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list

# elasticsearch를 설치한다
sudo apt install elasticsearch

# elasticsearch를 실행한다
sudo systemctl enable elasticsearch
sudo systemctl start elasticsearch
systemctl status elasticsearch
```

  - Kibana 설치

```bash
# kibana를 설치한다
sudo apt install kibana

# kibana를 실행한다
systemctl enable kibana
systemctl start kibana
systemctl status kibana
```

- Logstash 설치

```bash
# logstash를 설치한다
sudo apt install logstash

# logstash를 실행한다
systemctl enable logstash
systemctl start logstash
systemctl status logstash
```
</div>
</details>

<details>
<summary>  Kafka 설치 </summary>
<div markdown="1">
  <br>
  
 ```bash
cd /opt

# kafka를 설치한다
sudo wget https://dlcdn.apache.org/kafka/3.2.0/kafka_2.12-3.2.0.tgz
  
# 압축을 푼다
sudo tar xvzf kafka_2.12-3.2.0
  
# kafka를 실행한다
sudo systemctl daemon-reload
sudo systemctl start kafka
sudo systemctl status kafka

```
  
</div>
</details>



### logstash 실행

```bash
ubuntu@ip-172-31-23-120:~$ sudo -u logstash /usr/share/logstash/bin/logstash --path.settings /etc/logstash -t

Using bundled JDK: /usr/share/logstash/jdk
OpenJDK 64-Bit Server VM warning: Option UseConcMarkSweepGC was deprecated in version 9.0 and will likely be removed in a future release.
Sending Logstash logs to /var/log/logstash which is now configured via log4j2.properties
[2022-07-21T13:38:16,683][INFO ][logstash.runner ] Log4j configuration path used is: /etc/logstash/log4j2.properties
[2022-07-21T13:38:16,693][INFO ][logstash.runner ] Starting Logstash {"logstash.version"=>"7.17.5", "jruby.version"=>"jruby 9.2.20.1 (2.5.8) 2021-11-30 2a2962fbd1 OpenJDK 64-Bit Server VM 11.0.15+10 on 11.0.15+10 +indy +jit [linux-x86_64]"}
[2022-07-21T13:38:16,695][INFO ][logstash.runner ] JVM bootstrap flags: [-Xms1g, -Xmx1g, -XX:+UseConcMarkSweepGC, -XX:CMSInitiatingOccupancyFraction=75, -XX:+UseCMSInitiatingOccupancyOnly, -Djava.awt.headless=true, -Dfile.encoding=UTF-8, -Djdk.io.File.enableADS=true, -Djruby.compile.invokedynamic=true, -Djruby.jit.threshold=0, -Djruby.regexp.interruptible=true, -XX:+HeapDumpOnOutOfMemoryError, -Djava.security.egd=file:/dev/urandom, -Dlog4j2.isThreadContextMapInheritable=true]
[2022-07-21T13:38:18,187][INFO ][org.reflections.Reflections] Reflections took 72 ms to scan 1 urls, producing 119 keys and 419 values
Configuration OK
[2022-07-21T13:38:19,031][INFO ][logstash.runner ] Using config.test_and_exit mode. 
**Config Validation Result: OK. Exiting Logstash**
```
<img width="800" height="300" alt="15" src="https://user-images.githubusercontent.com/70850937/185789649-bc4aab90-5998-4727-a053-838749eede05.png">

구문 오류가 없으면 `Config Validation Result: OK. Exiting Logstash` 가 출력된다.

### Filebeat 수집 파이프라인을 설정

Logstash를 통해 Elasticsearch로 보내기 전에 로그 데이터를 구문 분석하는 Filebeat 수집 파이프라인을 설정한다. 시스템 모듈에 대한 수집 파이프라인을 로드한다.

```shell
ubuntu@ip-172-31-23-120:~$ sudo filebeat setup --index-management -E output.logstash.enabled=false -E 'output.elasticsearch.hosts=["localhost:9200"]'

Overwriting ILM policy is disabled. Set `setup.ilm.overwrite: true` for enabling.

Index setup finished.
```

<img width="900" height="100" alt="15" src="https://user-images.githubusercontent.com/70850937/185789752-c45aa150-87e7-487d-8eb0-15831943b370.png">


### 인덱스 템플릿을 Elasticsearch에 로드

```shell
ubuntu@ip-172-31-23-120:~$ sudo filebeat setup -E output.logstash.enabled=false -E output.kafka.hosts=['localhost:9092'] -E setup.kibana.host=localhost:5601
Overwriting ILM policy is disabled. Set `setup.ilm.overwrite: true` for enabling.localho

Index setup finished.
Loading dashboards (Kibana must be running and reachable)
Loaded dashboards
Setting up ML using setup --machine-learning is going to be removed in 8.0.0. Please use
See more: https://www.elastic.co/guide/en/machine-learning/current/index.html
It is not possble to load ML jobs into an Elasticsearch 8.0.0 or newer using the Beat.
Loaded machine learning job configurations
Loaded Ingest pipelines
```

`It is not possble to load ML jobs into an Elasticsearch 8.0.0 or newer using the Beat.`

오류문구로 보이지만 신경쓰지 않아도 된다.
<br>

### Elasticsearch 인덱스 생성 확인

```shell
ubuntu@ip-172-31-23-120:~$ curl localhost:9200/_cat/indices?v
```

<img width="800" height="250" alt="15" src="https://user-images.githubusercontent.com/70850937/185791798-f775e07d-50e1-4e92-8860-691e4074bfc8.png">

msg_log `docs.count` 21개 생성되었다.
<br>

### log 내용 확인

```basdh
ubuntu@ip-172-31-23-120:~$ cat /var/log/nginx/access.log
```

<img width="800" height="250" alt="15" src="https://user-images.githubusercontent.com/70850937/185791896-45070234-e6b6-49c6-aa5f-a1c3019daf7c.png">


### Kibana dashboard 확인
<img width="900" height="350" alt="15" src="https://user-images.githubusercontent.com/70850937/185791869-026cc5cd-4c50-4916-83a6-c5a5f9184c9a.png">


