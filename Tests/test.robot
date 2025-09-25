*** Settings ***
Resource    ../Resources/App.resource
Resource    ../Resources/CustomerPage.resource
Suite Setup   Launch Browser  



*** Test Cases ***
TEST-000001
    [Documentation]    Get 5 users and add them in the system

    Login Customer
    @{customers}    Get Random Customers    ${5}
    Create Customers    ${customers} 

Test-000002
    [Documentation]   Get last 5 users and update the last 5 rows in the table with the users' information
    @{customers}    Get Random Customers    ${5}    ${4}
    Log To Console    ${customers}
    Update Customers    ${customers}    ${6}    ${10}    
    
Test-000003
    [Documentation]    Log all table rows in first page  
    Log Table Data



Test-000004
    [Documentation]    Log the spending of each customer and calculate total spending
    Display Users With Spending