# Hedgehog
A highly experimental implementation of the tail command, written in Swift. It should absolutely not be used as a production replacement for the default `tail` command. 😅

```
USAGE: hedgehog [-n <n>] [--follow] --path <path>

OPTIONS:
  -n <n>                  The number of lines to display. (default: 10)
  -f, --follow            Follow file and display new lines. 
  -p, --path <path>       Path to the file you want to read. 
  -h, --help              Show help information.
```
