#!/usr/bin/env python

from configparser import ConfigParser

con = ConfigParser()

con.read('setting.ini')

print(con.get('Settings', 'start.julianday'))
print(con.get('Settings', 'end.julianday'))
print(con.get('Settings', 'data.folder'))
