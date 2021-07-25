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
    - [When creating an OAuth client ID, the application type will be a desktop application](https://developers.google.com/workspace/guides/create-credentials#desktop)
  - [Enable Google Calendar API](https://console.cloud.google.com/apis/library/calendar-json.googleapis.com)

```shell
$ gem install vgcal
$ vgcal init
Fix the __FIX_ME__ in /Users/ito.shota/.vgcal/credentials.json
$
```

## Usage

```shell
# help
$ vgcal
Commands:
  vgcal help [COMMAND]  # Describe available commands or one specific command
  vgcal init            # Make directory and template credentials.json for Google authentication
  vgcal show            # Show google calendar
  vgcal version         # View vgcal version
$
$ vgcal help show
Usage:
  vgcal show

Options:
  -d, [--date=DATE]                  # Show relative date. ex.-1, +10
  -c, [--current-week=CURRENT-WEEK]  # Show current week tasks
  -s, [--start-date=N]               # Start date. ex.20210701
  -e, [--end-date=N]                 # End date. ex.20210728

Show google calendar
$
```

### example

![Today's schedule](./images/google-calendar.png)

```shell
# Today's schedule
$ vgcal show
Period: 2021-07-24T00:00:00+09:00 - 2021-07-24T23:59:59+09:00

My tasks: 5.25h(0.66day)
  ・all day task 1: all day
  ・all day task2: all day
  ・meeting1: 2.0h
  ・meeting2: 0.25h
  ・meeting3: 3.0h

Invited meetings: 0h(0day)

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
$ git clone git@github.com:st1t/vgcal.git
$ cd vgcal/
$ bundle install
$ bundle exec ruby exe/vgcal show -d -5
$ rake spec

Vgcal
  has a version number

Vgcal::MyCalendar
  my_task
  my_task_hidden
  invitation_task

Finished in 0.01492 seconds (files took 0.75345 seconds to load)
4 examples, 0 failures

$ 
```
