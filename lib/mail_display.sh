#!/bin/bash
# Script to count the number of new emails that I have
# in a maildir subsystem.  Searches over all folders of all
# inboxes rather than just the inboxes.

BASEDIR=$HOME/.mail

ACCOUNTS=`ls $BASEDIR | egrep -v "(archive|mairix)"`

# count up the number of new mail
mail=0

for account in $ACCOUNTS ; do
    # get rid of unwanted directories
    FOLDERS=`ls $BASEDIR/$account/ | grep -v ^d | egrep -v "(archive|spam|junk|trash|drafts|sent|bak)"`

    # count the number of files in a given directory, add to total new mails
    for folder in $FOLDERS ; do
        tmp=`ls -l $BASEDIR/$account/$folder/new | grep ^- | wc -l`
        mail=`expr $mail + $tmp`
    done

done

# I display this in xmobar, so the <fc=color> is to display color there.
# You may or may not need / want that.
if [ $mail -gt 0 ] ; then
    echo "Mail: <fc=green>$mail</fc>"
else
    echo "Mail: <fc=red>None</fc>"
fi
