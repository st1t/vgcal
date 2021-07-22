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
$ git clone git@github.com:st1t/vgcal.git
$ cd vgcal/
$ vim credentials.json # Modify __FIX_ME__
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
