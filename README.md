# serialize_gnu_pass.awk

## The Quest

For [GNU Pass](https://www.passwordstore.org/) the `pass show ____` command will output something that looks like the following:

```
P455W0RD


UserName: bob
URL: https://www....
```

I wanted to use multiple of these in my backup process to encrypt my offsite backups.

I already have a backup script that internally uses [ndjson-env](https://github.com/forbesmyester/ndjson-env), to interate over multiple backup configurations stored in an *.NDJSON file.

```
{"B2_ACCOUNT_ID":"_","B2_ACCOUNT_KEY":"_","_name":"forbesmyester-music","RESTIC_PASSWORD":"_"}
{"B2_ACCOUNT_ID":"_","B2_ACCOUNT_KEY":"_","_name":"forbesmyester-books","RESTIC_PASSWORD":"_"}
```

So I needed some way to convert multiple of the GNU Pass files into a singular *.NDJSON file suitable for ndjson-env.

I've also been looking for a project that I can implement in awk!

## The Solution

The solution is stored in [serialize_gnu_pass.awk](./serialize_gnu_pass.awk).

You should use this script as follows:

```bash
pass show PASSWORD_FILE | awk -v PASSWORD_NAME=RESTIC_PASSWORD -f serialize_gnu_pass.awk ANOTHER_VARIABLE_NAME=ANOTHER_VARIABLE_VALUE
```

So the awk script accepts STDIN and uses the variable PASSWORD_NAME to determine the property name of the password. It puts in all the  other values within the password file too as well as others passed on the command line (which just pass straight through to `jo`).

## Requirments

The script internally shells out to [`jo`](https://github.com/jpmens/jo) to build the JSON result. You will need to have that installed and in your path. If your passwords have an '@' or a '%' at the front you'll need a relatively newish version. When we use `jo` we pass our data into STDIN instead of as arguments, so we don't have any nasty shell escaping issues.
