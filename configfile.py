#!/usr/bin/env python

from configparser import ConfigParser
    
def create_config(path):
  config = ConfigParser()
  print('---------------------------------------*START*-------------------')
  config.add_section('---------------------------------------*START*-------------------')
  config.add_section('section-arrange')
  
  config.set('section-arrange', 'startJulianDay', '2019126')
  
  config.set('section-arrange', 'endJulianDay', '2019127')
  
  config.set('section-arrange', 'dataFolder', 'May2019')
  
  config.set('section-arrange', 'arr_stat', '("BBB1" "BBD0" "BBB3" "BBFD" "BBA2" "BBCB" "BBF7")')
  
  config.set('section-arrange', 'arr_station', '("KORC" "PCH" "PKCH" "KORS" "KORW" "PKAT" "PWE")')
  
  config.add_section('files-arrange')
  
  config.set('files-arrange', 'INPUT', '/home/seismics/seismic_data/raw/ps/ext')
  
  config.set('files-arrange', 'OUTPUT', '/home/seismics/seismic_data/raw/ps')
  
  
  config.add_section('section-tomsd')
  
  config.set('section-tomsd', 'startJulianDay', '2019126')
  
  config.set('section-tomsd', 'endJulianDay', '2019127')
  
  config.set('section-tomsd', 'arr_stat', '("BBB1" "BBD0" "BBB3" "BBFD" "BBA2" "BBCB" "BBF7")')
  
  config.set('section-tomsd', 'arr_station', '("KORC" "PCH" "PKCH" "KORS" "KORW" "PKAT" "PWE")')
  
  config.add_section('files-tomsd')
  
  config.set('files-tomsd', 'INPUT', '/home/seismics/seismic_data/raw/ps')
  
  config.set('files-tomsd', 'OUTPUT', '/home/seismics/seismic_data/msd/ps')
  
  
  config.add_section('section-archive')
  
  config.set('section-archive', 'startJulianDay', '2019126')
  
  config.set('section-archive', 'endJulianDay', '2019127')
  
  config.set('section-archive', 'arr_station', '("KORC" "PCH" "PKCH" "KORS" "KORW" "PKAT" "PWE")')
  
  config.add_section('files-archive')
  
  config.set('files-archive', 'inp_dir', '/home/seismics/seismic_data/msd/ps')
  
  config.set('files-archive', 'out_dir', '/home/seismics/seiscomp3/var/lib/archive')
  
  
  config.add_section('section-scart')
  
  config.set('section-scart', 'startJulianDay', '126')
  
  config.set('section-scart', 'endJulianDay', '127')
  
  config.set('section-scart', 'Year', '2019')
  
  config.set('section-scart', 'arr_station', '("KORC" "PCH" "PKCH" "KORS" "KORW" "PKAT" "PWE")')
  
  config.add_section('files-scart')
  
  config.set('files-scart', 'scart_inp_dir', '/home/seismics/seiscomp3/var/lib/archive')
  
  config.set('files-scart', 'scart_out_dir', '/home/seismics/PS_SCART')
  
  
  config.add_section('section-playback')
  
  config.set('section-playback', 'startJulianDay', '126')
  
  config.set('section-playback', 'endJulianDay', '127')
  
  config.set('section-playback', 'Year', '2019')
  
  config.add_section('files-playback')
  
  config.set('files-playback', 'playback_out_dir', '/home/seismics/PS_PLAYBACK')
  
  config.set('files-playback', 'playback_in_dir', '/home/seismics/PS_SCART')
  
  config.set('files-playback', 'picks_storage', 'mysql://seismics:seismics@localhost/seiscomp3Bkup')
  
  
  config.add_section('CheckEvent')
  
  config.set('CheckEvent', 'startJulianDay', '126')
  
  config.set('CheckEvent', 'endJulianDay', '127')
  
  config.set('CheckEvent', 'Year', '2019')
  
  config.set('CheckEvent', 'playback_out_dir', '/home/seismics/PS_PLAYBACK')
  
  
  config.add_section('---------------------------------------*END*KIAMA*-------------------')
  
  print('---------------------------------------*END*---------------------')
  
  
  with open(path, 'w') as file:
    config.write(file)
if __name__ == '__main__':
  path = 'configSettings.ini'
  create_config(path)
  
