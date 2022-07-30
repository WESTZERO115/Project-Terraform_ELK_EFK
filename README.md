# 💻 테라폼으로 인프라 구축하고 ELK|EFK 모니터링 스택을 배포


## 주요 기능
1. IaC
</br>1.1 Terraform으로 AWS의 관리형 쿠버네티스인 EKS를 구축
</br>1.2 Terraform으로 AWS 레지스트리인 ECR과 EC2 인스턴스를 구축

2. Kubernetes & ELK | EFK
</br>2.1  위에 EFK Stack 구축, Nginx pod의 로그 수집 
</br>2.2 Filebeat + Kafka + ELK Stack 구축, EKS에 배포한 Nginx 웹 서버 로그 수집 

3. Visualization & Analysis - Kibana 대시보드를 통해 로그를 시각화하여 분석

## 적용 기술
### - Terraform
<img width="50" height="50" alt="5" src="https://user-images.githubusercontent.com/65750746/181904360-2c2e2806-57dd-4f73-a1d5-af4d06117ad0.png">
인프라를 손쉽게 구축하고 안전하게 변경하고, 효율적으로 인프라의 형상을 관리할 수 있는 IaC 오픈소스 도구이다.
변경 계획 명령어(terraform plan)와 변경 적용 명령어(terraform apply)를 분리하여 변경 내용을 적용할 때 발생할 수 있는 실수를 줄일 수 있다.
<br>

### - AWS (ECR, EKS)
<img width="50" height="50" alt="5" src="https://user-images.githubusercontent.com/65750746/181905171-7c4fe95d-230e-42b1-a30b-6d3e95959249.png">
CSP 중 가장 높은 점유율을 가지고 있고, 개발자 생태계를 튼튼하게 구축하고 있다.<br>
ECR은 확장 가능하고 신뢰할 수 있는 AWS 관리형 컨테이너 이미지 레지스트리 서비스이다. AWS IAM을 사용하여 리소스 기반 권한을 가진 프라이빗 레퍼지토리를 지원한다.<br>
EKS는 AWS가 제공하는 쿠버네티스용 컨테이너 서비스이다. etcd 관리 및 백업 등의 작업을 대신해주기 때문에 사용자는 마스터 노드를 신경쓰지 않아도 된다.
<br>

### - EFK 스택 (ElasticSearch + Fleuntd + Kibana)
ElasticSearch는 검색 및 분석 엔진이다. 실시간으로 데이터를 처리할 수 있고, 모듈의 기능이 각각 달라서 다른 모듈로 변경 가능하다.<br>
Kibana는 차트와 그래프를 이용해 데이터를 시각화해주는 대시보드이다.<br>
Fluentd는 로그 수집기이다. 전달된 데이터를 tag, time, record(JSON) 로 구성된 이벤트로 처리하며, 원하는 형태로 가공하여 다양한 목적지(Elasticsearch, S3, HDFS 등)로 전달한다.

### - ELK 스택 (ElasticSearch + Logstash + Kibana) + Filebeat + Kafka
Logstash는 데이터 처리 파이프라인으로, 여러 소스로부터 데이터를 동시에 수집해서 ElasticSearch와 같은 stash로 전송한다.<br>
Filebeat는 경량 로그 수집기로, 중앙집중화하여 작업을 보다 간편하게 만들어준다. CPU, RAM 등의 리소스를 적게 소모한다.<br>
Kafka는 대용량 실시간 로그처리에 특화된 메시징 플랫폼이다. 스트리밍 데이터를 처리하기 용이하고, 메세지를 영구적으로 저장하기 때문에 메세지 손실이 발생하지 않는다.
트래픽이 몰리면 Logstash, Elasticsearch 만으로는 부하를 견디기 힘들기 때문에 ELK 스택의 경우 Kafka를 연동하였다.

<img src="https://user-images.githubusercontent.com/65750746/177522606-f00fc607-3fb1-4f9e-9b33-d40cf3496e87.png" width="700" height="300"/>
<br>
Logstash는 모놀리식한 시스템의 로깅 파이프라인으로 주로 사용하고, Fluentd는 마이크로 서비스 아키텍처를 사용한 시스템에서 주로 사용한다.
<br/>

## 구성도
<img width="1058" alt="스크린샷 2022-07-30 오후 6 02 10" src="https://user-images.githubusercontent.com/65750746/181903494-c3bf810b-151f-449f-bf0f-e6346a150449.png">

### - Nginx
Nginx는 웹 서버 소프트웨어이다.
<br>아파치(Apache)가 요청 하나 당 스레드 하나를 처리하는 반면, Nginx는 비동기 Event-Driven 기반 구조로 더 작은 스레드로 클라이언트의 요청들을 처리 가능하다.


## 결과물 
kibana 대시보드 화면 - nginx 액세스 로그
<img width="1171" alt="스크린샷 2022-07-30 오후 6 38 00" src="https://user-images.githubusercontent.com/65750746/181904644-712adeab-a50b-4160-8cfb-516dd7bed17b.png">


### Contributors
<table>
  <tr>
    <td align="center"><a href="https://github.com/HYERIN0718"><img src="https://avatars.githubusercontent.com/u/70850937?v=4" width="100px;" alt=""/><br /><sub><b>이혜린</b></sub></a><br/></td>
    <td align="center"><a href="https://github.com/WESTZERO115"><img src="https://avatars.githubusercontent.com/u/65750746?v=4" width="100px;" alt=""/><br /><sub><b>박서영</b></sub></a><br/></td>
  </tr>
  </table>
