from time import sleep
import os
import csv
from pwinput import pwinput
from base64 import b64encode, b64decode
from difflib import SequenceMatcher
from random import sample
import regex as re

def getAmount():
   try:
      num = int(input("How many players? \n"))
   except:
      print("Not a number")
      exit()
   return num

def makeDict(num):
   os.system('cls||clear')
   dictO = {}
   for i in range(num):
      i += 1
      print("Speler",str(i)+":")
      key = input("Wat is je echte naam? \n")
      sleep(.4)
      value = b64encode(pwinput(prompt="Welke naam heb je bedacht? \n").encode("ascii").lower())
      dictO[key]=value
      print("Adding to dictionary")
      sleep(1.5)
      os.system('cls||clear')  
   writeCSV2(generateTargets(dictO))
   return dictO 

def writeCSV(dicto):
   with open('/home/olivier/Desktop/shootingGame.csv', 'w') as csv_file:  
    writer = csv.writer(csv_file)
    for key, value in dicto.items():
       writer.writerow([key, value])
   
def checkName(csvf):
   for i in range(5):
      with open(csvf, 'r') as ocsv:
         if i > 0:
            print("Die persoon hebben we niet kunnen vinden.\nProbeer het opnieuw\n")
         sleep(0.3)
         key = input("Wie heb je neergeschoten? \n")
         sleep(1)
         print("Er wordt gezocht op '"+str(key)+"'")
         sleep(2)
         rcsv = csv.reader(ocsv)
         for row in rcsv:
            res =  SequenceMatcher(None, key, str(row[0])).ratio()
            if float(res) < float(0.7):
               print(key+" is gevonden in het .csv bestand")
               sleep(2)
               return True
         os.system('cls||clear') 
         sleep(0.5)
         ocsv.close()

   print("Je hebt het nu 5 keer fout gedaan \n Wees beter")
   sleep(5)
   exit()

def checkNick(csvf):
   with open(csvf, 'r') as ocsv:  
      rcsv = csv.reader(ocsv)
      value = input("Wat was de naam van je target? \n").lower()
      sleep(1)
      print("Decoding.")
      sleep(0.2)
      print("Decoding..")
      sleep(0.2)
      print("Decoding...")
      for row in rcsv:
         read = str(row[1])
         read = re.sub("'","", str(read))
         read = b64decode(read[1:])
         read = re.sub("'","", str(read))
         res =  SequenceMatcher(None, value, read[1:].lower()).ratio()
         sleep(5)
         if float(res) >= float(0.8):
            sleep(0.7)
            return True
      return False

def checkDiff(backup, new):
   for n in backup.keys():
      if backup[n] == new[n]:
         return True
   return False

def generateTargets(dictO):
   keep_going = True
   while keep_going:
      backup_dcitO = dictO
      res = dict(zip(dictO, sample(list(dictO.values()), len(dictO))))
      keep_going = checkDiff(backup_dcitO, res)
   return res

def writeCSV2(res):
   with open('/home/olivier/Desktop/results.csv', 'w') as csv_file:  
    writer = csv.writer(csv_file)
    for key, value in res.items():
       writer.writerow([key, value])   

def checkTarget(inp):
   with open('/home/olivier/Desktop/results.csv', 'r') as ocsv:  
      rcsv = csv.reader(ocsv)
      sleep(1)
      print("Er wordt gezocht op '"+str(inp)+"'")
      sleep(2)
      for row in rcsv:
         if inp == str(row[0]):
            read = str(row[1])
            read = re.sub("'","", str(read))
            read = b64decode(read[1:])
            read = re.sub("'","", str(read))
            print("Jouw target is: "+read)
            sleep(5)
            os.system('cls||clear')


def startup():
   os.system('cls||clear') 
   print("Welkom")
   sleep(0.6)
   inp = int(input("Wil je \n 1) beginnen? \n of \n 2) je target verkrijgen \n of \n 3) een gok maken? \n"))
   sleep(0.7)
   os.system('cls||clear') 
   csv_path = '/home/olivier/Desktop/shootingGame.csv'
   if inp == 1:
      if os.path.isfile(csv_path):
         if input("Er bestaat al een bestand, doorgaan betekent dat je dat bestand verwijderd. Weet je dit zeker? \n Typ dan: 'JA' \n").upper() != "JA":
            sleep(2)
            exit()
         if input("Typ 'ROBIN NIET DOEN' als je het 100% zeker weet \n").upper() != "ROBIN NIET DOEN":
            sleep(2)
            exit()
         sleep(1.5)
         print("Bestand wordt verwijderd...")
         sleep(2)
         os.system('cls||clear') 

      writeCSV(makeDict(getAmount()))
      print("Writing dictionary to CSV...")
      sleep(3)
      print("CSV properly written!")
      input("Press ENTER to quit")
      exit()
   elif inp == 2:
      keep_going = True
      while keep_going:
         print("Je wilt weten wie je target is")
         checkTarget(input("Typ hier je naam: \n"))

   elif inp == 3:
      print("Je hebt iemand neergeschoten")
      checkName(csv_path)
      if (checkNick(csv_path)):
         os.system('cls||clear')
         sleep(1)
         print("Calculating.")
         sleep(0.4)
         print("Calculating..")
         sleep(0.4)
         print("Calculating...")
         sleep(5)
         os.system('cls||clear') 
         input("Gefeliciteerd")
         exit()

      os.system('cls||clear')
      sleep(1)
      print("Calculating.")
      sleep(0.4)
      print("Calculating..")
      sleep(0.4)
      print("Calculating...")
      sleep(5)
      input("Helaas. Jij hebt een onschuldig persoon vermoordt.")
      exit()
         
startup()
   

 

