#!/usr/bin/env python3

# apt install python3-pip
# pip install urllib3 xmltodict

import urllib3
import xmltodict
import datetime
from xml.dom import minidom

http = urllib3.PoolManager()

url = 'http://www.nbp.pl/kursy/xml/dir.txt'
r = http.request('GET', url)
content = r.data.decode('utf-8').split('\r\n')
a=[]
for l in content:
  if l.startswith('a'):
    a.append(l)

#print ('D,GBP,EUR,CHF,USD,NOK')

d = datetime.date.today()
t=''
if d.month<10: t='0'
s = str(d.year)[2:4]+t+str(d.month)+str(d.day)
#print (s)

for l in a:
  if l[5:12]==s:
    url='http://www.nbp.pl/kursy/xml/'+l+'.xml'
#    print (url)
    r = http.request('GET', url)
    x = r.data.decode('cp1252')
    doc = minidom.parseString(x)
    dat = doc.getElementsByTagName('data_publikacji')[0].firstChild.nodeValue
    gbp = doc.getElementsByTagName('kod_waluty')[10].parentNode.getElementsByTagName('kurs_sredni')[0].firstChild.nodeValue.replace(',','.')
    eur = doc.getElementsByTagName('kod_waluty')[7].parentNode.getElementsByTagName('kurs_sredni')[0].firstChild.nodeValue.replace(',','.')
    chf = doc.getElementsByTagName('kod_waluty')[9].parentNode.getElementsByTagName('kurs_sredni')[0].firstChild.nodeValue.replace(',','.')
    usd = doc.getElementsByTagName('kod_waluty')[1].parentNode.getElementsByTagName('kurs_sredni')[0].firstChild.nodeValue.replace(',','.')
    nok = doc.getElementsByTagName('kod_waluty')[16].parentNode.getElementsByTagName('kurs_sredni')[0].firstChild.nodeValue.replace(',','.').replace('0.','3.')
    print(dat+','+gbp+','+eur+','+chf+','+usd+','+nok)
