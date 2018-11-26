import requests
from time import sleep

URL = "http://localhost:8080/pvc_servlets/DeductMoney"
  

while(True):
  r = requests.get(url = URL)
  print(r)
  sleep(5)
