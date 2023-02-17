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
├─aws-eks-efs-config
│  ├─.terraform
│  │  ├─modules
│  │  └─providers
│  │      └─registry.terraform.io
│  │          ├─gavinbunney
│  │          │  └─kubectl
│  │          │      └─1.14.0
│  │          │          └─windows_amd64
│  │          ├─hashicorp
│  │          │  ├─aws
│  │          │  │  └─4.47.0
│  │          │  │      └─windows_amd64
│  │          │  ├─helm
│  │          │  │  └─2.8.0
│  │          │  │      └─windows_amd64
│  │          │  ├─kubernetes
│  │          │  │  └─2.16.1
│  │          │  │      └─windows_amd64
│  │          │  ├─null
│  │          │  │  └─3.2.1
│  │          │  │      └─windows_amd64
│  │          │  ├─random
│  │          │  │  └─3.4.3
│  │          │  │      └─windows_amd64
│  │          │  └─tls
│  │          │      └─4.0.4
│  │          │          └─windows_amd64
│  │          └─openvpn
│  │              └─openvpn-cloud
│  │                  └─0.0.7
│  │                      └─windows_amd64
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
├─aws-vpc-vpn-config
│  ├─.terraform
│  │  ├─modules
│  │  └─providers
│  │      └─registry.terraform.io
│  │          └─hashicorp
│  │              ├─aws
│  │              │  └─4.47.0
│  │              │      └─windows_amd64
│  │              └─null
│  │                  └─3.2.1
│  │                      └─windows_amd64
│  ├─vpc
│  └─vpn(client)
├─kubernetes-config
│  ├─.terraform
│  │  ├─modules
│  │  └─providers
│  │      └─registry.terraform.io
│  │          └─hashicorp
│  │              ├─aws
│  │              │  ├─4.50.0
│  │              │  │  └─windows_amd64
│  │              │  └─4.54.0
│  │              │      └─windows_amd64
│  │              ├─helm
│  │              │  └─2.8.0
│  │              │      └─windows_amd64
│  │              ├─kubernetes
│  │              │  └─2.16.1
│  │              │      └─windows_amd64
│  │              ├─null
│  │              │  └─3.2.1
│  │              │      └─windows_amd64
│  │              └─random
│  │                  └─3.4.3
│  │                      └─windows_amd64
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

## Add your files

- [ ] [Create](https://docs.gitlab.com/ee/user/project/repository/web_editor.html#create-a-file) or [upload](https://docs.gitlab.com/ee/user/project/repository/web_editor.html#upload-a-file) files
- [ ] [Add files using the command line](https://docs.gitlab.com/ee/gitlab-basics/add-file.html#add-a-file-using-the-command-line) or push an existing Git repository with the following command:

```
cd existing_repo
git remote add origin https://gitlab.com/kmja9803/devops.git
git branch -M main
git push -uf origin main
```

## Integrate with your tools

- [ ] [Set up project integrations](https://gitlab.com/kmja9803/devops/-/settings/integrations)

## Collaborate with your team

- [ ] [Invite team members and collaborators](https://docs.gitlab.com/ee/user/project/members/)
- [ ] [Create a new merge request](https://docs.gitlab.com/ee/user/project/merge_requests/creating_merge_requests.html)
- [ ] [Automatically close issues from merge requests](https://docs.gitlab.com/ee/user/project/issues/managing_issues.html#closing-issues-automatically)
- [ ] [Enable merge request approvals](https://docs.gitlab.com/ee/user/project/merge_requests/approvals/)
- [ ] [Automatically merge when pipeline succeeds](https://docs.gitlab.com/ee/user/project/merge_requests/merge_when_pipeline_succeeds.html)

## Test and Deploy

Use the built-in continuous integration in GitLab.

- [ ] [Get started with GitLab CI/CD](https://docs.gitlab.com/ee/ci/quick_start/index.html)
- [ ] [Analyze your code for known vulnerabilities with Static Application Security Testing(SAST)](https://docs.gitlab.com/ee/user/application_security/sast/)
- [ ] [Deploy to Kubernetes, Amazon EC2, or Amazon ECS using Auto Deploy](https://docs.gitlab.com/ee/topics/autodevops/requirements.html)
- [ ] [Use pull-based deployments for improved Kubernetes management](https://docs.gitlab.com/ee/user/clusters/agent/)
- [ ] [Set up protected environments](https://docs.gitlab.com/ee/ci/environments/protected_environments.html)

***


Show your appreciation to those who have contributed to the project.

## License
For open source projects, say how it is licensed.

## Project status
If you have run out of energy or time for your project, put a note at the top of the README saying that development has slowed down or stopped completely. Someone may choose to fork your project or volunteer to step in as a maintainer or owner, allowing your project to keep going. You can also make an explicit request for maintainers.
