#H1 Parcelles

Utilizes packer to quickly provision VM images for local testing through Virtualbox or Amazon EC2 AMIs for deployment and staging environments.

Requires packer >= 0.3.2 for Amazon block device mapping support

To generate an image simply run packer specifying the builder and the packer template file. We've included a example template to get the ball rolling.

```bash
packer build --only=virtualbox example.json 
```
or

```bash
packer build --only=amazon-ebs example.json 
```

To authenticate your credentials on Amazon you need the following environment variables defined

```bash
export AWS_ACCESS_KEY="..."
export AWS_SECRET_KEY="..."
```

#H2 Scripts
Most of our infrastructure is based on Ubuntu Server and the provisioning scripts assume it as the base OS (apt, upstart, etc...).

#H3 non-aws.sh
Takes a vanilla Ubuntu Server install and includes packages and idiosyncrasies to bring it closer to default ubuntu AMI.

#H3 base.sh
Our opinionated touches of what should be present with every Ubuntu.

Includes things such as tracking of bash timestamps, unattended-upgrades for critical security fixes, enabling ssh agent forwarding and longer timeout, and other basic things utilities such as vim, git, htop, etc... all in their latest and greatest maintained versions

#H3 nginx.sh

Basic unattended installation of the latest upstream nginx. When provisioning an AMI, creates a separate EBS to store served content.

#H3 mysql.sh

Basic unattended installation of mysql. Like nginx, creates a separate EBS when provisioning an AMI formated to xfs to simplify database backup through ec2-consistent-snapshot.

#H3 php.sh

Basic unattended installation of php. Sets up socket so php-fpm can communicate with nginx. Also includes necessary php libraries for common apps such as wordpress and moodle.
