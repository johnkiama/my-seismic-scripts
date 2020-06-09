#!/usr/bin/env python

import os


os.system('clear')

## Your menu design here
def print_menu():      
    print 19 * "-" , "GDC SEISMICS DATA PROCESSING APP" , 19 * "-"
    print "1. Arrange reftek Data"
    print ""
    print "2. Convert reftek data to mseed"
    print ""
    print "3. Archive data to seiscomp3"
    print ""
    print "4. Scart the archived data"
    print ""
    print "5. Playback the archived data"
    print ""
    print "6. Check number of events Picked"
    print ""
    print "7. Full throttle"
    print ""
    print "8. Exit"
    print 67 * "-"
  
loop=True      

## While loop keep going until loop = False
## menu
while loop:          
    print_menu()    
    choice = input("Enter your choice [1-5]: ")
     
    if choice==1: 
        os.system("/home/seismics/scorpionGDC/arrange.sh")    
    elif choice==2: 
        os.system("/home/seismics/scorpionGDC/tomsd.sh") 
    elif choice==3:
       os.system("/home/seismics/scorpionGDC/arch.sh")
    elif choice==4:
        os.system("/home/seismics/scorpionGDC/scarting.sh") 
    elif choice==5:
        os.system("/home/seismics/scorpionGDC/playback.sh")
    elif choice==6:
        os.system("/home/seismics/scorpionGDC/eventCheck.sh")
    elif choice==7:
        os.system("/home/seismics/scorpionGDC/arrange.sh")
        os.system("/home/seismics/scorpionGDC/tomsd.sh")
        os.system("/home/seismics/scorpionGDC/arch.sh")
        os.system("/home/seismics/scorpionGDC/scarting.sh")
        os.system("/home/seismics/scorpionGDC/playback.sh")
        os.system("/home/seismics/scorpionGDC/eventCheck.sh")
    elif choice==8:
        print 23 * "-" , "EXITING THE PROGRAM" , 23 * "-"
        # This will make the while loop to end as not value of loop is set to False
        loop=False 
    else:
        # Any integer inputs other than values 1-5 we print an error message
        raw_input("Wrong option selection. Enter any key to try again..")

