import time
from selenium import webdriver
from selenium.webdriver.common.by import By

#executable_path = 'C:\\BrowserDrivers\\chromedriver-win32\\chromedriver.exe'
driver = webdriver.Chrome()
#driver = webdriver.Firefox()
#driver = webdriver.Edge()

#driver.get('https://www.figma.com/proto/wSTxPtYiCxh7bOqo3aCxkl/Cathx-UI-Project?page-id=1%3A2&type=design&node-id=341-11250&viewport=10997%2C14585%2C4.12&t=GqxBge71ql5sxwcc-1&scaling=contain&starting-point-node-id=341%3A11250&show-proto-sidebar=1')
driver.get('http://10.100.10.166/clarity')
driver.fullscreen_window()

time.sleep(10)

driver.quit()
