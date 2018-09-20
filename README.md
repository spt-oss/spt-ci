# SPT CI

[![circleci](https://img.shields.io/badge/circleci-spt--ci-brightgreen.svg)](https://circleci.com/gh/spt-oss/spt-ci)

* CI support scripts for AWS, Java, Node.js, etc.
* These scripts have been tested in [CircleCI 2.0 Pre-Built Docker Images](https://circleci.com/docs/2.0/circleci-images/).

## TOC

* [Products](#products)
* [Usage](#usage)
	* [Install AWS CLI](#install-aws-cli)
	* [Install Terraform](#install-terraform)
	* [Install Brotli](#install-brotli)
	* [Install Zopfli](#install-zopfli)
	* [Install Maven](#install-maven)
	* [Install New Relic for Java](#install-new-relic-for-java)
	* [Install GPG key](#install-gpg-key)
	* [Upload Docker image to Amazon ECR](#upload-docker-image-to-amazon-ecr)
	* [Update Docker task in Amazon ECS](#update-docker-task-in-amazon-ecs)
	* [Refine Maven build in CircleCI](#refine-maven-build-in-circleci)
* [License](#license)

## Products

* [Installer](https://github.com/spt-oss/spt-ci/tree/master/installer)

	| Name                        | Download URL                                     | Reference                                                                                                          |
	| ---                         | ---                                              | ---                                                                                                                |
	| install-aws-cli.sh          | https://spt.page.link/ci-install-aws-cli-sh      | [AWS CLI](https://github.com/aws/aws-cli)                                                                          |
	| install-terraform.sh        | https://spt.page.link/ci-install-terraform-sh    | [Terraform](https://www.terraform.io/)                                                                             |
	| install-brotli.sh           | https://spt.page.link/ci-install-brotli-sh       | [Brotli](https://github.com/google/brotli)                                                                         |
	| install-zopfli.sh           | https://spt.page.link/ci-install-zopfli-sh       | [Zopfli](https://github.com/google/zopfli)                                                                         |
	| install-maven.sh            | https://spt.page.link/ci-install-maven-sh        | [Maven](https://maven.apache.org/)                                                                                 |
	| install-newrelic-jar.sh     | https://spt.page.link/ci-install-newrelic-jar-sh | [New Relic for Java](https://docs.newrelic.com/docs/agents/java-agent/getting-started/introduction-new-relic-java) |
	| install-gpg-key.sh          | https://spt.page.link/ci-install-gpg-key-sh      | [PGP Signatures with Maven](http://blog.sonatype.com/2010/01/how-to-generate-pgp-signatures-with-maven/)           |
	| install-command.sh          | https://spt.page.link/ci-install-command-sh      | (Described later)                                                                                                  |

* [Command](https://github.com/spt-oss/spt-ci/tree/master/command)

	| Name          | Reference                                                                                      |
	| ---           | ---                                                                                            |
	| ecr-upload.sh | [Amazon ECR](http://docs.aws.amazon.com/AmazonECR/latest/userguide/docker-push-ecr-image.html) |
	| ecs-deploy.sh | [spt-oss/ecs-deploy](https://github.com/spt-oss/ecs-deploy)                                    |
	| git-*.sh      | [Git](https://git-scm.com/)                                                                    |
	| mvn-*.sh      | [Maven](https://maven.apache.org/)                                                             |

## Usage

### Install AWS CLI

* Any CI
	```bash
	$ curl -fsSL https://spt.page.link/ci-install-aws-cli-sh | bash
	$ aws --version
	```

### Install Terraform

* Any CI
	```bash
	$ curl -fsSL https://spt.page.link/ci-install-terraform-sh | bash -s -- ~/.cache 0.11.8  # <cache-dir> <version>
	$ terraform --version
	```
* CircleCI
	```yaml
	- restore_cache:
	    keys:
	        - XXXXXXXXXX
	- run: curl -fsSL https://spt.page.link/ci-install-terraform-sh | bash -s -- ~/.cache 0.11.8  # <cache-dir> <version>
	- save_cache:
	    paths:
	        - ~/.cache
	    key: XXXXXXXXXX
	- run: terraform --version
	```

### Install Brotli

* Any CI
	```bash
	$ curl -fsSL https://spt.page.link/ci-install-brotli-sh | bash -s -- ~/.cache  # <cache-dir>
	$ bro -h
	```
* CircleCI
	```yaml
	- restore_cache:
	    keys:
	        - XXXXXXXXXX
	- run: curl -fsSL https://spt.page.link/ci-install-brotli-sh | bash -s -- ~/.cache  # <cache-dir>
	- save_cache:
	    paths:
	        - ~/.cache
	    key: XXXXXXXXXX
	- run: bro -h
	```

### Install Zopfli

* Any CI
	```bash
	$ curl -fsSL https://spt.page.link/ci-install-zopfli-sh | bash -s -- ~/.cache  # <cache-dir>
	$ zopfli -h
	```
* CircleCI
	```yaml
	- restore_cache:
	    keys:
	        - XXXXXXXXXX
	- run: curl -fsSL https://spt.page.link/ci-install-zopfli-sh | bash -s -- ~/.cache  # <cache-dir>
	- save_cache:
	    paths:
	        - ~/.cache
	    key: XXXXXXXXXX
	- run: zopfli -h
	```

### Install Maven

* Any CI
	```bash
	$ curl -fsSL https://spt.page.link/ci-install-maven-sh | bash -s -- ~/.cache 3.5.0  # <cache-dir> <version:3.0.4~>
	$ mvn --version
	```
* CircleCI
	```yaml
	- restore_cache:
	    keys:
	        - XXXXXXXXXX
	- run: curl -fsSL https://spt.page.link/ci-install-maven-sh | bash -s -- ~/.cache 3.5.0  # <cache-dir> <version:3.0.4~>
	- save_cache:
	    paths:
	        - ~/.cache
	    key: XXXXXXXXXX
	- run: mvn --version
	```

### Install New Relic for Java

* Any CI
	```bash
	$ curl -fsSL https://spt.page.link/ci-install-newrelic-jar-sh | bash -s -- ~/foo  # <install-dir>
	$ ls ~/foo
	newrelic.jar
	```

### Install GPG key

1. Generate GPG keys ( `pubring.gpg` and `secring.gpg` ) and encrypt them with OpenSSL AES-256-CBC.
	```bash
	$ openssl aes-256-cbc -md sha256 -in pubring.gpg -out pubring.gpg.enc -k <password>
	$ openssl aes-256-cbc -md sha256 -in secring.gpg -out secring.gpg.enc -k <password>
	```
1. Upload the encrypted keys ( `pubring.gpg.enc` and `secring.gpg.enc` ) to the global web in the same path.
	```bash
	https://example.com/path/pubring.gpg.enc
	https://example.com/path/secring.gpg.enc
	```
1. Execute the following command to download keys in `${HOME}/.gnupg`.
	```bash
	$ curl -fsSL https://spt.page.link/ci-install-gpg-key-sh | \
	    bash -s -- https://example.com/path/pubring.gpg.enc XXXXXXXXXX  # <pubring-url> <password:secret>
	$ gpg --list-keys
	$ gpg --list-secret-keys
	```

### Upload Docker image to Amazon ECR

1. Install `ecr-upload` command.
	```bash
	$ curl -fsSL https://spt.page.link/ci-install-command-sh | bash -s -- aws  # [aws]
	```
1. Run `ecr-upload` command. Command arguments are mostly the same as [docker build](https://docs.docker.com/engine/reference/commandline/build/).
	```bash
	$ ecr-upload -t 123456789.dkr.ecr.us-west-1.amazonaws.com/app:latest --rm=false .
	```
	| Improved Argument | Description                  |
	| ---               | ---                          |
	| -t                | `<ecr-repository-uri>:<tag>` |

### Update Docker task in Amazon ECS

1. Install `ecs-deploy` command.
	```bash
	$ curl -fsSL https://spt.page.link/ci-install-command-sh | bash -s -- aws  # [aws]
	```
1. Run `ecs-deploy` command. Command arguments are same as [ecs-deploy](https://github.com/silinternational/ecs-deploy).
	```bash
	$ ecs-deploy -i 123456789.dkr.ecr.us-west-1.amazonaws.com/app:latest -c cluster -n service --use-latest-task-def
	```

### Refine Maven build in CircleCI

* See the examples below.
	* [spt-oss/spt-parent](https://github.com/spt-oss/spt-parent)

## License

* This software is released under the Apache License 2.0.
