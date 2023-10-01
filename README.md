# domain-recon.sh

A bash script that performs subdomain enumeration and notification for a given domain name.

## Features

- Uses subfinder to find subdomains of a given domain name.
- Saves the results in JSON and TXT formats.
- Compares the results with previous runs and notifies the user of any new subdomains via notify.
- Backs up the old files before overwriting them.

## Usage

To run the script, you need to have [subfinder](https://github.com/projectdiscovery/subfinder), [anew](https://github.com/tomnomnom/anew), and [notify](https://github.com/projectdiscovery/notify/) installed and configured on your system.

You also need to have [jq](https://jqlang.github.io/jq/download/) installed as a dependency.

The script takes one argument, which is the domain name to scan. For example:

```bash
./domain-recon.sh example.com
```

The script will create the following files in the same directory:

* example.com.json: The JSON output of subfinder.
* example.com-list.txt: The list of subdomains extracted from the JSON output.
* example.com-list.txt.bak: The backup of the previous list of subdomains.
* example.com-diff.txt: The list of new subdomains that are not in the previous list.

If there are any new subdomains, the script will send a notification via notify with the contents of example.com-diff.txt.

