#!/bin/bash
#
# This is a setup script to make all the
# symlinks and directories that you will need
# to use this mail setup.
#
# For now, this is specific to myself, and assumes
# that I have put the mail configuration repo in
# $HOME/mail_config

# Get the directory name of the setup script
DIR="$( cd "$(dirname "$0")" && pwd)"

# make sure that we're not already in $HOME/.mail_config
if [ $DIR == $HOME/.mail_config ] ; then
    echo "This script is intended to link $HOME/.mail_config to $DIR."
    echo "If those are the same, there's nothing to do."
    exit 1
fi

function notes {
	echo "If you haven't already, you will need to install mutt,"
	echo "offlineimap, imapfilter, archivemail, mairix, lbdb, and msmtp,"
	echo "as well as the python bindings for gnome-keyring"
	echo ""
	echo "On Debian based systems, this can be done through..."
	echo "(sudo) apt-get install mutt offlineimap imapfilter archivemail mairix lbdb msmtp-mta msmtp-gnome python-gnomekeyring"
	echo ""
	echo "Also, to let offlineimap/imapfilter be run through cron,"
	echo "add $HOME/bin/export_x_info.sh to your startup scripts."
	echo ""
	echo "When these have been installed, use lib/msmtp-gnome-tool.py"
	echo "and lib/offlineimap-gnome-tool.py to populate gnome-keyring"
	echo "with your passwords"
	echo ""
	echo ""
	echo "Insert something like the following into your crontab (crontab -e)"
	echo ""
	echo "*/10 *   *  *  *  $HOME/bin/pullmail.sh > $HOME/.offlineimap.last.log"
    echo "13   */2 *  *  *  mairix -p -f $HOME/.mail_config/mairixrc"
	echo "15   */2 *  *  *  $HOME/.mail_config/lib/refreshaddress.sh"
}

# Make the required mail directories
mkdir -p $HOME/.mail/school
mkdir -p $HOME/.mail/gmail

# We need to make $HOME/.mairix too
mkdir -p $HOME/.mairix

# link $HOME/mail_config directory to here
rm -rf $HOME/.mail_config
ln -s $DIR $HOME/.mail_config

# Symlinks
rm -rf $HOME/.msmtprc $HOME/.mutt $HOME/.lbdbrc $HOME/bin/export_x_info.sh $HOME/bin/pullmail.sh
ln -s $HOME/.mail_config/msmtprc $HOME/.msmtprc
ln -s $HOME/.mail_config/mutt $HOME/.mutt
ln -s $HOME/.mail_config/lbdb.rc $HOME/.lbdbrc
ln -s $HOME/.mail_config/offlineimaprc $HOME/.offlineimaprc

# msmtprc needs to be 600 permissions
chmod 600 $HOME/.mail_config/msmtprc

# binary files
ln -s $HOME/.mail_config/lib/export_x_info.sh $HOME/bin/export_x_info.sh
ln -s $HOME/.mail_config/lib/pullmail.sh $HOME/bin/pullmail.sh

# Print out the notes to end
notes

