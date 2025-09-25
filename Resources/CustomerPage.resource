*** Settings ***
Resource      ./App.resource
Library    ../venv/lib/python3.13/site-packages/robot/libraries/Collections.py
Variables     ../Variables/customerpage.py
*** Variables ***
@{verified_users_list}


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
    
Input and Clear Data
    [Arguments]    ${element_to_clear_and_input_text}    ${input}

    Click Element    ${element_to_clear_and_input_text}
    ${existing_text}=    Get Value    ${element_to_clear_and_input_text}
    Run Keyword If    '${existing_text}' != ''    Press Keys    ${element_to_clear_and_input_text}    CTRL+A    COMMAND+A    BACKSPACE
    Input Text       ${element_to_clear_and_input_text}    ${input}


Input Customer Data
    [Arguments]    ${customer}
    Wait Until Element Is Visible    ${customers_txt_firstname}
    Input and Clear Data   ${customers_txt_firstname}    ${customer["name"].split(" ")[0]}
    Input and Clear Data   ${customers_txt_lastname}    ${customer["name"].split(" ")[1]}
    Input and Clear Data   ${customers_txt_email}    ${customer["email"]}
    Input Text  ${customers_txt_birthday}    ${customer["birthday"]}    
    Input and Clear Data   ${customers_txt_address}    ${customer["address"]["street"]} ${customer["address"]["suite"]}
    Input and Clear Data   ${customers_txt_city}    ${customer["address"]["city"]}
    Input and Clear Data   ${customers_txt_stateAbbr}    ${customer["stateAbbr"]}
    Input and Clear Data   ${customers_txt_zipcode}    ${customer["address"]["zipcode"]}
    Input and Clear Data   ${customers_txt_password}    ${customer["password"]}    
    Input and Clear Data   ${customers_txt_confirm_password}    ${customer["password"]}
Create Customer 
    [Arguments]    ${customer}
    Click Element    ${customers_btn_create}
    Wait Until Element Is Visible    ${customers_txt_firstname}
    Input Customer Data    ${customer}
    Click Button    ${customers_btn_save}
    Wait Until Page Contains    Customer created

Create Customers 
    [Arguments]    ${customers}   


    FOR    ${customer}    IN    @{customers}
        Go to Customers Page
        Create Customer    ${customer}
        Verify Customer is Added    ${customer}
    END

    Verify Table Display


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

    
    Append To List    ${verified_users_list}    ${customer}


Verify Table Display
    Go to Customers Page
    Log To Console    Verifying table display...
    Refresh Current Page
     
    FOR    ${i}    IN RANGE    1    5
        ${name_to_verify}    Get Text   ((${table_row})[${i}]//td)[2]
        ${index}=    Evaluate    5 - ${i}
        ${name_from_cur_tr}    Strip name     ${name_to_verify}
        Should Be Equal As Strings    ${name_from_cur_tr}    ${verified_users_list[${index}]["name"]}

    END

    Log To Console    Verified users in the table..


Strip name
    [Arguments]    ${name}

    IF    "\\n" in """${name}"""
        ${stripped_name}    Evaluate    """${name}""".replace("\\n","")[1:]
    END

    Return From Keyword    ${stripped_name}


Update Customer     
    [Arguments]    ${newCustomerData}    ${toClick}
    Click Element    ${toClick}
    Input Customer Data    ${newCustomerData}
    

Update Customers
    [Arguments]    ${newCustomersData}    ${startingRowIndex}    ${lastRowIndex}
    


    FOR    ${i}    IN RANGE    ${startingRowIndex}    ${lastRowIndex}
        Go to Customers Page
        ${index}    Evaluate    ${i} - ${startingRowIndex} 
        Update Customer    ${newCustomersData[${index}]}    (${table_row})[${i}]
    END


    Go to Customers Page


Log Table Data 
    ${row}=    Set Variable    1
    ${table_rows}=    Get Element Count    ${table_row}
    FOR    ${index}    IN RANGE    ${table_rows}
        ${name}=    Get Text    ((${table_row})[${row}]//td)[2]
        ${last_seen}=    Get Text    ((${table_row})[${row}]//td)[3]
        ${orders}=    Get Text    ((${table_row})[${row}]//td)[4]
        ${total_spent}=    Get Text    ((${table_row})[${row}]//td)[5]
        ${latest_purchase}=    Get Text    ((${table_row})[${row}]//td)[6]
        ${segments_count}=    Get Element Count    ((${table_row})[${row}]//td)[8]//span
        
        IF    "\\n" in """${name}"""
            ${name}    Evaluate    """${name}""".replace("\\n", " ")[1:]
        END


        Log To Console    \n
        Log To Console   ===== ${name} =====
        Log To Console    Name: ${name}
        Log To Console    Last Seen: ${last_seen}
        Log To Console    Orders: ${orders}
        Log To Console    Total Spent: ${total_spent}
        Log To Console    Latest Purchase: ${latest_purchase}

        ${segments}=    Create List
      
        FOR    ${index}    IN RANGE    1    ${segments_count + 1}
            ${span_text}=    Get Text    xpath=((${table_row})[${row}]//td)[8]//div[${index}]//span
            Append To List    ${segments}    ${span_text}
        END

       

        ${segments_list}=    Evaluate    ', '.join(${segments})
        Log To Console    Segments: ${segments_list}
        # Log To Console    Segments: ${segments}
        Log To Console    ===================\n
        
        ${row}=    Evaluate    ${row}+1
    END


Validate and Display Total Customer Spending
    [Arguments]    ${total_spending}
    
    ${formatted_total}=    Evaluate    "{:.2f}".format(${total_spending})

    Log To Console    =========================
    Log To Console    Total Customer Spending: $${formatted_total}
    Log To Console    =========================

    IF    ${total_spending} < 3500
        Log To Console    FAIL: Total Spending ($${formatted_total}) is below minimum threshold ($3,500)
    ELSE
        Log To Console    PASS: Total Spending ($${formatted_total}) meets minimum threshold ($3,500)
    END


Display Users With Spending 
    Log To Console    /n
    Log To Console    =====Customers Total Spending======
    ${row}=    Set Variable    1
    ${table_rows}=    Get Element Count    ${table_row}
    ${total_spending}=    Set Variable    ${0}

    FOR    ${index}    IN RANGE    ${table_rows}
        ${name}=    Get Text    ((${table_row})[${row}]//td)[2]
        ${total_spent}=    Get Text    ((${table_row})[${row}]//td)[5]
        
        IF    "\\n" in """${name}"""
            ${name}    Evaluate    """${name}""".replace("\\n", " ")[1:]
        END

        
        IF    ${total_spent[1:]} > 0 
            Log To Console    ${index}. Name: ${name} : ${total_spent}
            ${total_spending}    Evaluate    ${total_spending} + float("""${total_spent}"""[1:].replace(',', ''))
        END
       
        ${row}=    Evaluate    ${row}+1
    END

    Validate and Display Total Customer Spending    ${total_spending}
        

    Log To Console    \n
    


    
    
