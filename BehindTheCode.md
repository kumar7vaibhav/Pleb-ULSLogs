# Behind The Code

## Phase 1
- Set Trace Severity to VerboseEx
- Set a start marker for the script.
```
PS C:\code> . 'C:\code\Pleb-ULSLogs.ps1'
Starting - Part 1 [VerboseEx, start marker]
Finished - Part 1
```

## Phase 2
Script wait for the user to recreate the error on the browser/applciation.
Press enter to continue to next phase.
```
Please recreate the error and collect correlation ID (if any)
Press Enter when done...
```

## Phase 3
- Clear Log level and place an end marker for the script.
- Ask user if they require logs from specific server.
  - If yes, then enter the index of listed servers.
- Last step is to donwload and initiate [Anthony's Script](https://github.com/acasilla/CollectULSLogs)
```
Starting - Part 2 [End marker, Clear Log Level, Start main script]
Do you want logs from specific servers? (y/n): y
SharePoint Servers in the farm -
1. spapp | Role: ApplicationWithSearch
2. spwfe | Role: WebFrontEndWithDistributedCache
Enter a list of servers separated by commas (e.g., 1, 2, 3)::
```
