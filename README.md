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

- deploy ec2  private subnet
- using vpn when private access mode is selected
- if eks needs aws resource, eks provides OIDC to grant pod auth to use the specific reosurce(alb,efs,...)
- recommend to use helm than yaml to configure kubernetes for robust structure
- use kubernetes Gateway API, experimental
- push docker image to github private repository instead of AWS ECR
- experimetal, because rds needs other teams rather than Iac team  configure your Sql in eks then other team construct rds in another vpc (need vpc peering)
