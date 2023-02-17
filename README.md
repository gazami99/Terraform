# Final Project Rebuilding

## aws resource provisioning using terraform

## Learning Objectives 
  
  1. 모듈 사용
  2. 하드코딩 지양
  3. terraform 에서 helm차트로 기본 툴 설치 (Grafana , Prometheus , Istio)
  4. 민감한 정보 관리법


## Workspace Naming

A good strategy to start with is `<COMPONENT>-<ENVIRONMENT>-<REGION>`

## Prerequisite

```
kubectl
aws cli
helm
```

## Structure
```

-------------------------------------------------
├─aws-vpc-vpn-config
│  ├─vpc
│  └─vpn(client)
----------------------------------------------------
├─aws-eks-efs-config
│  ├─efs
│  └─eks
│      ├─resourceSetting
│      │  └─templates
│      │      ├─aws
│      │      ├─charts
│      │      │  ├─config-gateway
│      │      │  │  └─templates
│      │      │  └─gatewayAPI
│      │      │      ├─crds
│      │      │      └─templates
│      │      └─istio
│      └─templates
│          └─iam
----------------------------------------------------
├─kubernetes-config
│  └─helm
│      ├─monitoring
│      │  └─templates
│      │      └─charts
│      │          └─config-monitoring
│      │              └─templates
│      └─sql
│          └─templates
│              └─charts
│                  ├─config-sql
│                  │  └─templates
│                  └─kubegres
│                      └─templates
```
</div>

<div align=center>
</div>
<div align=center>
<img src="https://github.com/gazami99/terraform/blob/main/image/arch2.png">
</div>




## Features

- g
