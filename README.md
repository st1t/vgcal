# Vgcal

The vgcal command was created to simplify the display of my Google calendar schedules.

## Installation

```shell
$ gem install vgcal
```

## First run

- Setup Google API
  - [Create a project and enable the API](https://developers.google.com/workspace/guides/create-project)
  - [Create credentials](https://developers.google.com/workspace/guides/create-credentials)

```shell
$ gem install vgcal
$ bundle exec ruby exe/vgcal init
Fix the __FIX_ME__ in /Users/ito.shota/.vgcal/credentials.json
$
```


## Usage

```shell
# Today's schedule
$ vgcal show

# This week's schedule (starting on Sunday)
$ vgcal show -c

# Schedule for 5 days ago
$ vgcal show -d -5

# 1 day later
$ vgcal show -d +1

# Schedule for 2021/07/01 - 2021/07/28
$ vgcal show -s 20210701 -e 20210728
```

## Development

```shell
$ bundle exec ruby exe/vgcal show -d -5
```
