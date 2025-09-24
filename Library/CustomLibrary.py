import requests
import random
import string
import random

class CustomLibrary():
    
    def get_random_customers(self):
        response = requests.get("https://jsonplaceholder.typicode.com/users", verify=False)
        users = response.json()
        
        for  i  in users:
            i["birthday"] = self.generate_random_birthday()
            i["password"] = self.generate_password()
            i["stateAbbr"] = str(i["address"]["street"][0])+str(i["address"]["suite"][0])+str(i["address"]["city"][0])
            
            
        return users
    
    def generate_random_birthday(self):
       return  str(random.randint(1,12)).zfill(2)+str(random.randint(1,28)).zfill(2)+str(random.randint(1999,2006)).zfill(2)
    
    def generate_password(self, length=8):
        chars = string.ascii_letters + string.digits + "!@#$%" 
        return ''.join(random.choice(chars) for _ in range(length))
    
    
    def convert_date_format(self,date_str):
  
        date_str = date_str.zfill(8)
        
        mm = date_str[:2]
        dd = date_str[2:4]
        yyyy = date_str[4:]

        return f"{yyyy}-{mm}-{dd}"

            