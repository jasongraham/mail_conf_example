#!/bin/bash
#
# Script every couple hours via cron to update you address
# book.  It uses lbdb.
#
# Based on one found on:
# http://dev.gentoo.org/~tomka/mail.html

# Only capture those addresses that I send mail to
accounts=(~/.mail/school/sent/cur ~/.mail/gmail/sent/cur)

function parsemail {
	cat $1 | lbdb-fetchaddr
}

function parsemaildir {
    # use the below one for setting up and getting all
    # addresses in your sent folder to start
    #for mailfile in $( find $1 -type f ) ; do
    for mailfile in $( find $1 -type f -mtime -5 ) ; do
        parsemail ${mailfile}
    done
}

# The IFS variable saves the file name separator
# which we will temporarily set to \n so that the
# spaces in Gmail folders will work
for i in $accounts ; do
    o=${IFS}
    IFS=$(echo -en "\n\b")
    parsemaildir "${i}"
    IFS=o
done

# Apparently duplicates aren't removed automatically unless
# you explicitly do it yourself

SORT_OUTPUT=name /usr/lib/lbdb-munge
