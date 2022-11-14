function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
function trim(s) { return rtrim(ltrim(s)); }
BEGIN {
    FS=":";
    NEEDPW=1;
    PW=_;
	CMD="jo"
    for (i = 1; i < ARGC; i++) {
        print ARGV[i] |& CMD;
    }
}
$0 ~ /^[ \t]*$/ { next; }
NEEDPW {
    NEEDPW=0;
    if (!PASSWORD_NAME) {
        PASSWORD_NAME="PASSWORD"
    }
    $0=(PASSWORD_NAME ": " $0)
}
{
    VAL=""
    for (i=2; i<=NF;i++) {
        if (i > 2) {
            VAL=(VAL ":")
        }
        VAL=(VAL "" $i)
    }
    KEY=$1
    VAL=trim(VAL)

    if (substr(VAL,1,1) == "@") { VAL=("\\" VAL); }
    if (substr(VAL,1,1) == "%") { VAL=("\\" VAL); }
    if ((PRE) && (NR != 1)) {
        KEY=sprintf("%s%s", PRE, KEY)
    }

    printf "%s=%s\n", KEY, VAL |& CMD;

}
END {
    close(CMD, "to");
    while ((CMD |& getline line) > 0) {
      print line
    };
    close (CMD);
}


