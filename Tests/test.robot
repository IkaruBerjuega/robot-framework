*** Settings ***
Resource    ../Resources/App.resource
Resource    ../Resources/CustomerPage.resource
Suite Setup   Launch Browser  



*** Test Cases ***
TEST-000001
    [Documentation]    Get 5 users and add them in the system

    Login Customer
    @{customers}    Get Random Customers
    Create Customers    5    ${customers} 
    
    


