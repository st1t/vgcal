![badge](https://github.com/st1t/vgcal/actions/workflows/ruby.yml/badge.svg)

# Vgcal

The vgcal command was created to simplify the display of my Google calendar schedules.

## Installation

```shell
$ gem install vgcal
```

## First run

### Setup Google API

1. [Create Google Cloud project](https://developers.google.com/workspace/guides/create-project)
2. [Enable Google Calendar API](https://console.cloud.google.com/apis/library/calendar-json.googleapis.com)
3. [Create service account](https://developers.google.com/workspace/guides/create-credentials)
   1. [Create a service account](https://developers.google.com/workspace/guides/create-credentials#create_a_service_account)
   2. [Create credentials for a service account](https://developers.google.com/workspace/guides/create-credentials#create_credentials_for_a_service_account)
   3. Please save the following information
      1. Email address of the issued service account
      2. credential.json issued to the service account
4. [Set up sharing settings for the Google calendar you want to display in vgcal](https://support.google.com/calendar/answer/37082)
   1. Share a calendar with specific people
      1. Add the email address issued in the service account.
         1. ![share-calendar.png](images%2Fshare-calendar.png)

### Setup vgcal

```shell
$ vgcal init
Fix the __FIX_ME__ in /Users/shota-ito/.vgcal/credentials.json and /Users/shota-ito/.vgcal/.env

# Save the key issued by the service account as credentials.json
$ cp ~/Downloads/__SERVICE_ACCOUNT_KEY__.json ~/.vgcal/credentials.json

# Please write the email address of the calendar you would like to display in vgcal.
# This is not the email address of the service account.
$ vim ~/.vgcal/.env
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
  -d, [--date=DATE]                          # Show relative date. ex.-1, +10
  -c, [--current-week], [--no-current-week]  # Show current week tasks
  -n, [--next-week], [--no-next-week]        # Show next week tasks
  -s, [--start-date=N]                       # Start date. ex.20210701
  -e, [--end-date=N]                         # End date. ex.20210728
  -o, [--output=OUTPUT]                      # Output format. [text|json]

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
  ・all day task 1: 0h
  ・all day task2: 0h
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

# Formatted json
$ vgcal show -o json | jq .
{
  "start_date": "2021-09-05T00:00:00+09:00",
  "end_date": "2021-09-05T23:59:59+09:00",
  "tasks": [
    {
      "title": "all day task 1",
      "time": 0,
      "task_type": "my_task"
    },
    {
      "title": "task a",
      "time": 1,
      "task_type": "my_task"
    },
    {
      "title": "task b",
      "time": 1,
      "task_type": "my_task"
    }
  ]
}
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
