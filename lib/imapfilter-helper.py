#!/usr/bin/python2
#
# Used by imapfilter to fetch credentials from gnome-keyring

import sys
import gnomekeyring as gkey

class Keyring(object):
    def __init__(self, name, server, protocol):
        self._name = name
        self._server = server
        self._protocol = protocol
        self._keyring = gkey.get_default_keyring_sync()

    def has_credentials(self):
        try:
            attrs = {"server": self._server, "protocol": self._protocol}
            items = gkey.find_items_sync(gkey.ITEM_NETWORK_PASSWORD, attrs)
            return len(items) > 0
        except gkey.DeniedError:
            return False

    def get_credentials(self):
        attrs = {"server": self._server, "protocol": self._protocol}
        items = gkey.find_items_sync(gkey.ITEM_NETWORK_PASSWORD, attrs)
        return (items[0].attributes["user"], items[0].secret)

    def set_credentials(self, (user, pw)):
        attrs = {
                "user": user,
                "server": self._server,
                "protocol": self._protocol,
            }
        gkey.item_create_sync(gkey.get_default_keyring_sync(),
                gkey.ITEM_NETWORK_PASSWORD, self._name, attrs, pw, True)

def main(server, info):
    keyring = Keyring("offlineimap " + server, server, "imap")
    (username, password) = keyring.get_credentials()

    if info == "user":
        print(username)
    elif info == "password":
        print(password)
    else: # neither user nor pass
        sys.exit(-2)

if __name__ == '__main__':
    server = sys.argv[1]
    info = sys.argv[2]
    main(server, info)

