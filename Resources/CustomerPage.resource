*** Settings ***
Resource      ./App.resource
Variables     ../Variables/customerpage.py


*** Keywords ***

Launch Browser
    [Arguments]    ${url}=${URL}     ${element_to_wait}=${login_txt_username}
    Open Browser       ${url}     chrome    options=add_argument("--start-maximized")
    Wait Until Keyword Succeeds    5x    5s     Wait Until Element Is Visible  ${element_to_wait}    

Login Customer 
    [Arguments]    ${username}=${USERNAME}      ${password}=${PASSWORD}
    Input Text    ${login_txt_username}    ${username}
    Input Text    ${login_txt_password}    ${password}
    Capture Page Screenshot
    Click Button    ${login_btn_submit}
   

    ${status}    Run Keyword And Return Status     Wait Until Element Is Visible    ${dashboard_hdr}    

    IF    ${status}
        Log To Console    Login Sucessful
    ELSE
        Log To Console    Login Failed
    END

    Capture Page Screenshot

Go to Customers Page
    Click Element    ${nav_btn_customers}
    Wait Until Element Is Visible    //table//tbody//tr    

Create Customer 
    [Arguments]    ${customer}
    Click Element    ${customers_btn_create}
    Wait Until Element Is Visible    ${customers_txt_firstname}
    Input Text    ${customers_txt_firstname}    ${customer["name"].split(" ")[0]}
    Input Text    ${customers_txt_lastname}    ${customer["name"].split(" ")[1]}
    Input Text    ${customers_txt_email}    ${customer["email"]}
    Input Text    ${customers_txt_birthday}    ${customer["birthday"]}
    Input Text    ${customers_txt_address}    ${customer["address"]["street"]} ${customer["address"]["suite"]}
    Input Text    ${customers_txt_city}    ${customer["address"]["city"]}
    Input Text    ${customers_txt_stateAbbr}    ${customer["stateAbbr"]}
    Input Text    ${customers_txt_zipcode}    ${customer["address"]["zipcode"]}
    Input Text    ${customers_txt_password}    ${customer["password"]}    
    Input Text    ${customers_txt_confirm_password}    ${customer["password"]}
    Click Button    ${customers_btn_save}
    Wait Until Page Contains    Customer created

Create Customers 
    [Arguments]    ${max_no_to_create}     ${customers}   


    ${count}=    Set Variable    0
    FOR    ${customer}    IN    @{customers}
        Exit For Loop If    ${count} >= ${max_no_to_create}
        Go to Customers Page
        Create Customer    ${customer}
        Verify Customer is Added    ${customer}
        ${count}=    Evaluate    ${count} + 1
    END

Verify Customer Is Added   
    [Arguments]    ${customer}
    ${first_name}    Get Element Attribute    ${customers_txt_firstname}    value
    ${last_name}    Get Element Attribute    ${customers_txt_lastname}    value
    ${email}    Get Element Attribute    ${customers_txt_email}    value
    ${birthday}    Get Element Attribute    ${customers_txt_birthday}    value
    ${address}    Get Element Attribute    ${customers_txt_address}    value
    ${city}    Get Element Attribute    ${customers_txt_city}    value
    ${stateAbbr}    Get Element Attribute    ${customers_txt_stateAbbr}    value
    ${zipcode}    Get Element Attribute    ${customers_txt_zipcode}    value
    ${password}    Get Element Attribute    ${customers_txt_password}    value
    ${confirm_password}    Get Element Attribute    ${customers_txt_confirm_password}    value


    
    Should Be Equal As Strings    ${first_name}    ${customer["name"].split(" ")[0]}
    Should Be Equal As Strings    ${lastname}    ${customer["name"].split(" ")[1]}
    Should Be Equal As Strings    ${email}    ${customer["email"]}
    ${customer_birthday}    Convert Date Format    ${customer["birthday"]}
    Should Be Equal As Strings    ${birthday}    ${customer_birthday}
    Should Be Equal As Strings    ${address}    ${customer["address"]["street"]} ${customer["address"]["suite"]}
    Should Be Equal As Strings    ${city}    ${customer["address"]["city"]}
    Should Be Equal As Strings    ${stateAbbr}     ${customer["stateAbbr"]}
    Should Be Equal As Strings    ${zipcode}     ${customer["address"]["zipcode"]}
    Should Be Equal As Strings    ${password}    ${customer["password"]}
    Should Be Equal As Strings    ${confirm_password}    ${customer["password"]}


