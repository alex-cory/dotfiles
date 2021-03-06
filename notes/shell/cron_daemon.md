cron
====

#### Examples

The following specifies that the Apache error log clears at one minute past midnight (00:01) of every day of the month, of every day of the week, assuming that the default shell for the cron user is Bourne shell compliant:
```sh
1 0 * * *  printf > /var/log/apache/error_log
```

The following line makes the user program test.pl—ostensibly a Perl script—run every two hours, at midnight, 2am, 4am, 6am, 8am, and so on:
```sh
0 */2 * * *  /home/username/test.pl
```

Another example showing how to run a shell program called export_dump.sh at 0th minute of 20th hour, every day.
```sh
00 20 * * * /home/oracle/scripts/export_dump.sh
```

#### Predefined scheduling definitions

#####Entry	Description	Equivalent to
@yearly (or @annually)	Run once a year at midnight in the morning of January `1	0 0 1 1 *`  
@monthly	Run once a month at midnight in the morning of the first day of the month	`0 0 1 * *`  
@weekly	Run once a week at midnight in the morning of Sunday	`0 0 * * 0`  
@daily	Run once a day at midnight	`0 0 * * *`  
@hourly	Run once an hour at the beginning of the hour	`0 * * * *`  
@reboot	Run at startup	@reboot  
```sh
# * * * * *  command to execute
# ┬ ┬ ┬ ┬ ┬
# │ │ │ │ │
# │ │ │ │ │
# │ │ │ │ └───── day of week (0 - 7) (0 to 6 are Sunday to Saturday, or use names; 7 is Sunday, the same as 0)
# │ │ │ └────────── month (1 - 12)
# │ │ └─────────────── day of month (1 - 31)
# │ └──────────────────── hour (0 - 23)
# └───────────────────────── min (0 - 59)
```
