# ![Automata Icon](https://bitbucket.org/Gethec/automata/raw/master/resources/automata.png) Automata #

## Disclaimer ##
As with anything else, exposing your system to the Internet incurs risks!  This container does its best to be as secure as possible, but makes no guarantees to being completely impenetrable.  Use at your own risk, and feel free to suggest changes that can further increase security.

## About ##
This project was born from the simple need to be able to automate simple tasks on a schedule without having to monitor them.  To that end, this is basically a glorified crontab, with folders you can drop scripts in to run at preset times

## Setup ##
To provide persistence across container restarts, it is recommended to mount the `/config` folder to somewhere safe on the host system.  When the container first starts, it will make a series of folders:
* 15min - Scripts in this folder will run every quarter-hour.
* hourly - Does what it says on the box.  Scripts here will run once an hour.
* daily - Scripts in this folder will run once a day at midnight.
* monday-sunday - Runs scripts on their respective days, at 1 AM.
* monthly - Runs scripts at 2 AM on the first day of each month.

**IMPORTANT!!**  Since it isn't possible for the container to change host file permissions, you must make sure to configure the script files' permissions properly.  There are three criteria you must meet:
* Do not put any extension on the scripts.  Ex: `run-me-daily` will work, but `run-me-daily.sh` will not.
* Make sure the scripts are executable.
* Make sure file permissions for the file are correct.  They either need to be owned by the user and/or group set in in the container, or need to be readable and executable by all.

## Container Variables ##
Configuration for this container is simple.  There are two variables that can be changed, and one that can be set.  The User ID and Group IDs can be used to more easily match the host system's file permissions for access to scripts, and TZ allows you to set the container's time zone so that it doesn't default to running off of UTC times.  A list of permissible values is [here](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones).
| Variable | Default | Example |
|----------|---------|---------|
| PUID | 911 | `-e 'PUID'='99'` |
| PGID | 1000 | `-e 'PGID'='100'` |
| TZ | UTC | `-e TZ="America/New York"` |

## Volumes ##
`/config` - Base storage directory for scripts.  Sub-directories are created for the different time increments.

## Setup ##
Example run command:

    docker run \
        --name='Automata'
        -v /host/config/path:/config \
        gethec/automata

## Changelog ##
* 0.0.1 - Initial release