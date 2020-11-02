# Borgbackup ![Borgbackup](https://img.shields.io/badge/Ansible-Borgbackup.svg)

## Sommaire
* [Preview](#preview)
  - [TODO](#todo)
  - [Requirements](#requirements)
  - [Compatibility](#compatibility)
* [Usage](#usage)
  - [Variables](#variables)
  - [Examples](#examples)
* [Licence](#licence)

## Preview
Ansible role to install Borgbackup and Borgmatic.

Set up encrypted, compressed and deduplicated backups using [Borgbackup](https://borgbackup.readthedocs.io/en/stable/) and [Borgmatic](https://github.com/witten/borgmatic).

### TODO
- Gitlab-CI

### Requirements
- Ansible >= 2.7

### Compatibility
  ![Debian](https://img.shields.io/badge/Debian-Buster-blue.svg)

This role has been tested only on Debian Buster but it should be working on every GNU/Linux distribution.

## Usage
### Variables

See default [variables](defaults/main.yml).

|NAME|TYPE|REQUIRED|DEFAULT|DESCRIPTION|
|-|-|-|-|-|
|borg_encryption_passphrase|STRING|YES|Empty|Encryption passphrase|
|borg_packages|LIST|NO|See defaults|Required packages installed through local package manager|
|borg_packages_pip|LIST|NO|See defaults|Required packages installed through pip3|
|borg_conf_template|STRING|NO|`config.yaml`|Template used for main config file|
|borg_exclude_template|STRING|NO|`excludes`|Template used for exclude patterns|
|borg_user|STRING|NO|`root`|User used for borgbackups|
|borg_local_repository|STRING|NO|`/var/backups/borg`|Local repository path|
|borg_remote_repository|STRING|NO|NONE|Optional remote repository|
|borg_no_local_repository|BOOL|NO|`false`|Do not init local repository|
|borg_init_remote_repository|BOOL|NO|`false`|Init remote repository (should be set to `true` at first run only)|
|borg_encryption_type|STRING|NO|`repokey-blake2`|Encryption method, see official doc for more|
|borg_excludes_default|LIST|NO|See defaults|Defaults excluded patterns|
|borg_excludes|LIST|NO|NONE|Excludes patterns, merged with `borg_excludes_default`|
|borg_backup_dirs|LIST|NO|NONE|Folders you want to backup|
|borg_mysqldump|LIST of DICT|NO|NONE|MySQL databases, see example below|
|borg_conf_umask|STRING|NO|`0077`|Umask used when executing hooks. Defaults to the umask that borgmatic is run with|
|borg_conf_location|DICT|NO|See defaults|Defaults options for borgmatic `location` configuration section|
|borg_conf_storage|DICT|NO|See defaults|Defaults options for borgmatic `storage` configuration section|
|borg_conf_retention_policy|DICT|NO|See defaults|Defaults options for borgmatic `retention_policy` configuration section|
|borg_conf_consistency|DICT|NO|See defaults|Defaults options for borgmatic `consistency` configuration section|
|borg_before_backup_commands|LIST|NO|NONE|Before backup commands|
|borg_after_backup_commands|LIST|NO|NONE|After backup commands|
|borg_failure_commands|LIST|NO|NONE|Failed backup commands|
|borg_before_everything_commands|LIST|NO|NONE|Before any action commands|
|borg_after_everything_commands|LIST|NO|NONE|After any action commands|
|borg_cron_enable|BOOL|NO|`true`|Enable cron job|
|borg_cron_action|STRING|NO|`create`|Default borgmatic main parameter for cronjob|
|borg_cron_nice|INT|NO|`19`|Nice parameter for cron job|
|borg_cron_ionice_class|INT|NO|`3`|Ionice parameter for cron job|
|borg_cron_log|STRING|NO|`/var/log/borg.log`|Borg log file path|
|borg_cron|DICT|NO|See defaults|Borg cron job startup|
|borg_logrotate|BOOL|NO|`true`|Setup default Borg logrotate conf file|
|borg_scripts|BOOL|NO|`true`|Add extra scripts|

### Examples
```
borg_encryption_passphrase: MyS3Cr3tPa55phr4s3
borg_backup_dirs:
- /var/www
- /home/me

borg_cron:
  hour: 23
  minute: 0
  day: '1'
  weekday: '*'
  month: '*'

borg_mysqldump:
    - name: all
      username: root
    - name: posts
      hostname: database2.example.org
      port: 3307
      username: root
      password: trustsome1
      options: "--skip-comments"
```

## Sources
- https://github.com/borgbase/ansible-role-borgbackup
- https://github.com/bfabio/ansible-borg_client
- https://github.com/adhawkins/ansible-borgbase
- https://github.com/witten/borgmatic
- https://torsion.org/borgmatic/docs/reference/configuration/
- https://borgbackup.readthedocs.io/en/stable/usage/general.html

## Licence
MIT view [LICENSE](LICENSE)
