module Page.Terms exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)


view : Html msg
view =
    div [ class "" ]
        [ div [ class "" ]
            [ div [ class "jumbotron text-center" ]
                [ div [ class "container" ]
                    [ img [ class "img-fluid mb-4", alt "Haven GRC Company Logo", attribute "data-rjs" "2", id "logo", src "/img/logo@2x.png", height 71, width 82 ]
                        []
                    , h1 []
                        [ text "Haven GRC Software Service Terms" ]
                    ]
                ]
            ]
        , div [ class "py-5 bg-light" ]
            [ div [ class "" ]
                [ div [ class "pb-5" ] 
                    [ 
                    div [ class "row px-5" ]
                    [ div [ class "col-12 px-12" ]
                        [ article []
                            [
                                p []
                                    [ dfn []
                                        [ text "Provider" ] , text " and " 
                                    , dfn []
                                        [ text "Customer" ] , text " agree: " 
                                    ]
                                , section []
                                    [ h2 []
                                        [ text "Software" ]
                                    , section []
                                        [ p []
                                            [ text "The " , dfn []
                                                [ text "Software" ] , text " is " 
                                            , span [ class "blank" ]
                                                [ text "Haven GRC" ] , text " , for " 
                                            , span [ class "blank" ]
                                                [ text "tamper proof evidence storage, compliance, and risk dashboard" ] , text "." 
                                            ]
                                        ]
                                    , section []
                                        [ p []
                                            [ text "The " , dfn []
                                                [ text "Website" ] , text " is at " 
                                            , span [ class "blank" ]
                                                [ text " https://havengrc.com/ " ] , text "." 
                                            ]
                                        ]
                                    , section []
                                        [ p []
                                            [ text "The " , dfn []
                                                [ text "Account Dashboard" ] , text " is at " 
                                            , span [ class "blank" ]
                                                [ text " https://account.havengrc.com/ " ] , text "." 
                                            ]
                                        ]
                                    , section []
                                        [ p []
                                            [ text "The " , dfn []
                                                [ text "Documentation" ] , text " is at " 
                                            , span [ class "blank" ]
                                                [ text " https://docs.havengrc.com/ " ] , text "." 
                                            ]
                                        ]
                                    ]
                                , section []
                                    [ h2 []
                                        [ text "Order" ]
                                    , section []
                                        [ p []
                                            [ text "These terms, together with the specifics of the accompanying" , span [ class "term" ]
                                                [ text "Order" ] , text ", govern" 
                                            , span [ class "term" ]
                                                [ text "Customer" ] , text "'"  , text "s use of the" 
                                            , span [ class "term" ]
                                                [ text "Software" ] , text ". The" 
                                            , dfn []
                                                [ text "Order" ] , text "is either:" 
                                            ]
                                        , section []
                                            [ p []
                                                [ text "the order" , span [ class "term" ]
                                                    [ text "Customer" ] , text "submitted through the" 
                                                , span [ class "term" ]
                                                    [ text "Account Dashboard" ] , text ", for a" 
                                                , span [ class "term" ]
                                                    [ text "Product Package" ] , text "that" 
                                                , span [ class "term" ]
                                                    [ text "Provider" ] , text "offered through the" 
                                                , span [ class "term" ]
                                                    [ text "Account Dashboard" ]
                                                ]
                                            ]
                                        , section []
                                            [ p []
                                                [ text "the purchase order" , span [ class "term" ]
                                                    [ text "Customer" ] , text "sent" 
                                                , span [ class "term" ]
                                                    [ text "Provider" ] , text ", for a" 
                                                , span [ class "term" ]
                                                    [ text "Product Package" ] , text "that" 
                                                , span [ class "term" ]
                                                    [ text "Provider" ] , text "quoted to" 
                                                , span [ class "term" ]
                                                    [ text "Customer" ]
                                                ]
                                            ]
                                        ]
                                    , section []
                                        [ p []
                                            [ text "A"  , dfn []
                                                [ text "Product Package" ] , text "is an offer of specific" 
                                            , dfn []
                                                [ text "Deal Terms" ] , text "from" 
                                            , span [ class "term" ]
                                                [ text "Provider" ] , text ":" 
                                            ]
                                        , section []
                                            [ p []
                                                [ span [ class "term" ]
                                                    [ text "Hosted Software" ] , text "or" 
                                                , span [ class "term" ]
                                                    [ text "Licensed Software" ]
                                                ]
                                            ]
                                        , section []
                                            [ p []
                                                [ text "a" , dfn []
                                                    [ text "Feature Set" ] , text "of" 
                                                , span [ class "term" ]
                                                    [ text "Software Features" ]
                                                ]
                                            ]
                                        , section []
                                            [ p []
                                                [ dfn []
                                                    [ text "Use Allowances" ] , text ": numeric limits on use of the" 
                                                , span [ class "term" ]
                                                    [ text "Software" ] , text ", such as" , text "\"" , text "ten" 
                                                , span [ class "term" ]
                                                    [ text "User Accounts" ] ,text "\"" ,  text "," , text "\"" , text "two" 
                                                , span [ class "term" ]
                                                    [ text "Running Instances" ] , text "\"" , text ", or" , text "\""  , text "twenty" 
                                                , span [ class "term" ]
                                                    [ text "Concurrent Users" ] , text "\"" 
                                                ]
                                            ]
                                        , section []
                                            [ p []
                                                [ dfn []
                                                    [ text "Software Pricing" ] , text ": a way to calculate" 
                                                , dfn []
                                                    [ text "Software Fees" ] , text ", such as a flat amount for a set number of" 
                                                , span [ class "term" ]
                                                    [ text "User Accounts" ] , text ", an amount based on the number of" 
                                                , span [ class "term" ]
                                                    [ text "Running Instances" ] , text ", or a free trial followed by a flat monthly fee" 
                                                ]
                                            ]
                                        , section []
                                            [ p []
                                                [ text "a" , dfn []
                                                    [ text "Commitment Period" ] , text ": the recurring period of time, starting on the" 
                                                , span [ class "term" ]
                                                    [ text "Order" ] , text "date, when" 
                                                , span [ class "term" ]
                                                    [ text "Provider" ] , text "commits to the" 
                                                , span [ class "term" ]
                                                    [ text "Deal Terms" ] , text ", such as each month, each quarter, or each year" 
                                                ]
                                            ]
                                        , section []
                                            [ p []
                                                [ text "a" , dfn []
                                                    [ text "Payment Method" ] , text "such as automatic credit card charges or invoices paid by wire transfer" 
                                                ]
                                            ]
                                        , section []
                                            [ p []
                                                [ text "a"  , dfn []
                                                    [ text "Billing Cycle" ] , text "such as monthly or annually, on which" 
                                                , span [ class "term" ]
                                                    [ text "Customer" ] 
                                                    , text "will pay for use of the" 
                                                , span [ class "term" ]
                                                    [ text "Software" ]
                                                ]
                                            ]
                                        , section []
                                            [ p []
                                                [ text "if the" , span [ class "term" ]
                                                    [ text "Product Package" ] , text "is for" 
                                                , span [ class "term" ]
                                                    [ text "Hosted Software" ] , text ", any" 
                                                , span [ class "term" ]
                                                    [ text "Service-Level Agreement" ] , text "for the" 
                                                , span [ class "term" ]
                                                    [ text "Website" ]
                                                ]
                                            ]
                                        , section []
                                            [ p []
                                                [ text "if the" , span [ class "term" ]
                                                    [ text "Product Package" ] , text "includes support services:" 
                                                ]
                                            , section []
                                                [ p []
                                                    [ dfn []
                                                        [ text "Support Terms" ] , text "setting how and when" 
                                                    , span [ class "term" ]
                                                        [ text "Provider" ] , text "will respond to" 
                                                    , span [ class "term" ]
                                                        [ text "Support Requests" ]
                                                    ]
                                                ]
                                            , section []
                                                [ p []
                                                    [ dfn []
                                                        [ text "Support Pricing" ] , text ": a way to calculate" 
                                                    , dfn []
                                                        [ text "Support Fees" ]
                                                    ]
                                                ]
                                            , section []
                                                [ p []
                                                    [ text "any" , span [ class "term" ]
                                                        [ text "Service-Level Agreement" ] , text "for response to" 
                                                    , span [ class "term" ]
                                                        [ text "Support Requests" ]
                                                    ]
                                                ]
                                            ]
                                        , section []
                                            [ p []
                                                [ text "any" , dfn []
                                                    [ text "Eligibility Criteria" ] , text "that" 
                                                , span [ class "term" ]
                                                    [ text "Customer" ] , text "must meet to order the" 
                                                , span [ class "term" ]
                                                    [ text "Product Package" ] , text ", such as 501(c)(3) tax-exempt status" 
                                                ]
                                            ]
                                        ]
                                    , section []
                                        [ h3 []
                                            [ text "Custom Deal Terms" ]
                                        , p []
                                            [ text "A" , span [ class "term" ]
                                                [ text "Product Package" ] , text "may allow" 
                                            , span [ class "term" ]
                                                [ text "Customer" ] , text "to choose particular" 
                                            , span [ class "term" ]
                                                [ text "Deal Terms" ] , text "for itself, such as" 
                                            , span [ class "term" ]
                                                [ text "Use Allowances" ] , text "numbers or" 
                                            , span [ class "term" ]
                                                [ text "Payment Method" ] , text "." 
                                            , span [ class "term" ]
                                                [ text "Customer" ] , text "'" , text "s choices on entering this agreement are also part of the" 
                                            , span [ class "term" ]
                                                [ text "Order" ] , text "." 
                                            ]
                                        ]
                                    , section []
                                        [ h3 []
                                            [ text "Default Deal Terms" ]
                                        , section []
                                            [ p []
                                                [ text "If a" , span [ class "term" ]
                                                    [ text "Product Package" ] , text "doesn" , text "'" , text "t mention a currency for" 
                                                , span [ class "term" ]
                                                    [ text "Software Pricing" ] , text "or" 
                                                , span [ class "term" ]
                                                    [ text "Support Pricing" ] , text ", the currency is United States Dollars." 
                                                ]
                                            ]
                                        , section []
                                            [ p []
                                                [ text "If a" , span [ class "term" ]
                                                    [ text "Product Package" ] , text "doesn" , text "'" , text "t mention a" 
                                                , span [ class "term" ]
                                                    [ text "Feature Set" ] , text ", the" 
                                                , span [ class "term" ]
                                                    [ text "Feature Set" ] , text "is all" 
                                                , span [ class "term" ]
                                                    [ text "Software Features" ] , text "described in the" 
                                                , span [ class "term" ]
                                                    [ text "Documentation" ] , text "on the" 
                                                , span [ class "term" ]
                                                    [ text "Order" ] , text "date." 
                                                ]
                                            ]
                                        , section []
                                            [ p []
                                                [ text "If a" , span [ class "term" ]
                                                    [ text "Product Package" ] , text "offers a" 
                                                , span [ class "term" ]
                                                    [ text "Payment Method" ] , text "that" 
                                                , span [ class "term" ]
                                                    [ text "Provider" ] , text "must start by billing" 
                                                , span [ class "term" ]
                                                    [ text "Customer" ] , text ", but does not mention payment terms, payments are due within thirty calendar days of receiving each bill, with late-payment interest of 1.5%, compounded monthly." 
                                                ]
                                            ]
                                        , section []
                                            [ p []
                                                [ text "If a" , span [ class "term" ]
                                                    [ text "Product Package" ] , text "includes support services, but doesn" , text "'" , text "t say when" 
                                                , span [ class "term" ]
                                                    [ text "Provider" ] , text "will respond to" 
                                                , span [ class "term" ]
                                                    [ text "Support Requests" ] , text "," 
                                                , span [ class "term" ]
                                                    [ text "Provider" ] , text "will respond on" 
                                                , span [ class "term" ]
                                                    [ text "Business Days" ] , text "from 8:30 AM to 6:30 PM in the time zone of" 
                                                , span [ class "term" ]
                                                    [ text "Provider" , text "'" , text "s Main Office" ] , text "." 
                                                ]
                                            ]
                                        ]
                                    ]
                                , section []
                                    [ h2 []
                                        [ text "Provider" , text "'" , text "s Obligations" ]
                                    , section []
                                        [ h3 []
                                            [ text "Provide the Software" ]
                                        , section []
                                            [ h4 []
                                                [ text "Hosted" ]
                                            , p []
                                                [ text "If the" , span [ class "term" ]
                                                    [ text "Order" ] , text "is for" 
                                                , dfn []
                                                    [ text "Hosted Software" ] , text ":" 
                                                ]
                                            , section []
                                                [ h5 []
                                                    [ text "Run the Software" ]
                                                , p []
                                                    [ text "While the" , span [ class "term" ]
                                                        [ text "Order" ] , text "continues," 
                                                    , span [ class "term" ]
                                                        [ text "Provider" ] , text "agrees to run the" 
                                                    , span [ class "term" ]
                                                        [ text "Software" ] , text "so that" 
                                                    , span [ class "term" ]
                                                        [ text "Customer Personnel" ] , text "can use the" 
                                                    , span [ class "term" ]
                                                        [ text "Feature Set" ] , text "by visiting the" 
                                                    , span [ class "term" ]
                                                        [ text "Website" ] , text "with computers and software that meet any requirements set out in the current" 
                                                    , span [ class "term" ]
                                                        [ text "Documentation" ] , text "." 
                                                    ]
                                                ]
                                            , section []
                                                [ h5 []
                                                    [ text "Send Access Credentials" ]
                                                , p []
                                                    [ span [ class "term" ]
                                                        [ text "Provider"  ], text "agrees to send" 
                                                    , span [ class "term" ]
                                                        [ text "Customer" ] , text "a set of administrative" 
                                                    , span [ class "term" ]
                                                        [ text "Access Credentials" ] , text "for the" 
                                                    , span [ class "term" ]
                                                        [ text "Software" ] , text "on entering into this agreement. While the" 
                                                    , span [ class "term" ]
                                                        [ text "Order" ] , text "continues," 
                                                    , span [ class "term" ]
                                                        [ text "Provider" ] , text "agrees to send" 
                                                    , span [ class "term" ]
                                                        [ text "Customer" ] , text "a new set of administrative" 
                                                    , span [ class "term" ]
                                                        [ text "Access Credentials" ] , text "on request." 
                                                    ]
                                                ]
                                            , section []
                                                [ h5 []
                                                    [ text "Keep Customer Data Confidential" ]
                                                , p []
                                                    [ span [ class "term" ]
                                                        [ text "Provider" ] , text "agrees not to access, use, or disclose" 
                                                    , span [ class "term" ]
                                                        [ text "Customer Data" ] , text "without" 
                                                    , span [ class "term" ]
                                                        [ text "Permission" ] , text ", except:" 
                                                    ]
                                                , section []
                                                    [ p []
                                                        [ text "as needed to provide the" , span [ class "term" ]
                                                            [ text "Software" ]
                                                        ]
                                                    ]
                                                , section []
                                                    [ p []
                                                        [ text "to monitor use of the" , span [ class "term" ]
                                                            [ text "Software" ] , text "to prevent, detect, and mitigate breach of these terms" 
                                                        ]
                                                    ]
                                                , section []
                                                    [ p []
                                                        [ text "to respond to" , span [ class "term" ]
                                                            [ text "Support Requests" ]
                                                        ]
                                                    ]
                                                ]
                                            , section []
                                                [ h5 []
                                                    [ text "Take Security Precautions" ]
                                                , p []
                                                    [ span [ class "term" ]
                                                        [ text "Provider" ] , text "agrees to take industry-standard security precautions to keep" 
                                                    , span [ class "term" ]
                                                        [ text "Customer Data" ] , text "that it has secure from inadvertent publication, leak, and hacker attack." 
                                                    , span [ class "term" ]
                                                        [ text "Provider" ] , text "does not agree to make sure" 
                                                    , span [ class "term" ]
                                                        [ text "Customer Data" ] , text "is completely free of software bugs or configuration errors affecting security, or completely secure from all possible hacker attacks." 
                                                    ]
                                                ]
                                            , section []
                                                [ h5 []
                                                    [ text "Prepare for Disasters" ]
                                                , p []
                                                    [ text "While the" , span [ class "term" ]
                                                        [ text "Order" ] , text "continues," 
                                                    , span [ class "term" ]
                                                        [ text "Provider" ] , text "agrees to:" 
                                                    ]
                                                , section []
                                                    [ p []
                                                        [ text "adopt, maintain, and periodically review a written plan to recover from any" , span [ class "term" ]
                                                            [ text "Disaster" ] , text "affecting the computers used to provide the" 
                                                        , span [ class "term" ]
                                                            [ text "Software" ] , text "or the integrity of" 
                                                        , span [ class "term" ]
                                                            [ text "Customer Data" ]
                                                        ]
                                                    ]
                                                , section []
                                                    [ p []
                                                        [ text "share the plan with relevant" , span [ class "term" ]
                                                            [ text "Provider" ] , text "personnel" 
                                                        ]
                                                    ]
                                                , section []
                                                    [ p []
                                                        [ text "give" , span [ class "term" ]
                                                            [ text "Customer" ] , text "a copy of the current plan on request" 
                                                        ]
                                                    ]
                                                , section []
                                                    [ p []
                                                        [ text "follow the plan if a" , span [ class "term" ]
                                                            [ text "Disaster" ] , text "happens" 
                                                        ]
                                                    ]
                                                ]
                                            , section []
                                                [ h5 []
                                                    [ text "Use Responsible Subcontractors" ]
                                                , p []
                                                    [ span [ class "term" ]
                                                        [ text "Provider" ] , text "agrees to make sure its employees and contractors abide by" 
                                                    , span [ class "reference" ]
                                                        [ text "Keep Customer Data Confidential" ] , text "," 
                                                    , span [ class "reference" ]
                                                        [ text "Take Security Precautions" ] , text "," 
                                                    , span [ class "reference" ]
                                                        [ text "Prepare for Disasters" ] , text ", and" 
                                                    , span [ class "reference" ]
                                                        [ text "Keep Malicious Code Out of the Software" ] , text "." 
                                                    , span [ class "term" ]
                                                        [ text "Provider" ] , text "may contract with others to provide computers and software services used to provide the" 
                                                    , span [ class "term" ]
                                                        [ text "Software" ] , text "to" 
                                                    , span [ class "term" ]
                                                        [ text "Customer" ] , text "." 
                                                    ]
                                                ]
                                            ]
                                        , section []
                                            [ h4 []
                                                [ text "Licensed" ]
                                            , p []
                                                [ text "If the" , span [ class "term" ]
                                                    [ text "Order" ] , text "is for" 
                                                , dfn []
                                                    [ text "Licensed Software" ] , text ":" 
                                                ]
                                            , section []
                                                [ h5 []
                                                    [ text "Provide a Download" ]
                                                , p []
                                                    [ text "While the" , span [ class "term" ]
                                                        [ text "Order" ] , text "continues," 
                                                    , span [ class "term" ]
                                                        [ text "Provider" ] , text "agrees to make the" 
                                                    , span [ class "term" ]
                                                        [ text "Latest Version of the Software" ] , text "supporting the" 
                                                    , span [ class "term" ]
                                                        [ text "Feature Set" ] , text "available for" 
                                                    , span [ class "term" ]
                                                        [ text "Customer" ] , text "to download through the" 
                                                    , span [ class "term" ]
                                                        [ text "Account Dashboard" ] , text "." 
                                                    ]
                                                ]
                                            , section []
                                                [ h5 []
                                                    [ text "Document Installation and Configuration" ]
                                                , p []
                                                    [ text "While the" , span [ class "term" ]
                                                        [ text "Order" ] , text "continues," 
                                                    , span [ class "term" ]
                                                        [ text "Provider" ] , text "agrees to make sure the" 
                                                    , span [ class "term" ]
                                                        [ text "Documentation" ] , text "has instructions that enable a system administrator experienced with a supported operating system to install, configure, and run the" 
                                                    , span [ class "term" ]
                                                        [ text "Latest Version of the Software" ] , text "." 
                                                    ]
                                                ]
                                            , section []
                                                [ h5 []
                                                    [ text "Make Sure Customer Can Download Software Dependencies" ]
                                                , p []
                                                    [ text "While the" , span [ class "term" ]
                                                        [ text "Order" ] , text "continues," 
                                                    , span [ class "term" ]
                                                        [ text "Provider" ] , text "agrees to make sure any" 
                                                    , span [ class "term" ]
                                                        [ text "Software Dependencies" ] , text "not included in the download of the" 
                                                    , span [ class "term" ]
                                                        [ text "Latest Version of the Software" ] , text "from the" 
                                                    , span [ class "term" ]
                                                        [ text "Account Dashboard" ] , text "are" 
                                                    , span [ class "term" ]
                                                        [ text "Publicly Licensed" ] , text "and generally available for" 
                                                    , span [ class "term" ]
                                                        [ text "Customer" ] , text "to download from a" 
                                                    , span [ class "term" ]
                                                        [ text "Public Software Repository" ] , text "." 
                                                    , span [ class "term" ]
                                                        [ text "Provider" ] , text "does not agree to any" 
                                                    , span [ class "term" ]
                                                        [ text "Service-Level Agreement" ] , text "or other specific guarantee about any" 
                                                    , span [ class "term" ]
                                                        [ text "Public Software Repository" ] , text "." 
                                                    ]
                                                ]
                                            ]
                                        ]
                                    , section []
                                        [ h3 []
                                            [ text "Provide Support" ]
                                        , p []
                                            [ text "While the" , span [ class "term" ]
                                                [ text "Order" ] , text "continues, if the" 
                                            , span [ class "term" ]
                                                [ text "Order" ] , text "includes" 
                                            , span [ class "term" ]
                                                [ text "Support Terms" ] , text "," 
                                            , span [ class "term" ]
                                                [ text "Provider" ] , text "agrees to respond to" 
                                            , span [ class "term" ]
                                                [ text "Support Requests" ] , text "as the" 
                                            , span [ class "term" ]
                                                [ text "Support Terms" ] , text "describe." 
                                            ]
                                        ]
                                    , section []
                                        [ h3 []
                                            [ text "Publish Documentation" ]
                                        , p []
                                            [ text "While the" , span [ class "term" ]
                                                [ text "Order" ] , text "continues," 
                                            , span [ class "term" ]
                                                [ text "Provider" ] , text "agrees to host the" 
                                            , span [ class "term" ]
                                                [ text "Documentation" ] , text "so" 
                                            , span [ class "term" ]
                                                [ text "Customer" ] , text "personnel can read it via the Internet." 
                                            ]
                                        ]
                                    , section []
                                        [ h3 []
                                            [ text "Give Credits for Bad Service" ]
                                        , p []
                                            [ text "If the" , span [ class "term" ]
                                                [ text "Order" ] , text "includes any" 
                                            , span [ class "term" ]
                                                [ text "Service-Level Agreement" ] , text "," 
                                            , span [ class "term" ]
                                                [ text "Provider" ] , text "agrees to credit" 
                                            , span [ class "term" ]
                                                [ text "Customer" ] , text "'" , text "s account on" 
                                            , span [ class "term" ]
                                                [ text "Notice" ] , text "and verification that it failed to provide service according to the" 
                                            , span [ class "term" ]
                                                [ text "Service-Level Agreement" ] , text "." 
                                            , span [ class "term" ]
                                                [ text "Provider" ] , text "agrees to apply credits against" 
                                            , span [ class "term" ]
                                                [ text "Customer" ] , text "'" , text "s obligations to pay" 
                                            , span [ class "term" ]
                                                [ text "Fees" ] , text "as soon as possible." 
                                            , span [ class "term" ]
                                                [ text "Provider" ] , text "does not agree to refund any credits." 
                                            ]
                                        ]
                                    , section []
                                        [ h3 []
                                            [ text "Refund Fees for Poor Service" ]
                                        , p []
                                            [ text "If" , span [ class "term" ]
                                                [ text "Provider" ] , text "credits" 
                                            , span [ class "term" ]
                                                [ text "Customer" ] , text "'" , text "s account under a" 
                                            , span [ class "term" ]
                                                [ text "Service-Level Agreement" ] , text "for three months in a row, and" 
                                            , span [ class "term" ]
                                                [ text "Customer" ] , text "ends the" 
                                            , span [ class "term" ]
                                                [ text "Order" ] , text "during the third month, citing poor service," 
                                            , span [ class "term" ]
                                                [ text "Provider" ] , text "agrees to refund" 
                                            , span [ class "term" ]
                                                [ text "Fees" ] , text "that" 
                                            , span [ class "term" ]
                                                [ text "Customer" ] , text "paid for those three months, as well as any" 
                                            , span [ class "term" ]
                                                [ text "Prepaid Fees" ] , text "." 
                                            ]
                                        ]
                                    , section []
                                        [ h3 []
                                            [ text "Refund Prepaid Fees for Removed Features" ]
                                        , p []
                                            [ text "If" , span [ class "term" ]
                                                [ text "Provider" ] , text "changes or removes" 
                                            , span [ class "term" ]
                                                [ text "Software Features" ] , text "from the" 
                                            , span [ class "term" ]
                                                [ text "Latest Version of the Software" ] , text "that were part of the" 
                                            , span [ class "term" ]
                                                [ text "Feature Set" ] , text ", substantially reducing how useful the" 
                                            , span [ class "term" ]
                                                [ text "Software" ] , text "is to" 
                                            , span [ class "term" ]
                                                [ text "Customer" ] , text ", and" 
                                            , span [ class "term" ]
                                                [ text "Customer" ] , text "ends the" 
                                            , span [ class "term" ]
                                                [ text "Order" ] , text "within three calendar months of the change, citing the change," 
                                            , span [ class "term" ]
                                                [ text "Provider" ] , text "agrees to refund any" 
                                            , span [ class "term" ]
                                                [ text "Prepaid Fees" ] , text "." 
                                            ]
                                        ]
                                    , section []
                                        [ h3 []
                                            [ text "Keep Malicious Code Out of the Software" ]
                                        , p []
                                            [ text "While the" , span [ class "term" ]
                                                [ text "Order" ] , text "continues," 
                                            , span [ class "term" ]
                                                [ text "Provider" ] , text "agrees to make sure the" 
                                            , span [ class "term" ]
                                                [ text "Latest Version of the Software" ] , text "is free of malicious code." 
                                            ]
                                        ]
                                    , section []
                                        [ h3 []
                                            [ text "Limit Validation Code in the Software" ]
                                        , p []
                                            [ span [ class "term" ]
                                                [ text "Provider" ] , text "may include code in the" 
                                            , span [ class "term" ]
                                                [ text "Latest Version of the Software" ] , text "that automatically disables" 
                                            , span [ class "term" ]
                                                [ text "Software Features" ] , text "on failure to validate administrative" 
                                            , span [ class "term" ]
                                                [ text "Access Credentials" ] , text ", but agrees not to include any code that disables" 
                                            , span [ class "term" ]
                                                [ text "Software Features" ] , text "based on monitoring of" 
                                            , span [ class "term" ]
                                                [ text "Use Allowances" ] , text "." 
                                            , span [ class "term" ]
                                                [ text "Provider" ] , text "may include code that monitors" 
                                            , span [ class "term" ]
                                                [ text "Use Allowances" ] , text ", validates administrative" 
                                            , span [ class "term" ]
                                                [ text "Access Credentials" ] , text ", and reports results back to" 
                                            , span [ class "term" ]
                                                [ text "Provider" ] , text "systems." 
                                            ]
                                        ]
                                    , section []
                                        [ h3 []
                                            [ text "Protect Customer from Liability" ]
                                        , p []
                                            [ text "So long as the" ,  span [ class "term" ]
                                                [ text "Pricing" ] , text "requires" 
                                            , span [ class "term" ]
                                                [ text "Customer" ] , text "to pay some amount of" 
                                            , span [ class "term" ]
                                                [ text "Software Fees" ] , text ", and" 
                                            , span [ class "term" ]
                                                [ text "Customer" ] , text "has paid all" 
                                            , span [ class "term" ]
                                                [ text "Fees" ] , text "as required by the" 
                                            , span [ class "term" ]
                                                [ text "Pricing" ] , text ":" 
                                            ]
                                        , section []
                                            [ h4 []
                                                [ text "Indemnify Customer" ]
                                            , p []
                                                [ text "Subject to" , span [ class "reference" ]
                                                    [ text "Indemnification Process" ] , text "," 
                                                , span [ class "term" ]
                                                    [ text "Provider" ] , text "agrees to give" 
                                                , span [ class "term" ]
                                                    [ text "Customer" ]
                                                , span [ class "term" ]
                                                    [ text "Indemnification" ] , text "for" 
                                                , span [ class "term" ]
                                                    [ text "Legal Claims" ] , text "by others alleging that" 
                                                , span [ class "term" ]
                                                    [ text "Permitted Use of the Software" ] , text "infringes any copyright, trademark, or trade secret right, or breaks any law." 
                                                ]
                                            ]
                                        , section []
                                            [ h4 []
                                                [ text "Provide Assurance about Patents" ]
                                            , p []
                                                [ text "As of the" , span [ class "term" ]
                                                    [ text "Order" ] , text "date," 
                                                , span [ class "term" ]
                                                    [ text "Provider" ] , text "is not aware of any patent that" 
                                                , span [ class "term" ]
                                                    [ text "Provider" ] , text "would infringe by licensing or providing the" 
                                                , span [ class "term" ]
                                                    [ text "Software" ] , text "under these terms, or that" 
                                                , span [ class "term" ]
                                                    [ text "Customer" ] , text "would infringe by" 
                                                , span [ class "term" ]
                                                    [ text "Permitted Use of the Software" ] , text "." 
                                                ]
                                            ]
                                        , section []
                                            [ h4 []
                                                [ text "Address Legal Problems" ]
                                            , p []
                                                [ span [ class "term" ]
                                                    [ text "Provider" ] , text "agrees that if someone else gets a court order against" 
                                                , span [ class "term" ]
                                                    [ text "Customer" ] , text "'" , text "s" 
                                                , span [ class "term" ]
                                                    [ text "Permitted Use of the Software" ] , text "based on a claim that it infringes any" 
                                                , span [ class "term" ]
                                                    [ text "Intellectual Property Right" ] , text ", or breaks any law, and whenever" 
                                                , span [ class "term" ]
                                                    [ text "Provider" ] , text "anticipates that kind of claim," 
                                                , span [ class "term" ]
                                                    [ text "Provider" ] , text "will give" 
                                                , span [ class "term" ]
                                                    [ text "Customer" ] , text "prompt" 
                                                , span [ class "term" ]
                                                    [ text "Notice" ] , text ", and may take any of these added steps:" 
                                                ]
                                            , section []
                                                [ p []
                                                    [ span [ class "term" ]
                                                        [ text "Provider" ] , text "may release a new" 
                                                    , span [ class "term" ]
                                                        [ text "Latest Version of the Software" ] , text "so that" 
                                                    , span [ class "term" ]
                                                        [ text "Permitted Use of the Software" ] , text "will no longer infringe or break the law." 
                                                    ]
                                                ]
                                            , section []
                                                [ p []
                                                    [ text "If the" , span [ class "term" ]
                                                        [ text "Order" ] , text "is for" 
                                                    , span [ class "term" ]
                                                        [ text "Hosted Software" ] , text "," 
                                                    , span [ class "term" ]
                                                        [ text "Provider" ] , text "may change how it provides the" 
                                                    , span [ class "term" ]
                                                        [ text "Software" ] , text "so that" 
                                                    , span [ class "term" ]
                                                        [ text "Permitted Use of the Software" ] , text "will no longer infringe or break the law." 
                                                    ]
                                                ]
                                            , section []
                                                [ p []
                                                    [ text "If the problem is infringement," , span [ class "term" ]
                                                        [ text "Provider" ] , text "may get a license for" 
                                                    , span [ class "term" ]
                                                        [ text "Customer" ] , text "so that" 
                                                    , span [ class "term" ]
                                                        [ text "Permitted Use of the Software" ] , text "will no longer infringe." 
                                                    ]
                                                ]
                                            , section []
                                                [ p []
                                                    [ text "If the problem is illegality," , span [ class "term" ]
                                                        [ text "Provider" ] , text "may get the government approvals, licenses, or other requirements needed to abide by the law." 
                                                    ]
                                                ]
                                            , section []
                                                [ p []
                                                    [ span [ class "term" ]
                                                        [ text "Provider" ] , text "may end the" 
                                                    , span [ class "term" ]
                                                        [ text "Order" ] , text "and refund any" 
                                                    , span [ class "term" ]
                                                        [ text "Prepaid Fees" ] , text "." 
                                                    ]
                                                ]
                                            ]
                                        ]
                                    ]
                                , section []
                                    [ h2 []
                                        [ text "Customer" , text "'" , text "s Obligations" ]
                                    , section []
                                        [ h3 []
                                            [ text "Pay Fees" ]
                                        , p []
                                            [ span [ class "term" ]
                                                [ text "Customer" ] , text "agrees to pay all" 
                                            , span [ class "term" ]
                                                [ text "Fees" ] , text ", in advance, for each period on the" 
                                            , span [ class "term" ]
                                                [ text "Billing Cycle" ] , text ", using the agreed" 
                                            , span [ class "term" ]
                                                [ text "Payment Method" ] , text "." 
                                            , span [ class "term" ]
                                                [ text "Customer" ] , text "agrees to pay all tax on" 
                                            , span [ class "term" ]
                                                [ text "Software Fees" ] , text "and" 
                                            , span [ class "term" ]
                                                [ text "Support Fees" ] , text ", except tax" 
                                            , span [ class "term" ]
                                                [ text "Provider" ] , text "owes on income." 
                                            ]
                                        ]
                                    , section []
                                        [ h3 []
                                            [ text "Follow Rules About Use" ]
                                        , p []
                                            [ span [ class "term" ]
                                                [ text "Customer" ] , text "agrees not to:" 
                                            ]
                                        , section []
                                            [ p []
                                                [ text "reverse engineer the" , span [ class "term" ]
                                                    [ text "Software" ]
                                                ]
                                            ]
                                        , section []
                                            [ p []
                                                [ text "circumvent any access controls or other limits of the" , span [ class "term" ]
                                                    [ text "Software" ]
                                                ]
                                            ]
                                        , section []
                                            [ p []
                                                [ text "circumvent code permitted under" , span [ class "reference" ]
                                                    [ text "Limit Validation Code in the Software" ]
                                                ]
                                            ]
                                        , section []
                                            [ p []
                                                [ text "violate others others" , text "'" , text "intellectual property or other rights using the" , span [ class "term" ]
                                                    [ text "Software" ]
                                                ]
                                            ]
                                        , section []
                                            [ p []
                                                [ text "breach any agreement using the" , span [ class "term" ]
                                                    [ text "Software" ]
                                                ]
                                            ]
                                        , section []
                                            [ p []
                                                [ text "break the law using the" , span [ class "term" ]
                                                    [ text "Software" ]
                                                ]
                                            ]
                                        , section []
                                            [ p []
                                                [ text "license, sell, lease, or otherwise let anyone but" , span [ class "term" ]
                                                    [ text "Customer Personnel" ] , text "use" 
                                                , span [ class "term" ]
                                                    [ text "Software Features" ]
                                                ]
                                            ]
                                        , section []
                                            [ p []
                                                [ text "furnish" , span [ class "term" ]
                                                    [ text "Customer Data" ] , text "in any way that infringes any" 
                                                , span [ class "term" ]
                                                    [ text "Intellectual Property Right" ] , text ", breaks any law, or breaches any other agreement" 
                                                ]
                                            ]
                                        , section []
                                            [ p []
                                                [ text "furnish" , span [ class "term" ]
                                                    [ text "Customer Data" ] , text "subject to" 
                                                , span [ class "term" ]
                                                    [ text "Special Data Regulations" ]
                                                ]
                                            ]
                                        , section []
                                            [ p []
                                                [ text "reuse any one set of" , span [ class "term" ]
                                                    [ text "Access Credentials" ] , text "for multiple" 
                                                , span [ class "term" ]
                                                    [ text "Users" ]
                                                ]
                                            ]
                                        , section []
                                            [ p []
                                                [ text "remove proprietary notices from" ,  span [ class "term" ]
                                                    [ text "Software" ] , text "or" 
                                                , span [ class "term" ]
                                                    [ text "Documentation" ]
                                                ]
                                            ]
                                        , section []
                                            [ p []
                                                [ text "use the" , span [ class "term" ]
                                                    [ text "Software" ] , text "for competitive analysis" 
                                                ]
                                            ]
                                        , section []
                                            [ p []
                                                [ text "if the" , span [ class "term" ]
                                                    [ text "Order" ] , text "is for" 
                                                , span [ class "term" ]
                                                    [ text "Hosted Software" ] , text ", strain the technical infrastructure of the" 
                                                , span [ class "term" ]
                                                    [ text "Software" ] , text "with an unreasonable volume of requests, or requests expected to impose an unreasonable load" 
                                                ]
                                            ]
                                        , section []
                                            [ p []
                                                [ text "publish data about the performance of the" , span [ class "term" ]
                                                    [ text "Software" ]
                                                ]
                                            ]
                                        ]
                                    , section []
                                        [ h3 []
                                            [ text "Enforce Rules About Use" ]
                                        , p []
                                            [ span [ class "term" ]
                                                [ text "Customer" ] , text "agrees to make sure" 
                                            , span [ class "term" ]
                                                [ text "Customer Personnel" ] , text "and other personnel abide by" 
                                            , span [ class "reference" ]
                                                [ text "Follow Rules About Use" ] , text "and" 
                                            , span [ class "reference" ]
                                                [ text "Abide by Export Controls" ] , text "." 
                                            ]
                                        ]
                                    , section []
                                        [ h3 []
                                            [ text "Update Account Details" ]
                                        , p []
                                            [ text "While the" , span [ class "term" ]
                                                [ text "Order" ] , text "continues," 
                                            , span [ class "term" ]
                                                [ text "Customer" ] , text "agrees to use the" 
                                            , span [ class "term" ]
                                                [ text "Account Dashboard" ] , text "to keep its contact, payment, and other administrative details complete, accurate, and up-to-date." 
                                            ]
                                        ]
                                    , section []
                                        [ h3 []
                                            [ text "Notify Provider if it Becomes Ineligible for the Package" ]
                                        , p []
                                            [ span [ class "term" ]
                                                [ text "Customer" ] , text "agrees to give" 
                                            , span [ class "term" ]
                                                [ text "Notice" ] , text "if it stops meeting any of the" 
                                            , span [ class "term" ]
                                                [ text "Eligibility Criteria" ] , text "before the" 
                                            , span [ class "term" ]
                                                [ text "Order" ] , text "ends." 
                                            ]
                                        ]
                                    , section []
                                        [ h3 []
                                            [ text "Keep Access Credentials Secret and Secure" ]
                                        , p []
                                            [ span [ class "term" ]
                                                [ text "Customer" ] , text "agrees to make sure" 
                                            , span [ class "term" ]
                                                [ text "Customer Personnel" ] , text "only share" 
                                            , span [ class "term" ]
                                                [ text "Access Credentials" ] , text "as needed to use the" 
                                            , span [ class "term" ]
                                                [ text "Software" ] , text "and services under these terms, and secure" 
                                            , span [ class "term" ]
                                                [ text "Access Credentials" ] , text "at least as well as" 
                                            , span [ class "term" ]
                                                [ text "Customer" ] , text "'" , text "s own confidential information." 
                                            ]
                                        ]
                                    , section []
                                        [ h3 []
                                            [ text "Abide by Export Controls" ]
                                        , p []
                                            [ text "The" , span [ class "term" ]
                                                [ text "Software" ] , text "is subject to United States export restrictions, and may be subject to foreign import restrictions." 
                                            , span [ class "term" ]
                                                [ text "Customer" ] , text "agrees not to break any import or export law by exporting or reexporting the" 
                                            , span [ class "term" ]
                                                [ text "Software" ] , text "." 
                                            ]
                                        ]
                                    , section []
                                        [ h3 []
                                            [ text "Indemnify Provider" ]
                                        , p []
                                            [ text "Subject to" , span [ class "reference" ]
                                                [ text "Indemnification Process" ] , text "," 
                                            , span [ class "term" ]
                                                [ text "Customer" ] , text "agrees to give" 
                                            , span [ class "term" ]
                                                [ text "Provider" ]
                                            , span [ class "term" ]
                                                [ text "Indemnification" ] , text "from" 
                                            , span [ class "term" ]
                                                [ text "Legal Claims" ] , text "by others based on:" 
                                            ]
                                        , section []
                                            [ p []
                                                [ text "breach of these terms" ]
                                            ]
                                        , section []
                                            [ p []
                                                [ span [ class "term" ]
                                                    [ text "Customer Data" ]
                                                ]
                                            ]
                                        , section []
                                            [ p []
                                                [ span [ class "term" ]
                                                    [ text "Use of the Software at Customer" , text "'" , text "s Own Risk" ]
                                                ]
                                            ]
                                        , section []
                                            [ p []
                                                [ text "misuse of" , span [ class "term" ]
                                                    [ text "Customer" ] , text "'" , text "s" 
                                                , span [ class "term" ]
                                                    [ text "Access Credentials" ]
                                                ]
                                            ]
                                        ]
                                    ]
                                , section []
                                    [ h2 []
                                        [ text "Intellectual Property" ]
                                    , section []
                                        [ h3 []
                                            [ text "Copyright License" ]
                                        , p []
                                            [ text "If the" , span [ class "term" ]
                                                [ text "Order" ] , text "is for" 
                                            , span [ class "term" ]
                                                [ text "Licensed Software" ] , text "," 
                                            , span [ class "term" ]
                                                [ text "Provider" ] , text "grants" 
                                            , span [ class "term" ]
                                                [ text "Customer" ] , text "and each of the" 
                                            , span [ class "term" ]
                                                [ text "Users" ] , text "a" 
                                            , span [ class "term" ]
                                                [ text "Standard License" ] , text ", for any copyrights" 
                                            , span [ class "term" ]
                                                [ text "Provider" ] , text "can license, to copy, install, back up, and make" 
                                            , span [ class "term" ]
                                                [ text "Permitted Use of the Software" ] , text "and" 
                                            , span [ class "term" ]
                                                [ text "Documentation" ] , text "." 
                                            ]
                                        ]
                                    , section []
                                        [ h3 []
                                            [ text "Patent License" ]
                                        , p []
                                            [ span [ class "term" ]
                                                [ text "Provider" ] , text "grants" 
                                            , span [ class "term" ]
                                                [ text "Customer" ] , text "and each of the" 
                                            , span [ class "term" ]
                                                [ text "Users" ] , text "a" 
                                            , span [ class "term" ]
                                                [ text "Standard License" ] , text ", for any patents" 
                                            , span [ class "term" ]
                                                [ text "Provider" ] , text "can license, to make" 
                                            , span [ class "term" ]
                                                [ text "Permitted Use of the Software" ] , text "." 
                                            ]
                                        ]
                                    , section []
                                        [ h3 []
                                            [ text "No Other Licenses" ]
                                        , p []
                                            [ text "With the exceptions of the licenses in" , span [ class "reference" ]
                                                [ text "Intellectual Property" ] , text ", these terms do not license or assign any" 
                                            , span [ class "term" ]
                                                [ text "Intellectual Property Right" ] , text "." 
                                            ]
                                        ]
                                    ]
                                , section []
                                    [ h2 []
                                        [ text "Changes" ]
                                    , section []
                                        [ h3 []
                                            [ text "Changes Customer May Make" ]
                                        , p []
                                            [ text "Subject to" , span [ class "reference" ]
                                                [ text "Change Process" ] , text ":" 
                                            ]
                                        , section []
                                            [ p []
                                                [ span [ class "term" ]
                                                    [ text "Customer" ] , text "may end the" 
                                                , span [ class "term" ]
                                                    [ text "Order" ] , text "at any time." 
                                                ]
                                            ]
                                        , section []
                                            [ p []
                                                [ text "If" , span [ class "term" ]
                                                    [ text "Software Pricing" ] , text "and any" 
                                                , span [ class "term" ]
                                                    [ text "Support Pricing" ] , text "can calculate" 
                                                , span [ class "term" ]
                                                    [ text "Fees" ] , text "for different" 
                                                , span [ class "term" ]
                                                    [ text "Use Allowances" ] , text "," 
                                                , span [ class "term" ]
                                                    [ text "Customer" ] , text "may change its" 
                                                , span [ class "term" ]
                                                    [ text "Use Allowances" ] , text "within any" 
                                                , span [ class "term" ]
                                                    [ text "Pricing" ] , text "limits at any time." 
                                                , span [ class "term" ]
                                                    [ text "Customer" ] , text "changes to" 
                                                , span [ class "term" ]
                                                    [ text "Use Allowances" ] , text "take effect as soon as" 
                                                , span [ class "term" ]
                                                    [ text "Customer" ] , text "pays any added" 
                                                , span [ class "term" ]
                                                    [ text "Fees" ] , text "under the" 
                                                , span [ class "term" ]
                                                    [ text "Pricing" ] , text "." 
                                                ]
                                            ]
                                        ]
                                    , section []
                                        [ h3 []
                                            [ text "Changes Provider May Make" ]
                                        , p []
                                            [ text "Subject to" , span [ class "reference" ]
                                                [ text "Change Process" ] , text ":" 
                                            ]
                                        , section []
                                            [ p []
                                                [ span [ class "term" ]
                                                    [ text "Provider" ] , text "may end the" 
                                                , span [ class "term" ]
                                                    [ text "Order" ] , text "whenever" 
                                                , span [ class "term" ]
                                                    [ text "Pricing" ] , text "does not require" 
                                                , span [ class "term" ]
                                                    [ text "Customer" ] , text "to pay any amount of" 
                                                , span [ class "term" ]
                                                    [ text "Software Fees" ] , text "." 
                                                ]
                                            ]
                                        , section []
                                            [ p []
                                                [ span [ class "term" ]
                                                    [ text "Provider" ] , text "may end the" 
                                                , span [ class "term" ]
                                                    [ text "Order" ] , text "if" 
                                                , span [ class "term" ]
                                                    [ text "Customer" ] , text "stops meeting any of the" 
                                                , span [ class "term" ]
                                                    [ text "Eligibility Criteria" ] , text "." 
                                                ]
                                            ]
                                        , section []
                                            [ p []
                                                [ span [ class "term" ]
                                                    [ text "Provider" ] , text "may end the" 
                                                , span [ class "term" ]
                                                    [ text "Order" ] , text "at the end of any" 
                                                , span [ class "term" ]
                                                    [ text "Commitment Period" ] , text "by giving" 
                                                , span [ class "term" ]
                                                    [ text "Notice" ] , text "at least one" 
                                                , span [ class "term" ]
                                                    [ text "Billing Cycle" ] , text "in advance." 
                                                ]
                                            ]
                                        , section []
                                            [ p []
                                                [ span [ class "term" ]
                                                    [ text "Provider" ] , text "may end the" 
                                                , span [ class "term" ]
                                                    [ text "Order" ] , text "immediately if" 
                                                , span [ class "term" ]
                                                    [ text "Customer" ] , text "breaches these terms." 
                                                ]
                                            ]
                                        , section []
                                            [ p []
                                                [ span [ class "term" ]
                                                    [ text "Provider" ] , text "may add, remove, and change" 
                                                , span [ class "term" ]
                                                    [ text "Software Features" ] , text "in the" 
                                                , span [ class "term" ]
                                                    [ text "Latest Version of the Software" ] , text "." 
                                                ]
                                            ]
                                        , section []
                                            [ p []
                                                [ span [ class "term" ]
                                                    [ text "Provider" ] , text "may add, remove, and change the functionality of the" 
                                                , span [ class "term" ]
                                                    [ text "Account Dashboard" ] , text "and" 
                                                , span [ class "term" ]
                                                    [ text "Documentation" ] , text "." 
                                                ]
                                            ]
                                        , section []
                                            [ p []
                                                [ span [ class "term" ]
                                                    [ text "Provider" ] , text "may make changes under" 
                                                , span [ class "reference" ]
                                                    [ text "Address Legal Problems" ] , text "." 
                                                ]
                                            ]
                                        ]
                                    , section []
                                        [ h3 []
                                            [ text "Renewal" ]
                                        , p []
                                            [ text "The" , span [ class "term" ]
                                                [ text "Order" ] , text "will automatically renew for another" 
                                            , span [ class "term" ]
                                                [ text "Commitment Period" ] , text "when the prior" 
                                            , span [ class "term" ]
                                                [ text "Commitment Period" ] , text "ends. Either side may stop the" 
                                            , span [ class "term" ]
                                                [ text "Order" ] , text "from renewing by ending it before it renews." 
                                            ]
                                        ]
                                    ]
                                , section []
                                    [ h2 []
                                        [ text "Liability" ]
                                    , section []
                                        [ h3 []
                                            [ text "Agreed Legal Remedies" ]
                                        , section []
                                            [ p []
                                                [ text "Each side" , text "'" , text "s only legal remedy for" , span [ class "term" ]
                                                    [ text "Legal Claims" ] , text "covered by" 
                                                , span [ class "term" ]
                                                    [ text "Indemnification" ] , text "will be" 
                                                , span [ class "term" ]
                                                    [ text "Indemnification" ] , text "." 
                                                ]
                                            ]
                                        , section []
                                            [ p []
                                                [ span [ class "term" ]
                                                    [ text "Customer" ] , text "'" , text "s only legal remedy for failures to meet any" 
                                                , span [ class "term" ]
                                                    [ text "Service-Level Agreement" ] , text "will be credits under" 
                                                , span [ class "reference" ]
                                                    [ text "Give Credits for Bad Service" ] , text "." 
                                                ]
                                            ]
                                        , section []
                                            [ p []
                                                [ span [ class "term" ]
                                                    [ text "Customer" ] , text "'" , text "s only legal remedy for changes to" 
                                                , span [ class "term" ]
                                                    [ text "Software Features" ] , text "in the" 
                                                , span [ class "term" ]
                                                    [ text "Latest Version of the Software" ] , text "will be refunds under" 
                                                , span [ class "reference" ]
                                                    [ text "Refund Prepaid Fees for Removed Features" ] , text "." 
                                                ]
                                            ]
                                        ]
                                    , section []
                                        [ h3 []
                                            [ text "Valid Excuses" ]
                                        , p []
                                            [ text "Neither side will be liable for any failure or delay in meeting any obligation under these terms caused by a" , span [ class "term" ]
                                                [ text "Disaster" ] , text ", failure of the other side or its personnel to meet their obligations under these terms, or actions done or delayed on written request of the other side." 
                                            ]
                                        ]
                                    , section [ class "conspicuous" ]
                                        [ h3 []
                                            [ text "Only Express Warranties" ]
                                        , p []
                                            [ text "With the exception of its obligations in" , span [ class "reference" ]
                                                [ text "Provider" , text "'" , text "s Obligations" ] , text "," 
                                            , span [ class "term" ]
                                                [ text "Provider" ] , text "provides the" 
                                            , span [ class "term" ]
                                                [ text "Software" ] , text "\"" , text "as is" , text "\"" , text ", without express or implied warranties about the quality of the" 
                                            , span [ class "term" ]
                                                [ text "Software" ] , text ", the security or correct operation of any" 
                                            , span [ class "term" ]
                                                [ text "Hosted Software" ] , text ", or the quality of any services." 
                                            , span [ class "term" ]
                                                [ text "Provider" ] , text "disclaims any warranties the law might otherwise imply, like warranties of merchantability, fitness for any particular purpose, title, or noninfringement." 
                                            ]
                                        ]
                                    , section [ class "conspicuous" ]
                                        [ h3 []
                                            [ text "Limited Damages" ]
                                        , section [ class "conspicuous" ]
                                            [ p []
                                                [ text "Subject to" , span [ class "reference" ]
                                                    [ text "Damages Limit Exceptions" ] , text ", neither side" , text "'"  , text "s total liability for breach of these terms will exceed the amount of" 
                                                , span [ class "term" ]
                                                    [ text "Fees" ]
                                                , span [ class "term" ]
                                                    [ text "Provider" ] , text "received from" 
                                                , span [ class "term" ]
                                                    [ text "Customer" ] , text "during the twelve months before the first claim is filed. This limit applies even if the one liable is advised that the other may suffer damages, and even if" 
                                                , span [ class "term" ]
                                                    [ text "Customer" ] , text "paid no fees at all." 
                                                ]
                                            ]
                                        , section [ class "conspicuous" ]
                                            [ p []
                                                [ text "Subject to" , span [ class "reference" ]
                                                    [ text "Damages Limit Exceptions" ] , text ", neither side will be liable for breach-of-contract damages they could not have reasonably foreseen when agreeing to these terms." 
                                                ]
                                            ]
                                        , section []
                                            [ h4 []
                                                [ text "Damages Limit Exceptions" ]
                                            , p []
                                                [ span [ class "reference" ]
                                                    [ text "Limited Damages" ] , text "does not limit damages for breach of:" 
                                                ]
                                            , section []
                                                [ p []
                                                    [ span [ class "reference" ]
                                                        [ text "Pay Fees" ]
                                                    ]
                                                ]
                                            , section []
                                                [ p []
                                                    [ span [ class "reference" ]
                                                        [ text "Keep Customer Data Confidential" ]
                                                    ]
                                                ]
                                            , section []
                                                [ p []
                                                    [ span [ class "reference" ]
                                                        [ text "Follow Rules About Use" ]
                                                    ]
                                                ]
                                            , section []
                                                [ p []
                                                    [ span [ class "reference" ]
                                                        [ text "Enforce Rules About Use" ]
                                                    ]
                                                ]
                                            , section []
                                                [ p []
                                                    [ span [ class "reference" ]
                                                        [ text "Provide Assurance about Patents" ]
                                                    ]
                                                ]
                                            , section []
                                                [ p []
                                                    [ span [ class "reference" ]
                                                        [ text "Abide by Export Controls" ]
                                                    ]
                                                ]
                                            , section []
                                                [ p []
                                                    [ span [ class "reference" ]
                                                        [ text "Indemnify Customer" ]
                                                    ]
                                                ]
                                            , section []
                                                [ p []
                                                    [ span [ class "reference" ]
                                                        [ text "Indemnify Provider" ]
                                                    ]
                                                ]
                                            ]
                                        ]
                                    ]
                                , section []
                                    [ h2 []
                                        [ text "Process" ]
                                    , section []
                                        [ h3 []
                                            [ text "Indemnification Process" ]
                                        , p []
                                            [ text "Both sides agree that to receive" , span [ class "term" ]
                                                [ text "Indemnification" ] , text "under these terms, they must give" 
                                            , span [ class "term" ]
                                                [ text "Notice" ] , text "of any covered" 
                                            , span [ class "term" ]
                                                [ text "Legal Claims" ] , text "quickly, allow the other side to control investigation, defense, and settlement, and cooperate with those efforts. Both sides agree that if they fail to give" 
                                            , span [ class "term" ]
                                                [ text "Notice" ] , text "of any covered" 
                                            , span [ class "term" ]
                                                [ text "Legal Claims" ] , text "quickly," 
                                            , span [ class "term" ]
                                                [ text "Indemnification" ] , text "will not cover amounts that could have been defended against or mitigated if" 
                                            , span [ class "term" ]
                                                [ text "Notice" ] , text "had been given quickly. Both sides agree that if they take control of the defense and settlement of any" 
                                            , span [ class "term" ]
                                                [ text "Legal Claims" ] , text "covered by" 
                                            , span [ class "term" ]
                                                [ text "Indemnification" ] , text ", they will not agree to any settlements that admit fault or impose obligations on the other side without their" 
                                            , span [ class "term" ]
                                                [ text "Permission" ] , text "." 
                                            ]
                                        ]
                                    , section []
                                        [ h3 []
                                            [ text "Notice Process" ]
                                        , p []
                                            [ text "Both sides agree that to give" , span [ class "term" ]
                                                [ text "Notice" ] , text "under these terms, the side giving" 
                                            , span [ class "term" ]
                                                [ text "Notice" ] , text "must send by e-mail to the address the recipient given with its signature, or to a different address given later for" 
                                            , span [ class "term" ]
                                                [ text "Notice" ] , text "going forward. If either side finds that e-mail can" , text "'" , text "t be delivered to the e-mail address given, it may give" 
                                            , span [ class "term" ]
                                                [ text "Notice" ] , text "by registered mail to the address on file for the recipient with the state under whose laws it is organized." 
                                            ]
                                        ]
                                    , section []
                                        [ h3 []
                                            [ text "Change Process" ]
                                        , p []
                                            [ span [ class "term" ]
                                                [ text "Customer" ] , text "agrees to make changes to the" 
                                            , span [ class "term" ]
                                                [ text "Order" ] , text "through the" 
                                            , span [ class "term" ]
                                                [ text "Account Dashboard" ] , text "whenever possible. If the" 
                                            , span [ class "term" ]
                                                [ text "Account Dashboard" ] , text "does not provide a user interface for making a particular change, or the" 
                                            , span [ class "term" ]
                                                [ text "Account Dashboard" ] , text "is not available or malfunctions," 
                                            , span [ class "term" ]
                                                [ text "Customer" ] , text "may make its change by" 
                                            , span [ class "term" ]
                                                [ text "Notice" ] , text "to" 
                                            , span [ class "term" ]
                                                [ text "Provider" ] , text "." 
                                            , span [ class "term" ]
                                                [ text "Provider" ] , text "agrees to make changes to the" 
                                            , span [ class "term" ]
                                                [ text "Order" ] , text "by" 
                                            , span [ class "term" ]
                                                [ text "Notice" ] , text "." 
                                            ]
                                        ]
                                    ]
                                , section []
                                    [ h2 []
                                        [ text "General Contract Terms" ]
                                    , section []
                                        [ h3 []
                                            [ text "Governing Law" ]
                                        , p []
                                            [ text "The law of the state of" , span [ class "term" ]
                                                [ text "Provider" , text "'" , text "s Main Office" ] , text "will govern these terms." 
                                            ]
                                        ]
                                    , section []
                                        [ h3 []
                                            [ text "No CCSG" ]
                                        , p []
                                            [ text "The United Nations Convention on Contracts for the Sale of Goods will not apply to these terms." ]
                                        ]
                                    , section []
                                        [ h3 []
                                            [ text "No UCITA" ]
                                        , p []
                                            [ text "The Uniform Computer Information Transactions Act will not apply to these terms." ]
                                        ]
                                    , section []
                                        [ h3 []
                                            [ text "Government Procurement" ]
                                        , p []
                                            [ text "The" , span [ class "term" ]
                                                [ text "Software" ] , text "is commercial computer software, and the" 
                                            , span [ class "term" ]
                                                [ text "Documentation" ] , text "is commercial computer software documentation. Both" 
                                            , span [ class "term" ]
                                                [ text "Software" ] , text "and the" 
                                            , span [ class "term" ]
                                                [ text "Documentation" ] , text "were developed exclusively at private expense. If" 
                                            , span [ class "term" ]
                                                [ text "Customer" ] , text "'" , text "s procurement of the" 
                                            , span [ class "term" ]
                                                [ text "Software" ] , text "and" 
                                            , span [ class "term" ]
                                                [ text "Documentation" ] , text "is subject to Federal Acquisition Regulation 12.212 or Defense Federal Acquisition Regulation Supplement 227.7202," 
                                            , span [ class "term" ]
                                                [ text "Customer" ] , text "'" , text "s rights in the" 
                                            , span [ class "term" ]
                                                [ text "Software" ] , text "and" 
                                            , span [ class "term" ]
                                                [ text "Documentation" ] , text "will be only those stated in the" 
                                            , span [ class "term" ]
                                                [ text "Order" ] , text "and these terms." 
                                            ]
                                        ]
                                    , section []
                                        [ h3 []
                                            [ text "Whole Agreement" ]
                                        , p []
                                            [ text "Both sides intend the" , span [ class "term" ]
                                                [ text "Order" ] , text "and these terms as the final, complete, and only expression of their terms about use of the" 
                                            , span [ class "term" ]
                                                [ text "Software" ] , text "and related support services. However, these terms do not affect the terms of any separate nondisclosure or confidentiality agreement" 
                                            , span [ class "term" ]
                                                [ text "Provider" ] , text "and" 
                                            , span [ class "term" ]
                                                [ text "Customer" ] , text "may have." 
                                            ]
                                        ]
                                    , section []
                                        [ h3 []
                                            [ text "Enforcement" ]
                                        , p []
                                            [ text "Only" , span [ class "term" ]
                                                [ text "Provider" ] , text "and" 
                                            , span [ class "term" ]
                                                [ text "Customer" ] , text "may enforce these terms." 
                                            ]
                                        ]
                                    , section []
                                        [ h3 []
                                            [ text "Assignment" ]
                                        , p []
                                            [ text "Each side may assign all its rights, licenses, and obligations under these terms, as a whole, to a new legal entity created to change its jurisdiction or legal form of organization, or to an entity that acquires substantially all of its assets or enough securities to control its management. Otherwise, each side needs" , span [ class "term" ]
                                                [ text "Permission" ] , text "to assign any right or license under these terms. Attempts to assign against these terms will have no legal effect." 
                                            ]
                                        ]
                                    , section []
                                        [ h3 []
                                            [ text "Lawsuits" ]
                                        , section []
                                            [ h4 []
                                                [ text "Forum" ]
                                            , p []
                                                [ text "Both sides agree to bring any" , span [ class "term" ]
                                                    [ text "Lawsuit" ] , text "in" 
                                                , span [ class "term" ]
                                                    [ text "Provider" , text "'" , text "s Local Courts" ] , text "." 
                                                ]
                                            ]
                                        , section []
                                            [ h4 []
                                                [ text "Exclusive Jurisdiction" ]
                                            , p []
                                                [ text "Both sides consent to the exclusive jurisdiction of" , span [ class "term" ]
                                                    [ text "Provider" , text "'" , text "s Local Courts" ] , text ". Both sides may enforce judgments from" 
                                                , span [ class "term" ]
                                                    [ text "Provider" , text "'" , text "s Local Courts" ] , text "in other jurisdictions." 
                                                ]
                                            ]
                                        , section []
                                            [ h4 []
                                                [ text "Inconvenient Forum Waiver" ]
                                            , p []
                                                [ text "Both sides waive any objection to venue for any" , span [ class "term" ]
                                                    [ text "Lawsuit" ] , text "in" 
                                                , span [ class "term" ]
                                                    [ text "Provider" , text "'" , text "s Local Courts" ] , text "and any claim that the other brought any" 
                                                , span [ class "term" ]
                                                    [ text "Lawsuit" ] , text "in" 
                                                , span [ class "term" ]
                                                    [ text "Provider" , text "'" , text "s Local Courts" ] , text "in an inconvenient forum." 
                                                ]
                                            ]
                                        ]
                                    ]
                                , section []
                                    [ h2 []
                                        [ text "Definitions" ]
                                    , section []
                                        [ p []
                                            [ dfn []
                                                [ text "Access Credentials" ] , text "means a user name and password, license key, or other secret that affords use of the" 
                                            , span [ class "term" ]
                                                [ text "Software" ] , text "." 
                                            ]
                                        ]
                                    , section []
                                        [ p []
                                            [ dfn []
                                                [ text "Business Days" ] , text "means days other than Saturdays, Sundays, and days when commercial banks in the capital of the state of" 
                                            , span [ class "term" ]
                                                [ text "Provider" , text "'" , text "s Main Office" ] , text "typically stay closed." 
                                            ]
                                        ]
                                    , section []
                                        [ p []
                                            [ dfn []
                                                [ text "Concurrent Users" ] , text "means the number of" 
                                            , span [ class "term" ]
                                                [ text "Users" ] , text "logged into or using the" 
                                            , span [ class "term" ]
                                                [ text "Software" ] , text "at any given time." 
                                            ]
                                        ]
                                    , section []
                                        [ p []
                                            [ dfn []
                                                [ text "Customer Data" ] , text "means data that:" 
                                            ]
                                        , section []
                                            [ p []
                                                [ span [ class "term" ]
                                                    [ text "Users" ] , text "furnish to the" 
                                                , span [ class "term" ]
                                                    [ text "Software" ] , text ", such as by entering it or configuring the" 
                                                , span [ class "term" ]
                                                    [ text "Software" ] , text "to gather or receive it, if doing so doesn" , text "'" , text "t breach these terms" 
                                                ]
                                            ]
                                        , section []
                                            [ p []
                                                [ text "the" , span [ class "term" ]
                                                    [ text "Software" ] , text "collects about" 
                                                , span [ class "term" ]
                                                    [ text "Users" ] , text "and how they use the" 
                                                , span [ class "term" ]
                                                    [ text "Software" ]
                                                ]
                                            ]
                                        ]
                                    , section []
                                        [ p []
                                            [ dfn []
                                                [ text "Customer Personnel" ] , text "means" 
                                            , span [ class "term" ]
                                                [ text "Customer" ] , text "'" , text "s employees and each" 
                                            , span [ class "term" ]
                                                [ text "Customer" ] , text "subsidiary" , text "'" , text "s employees, as well as independent contractors providing services to" 
                                            , span [ class "term" ]
                                                [ text "Customer" ] , text "." 
                                            ]
                                        ]
                                    , section []
                                        [ p []
                                            [ dfn []
                                                [ text "Customer Systems" ] , text "means computer programs run by" 
                                            , span [ class "term" ]
                                                [ text "Customer" ] , text "or by independent contractors for" 
                                            , span [ class "term" ]
                                                [ text "Customer" ] , text "." 
                                            ]
                                        ]
                                    , section []
                                        [ p []
                                            [ dfn []
                                                [ text "Software Dependencies" ] , text "means software from others that the" 
                                            , span [ class "term" ]
                                                [ text "Software" ] , text "depends on, installs, configures, or links, directly or indirectly, to provide the" 
                                            , span [ class "term" ]
                                                [ text "Feature Set" ] , text "." 
                                            ]
                                        ]
                                    , section []
                                        [ p []
                                            [ dfn []
                                                [ text "Disaster" ] , text "means:" 
                                            ]
                                        , section []
                                            [ p []
                                                [ text "fire, flood, earthquake, and other natural disasters" ]
                                            ]
                                        , section []
                                            [ p []
                                                [ text "declared and undeclared wars, acts of terrorism, sabotage, riots, civil disorders, rebellions, and revolutions" ]
                                            ]
                                        , section []
                                            [ p []
                                                [ text "extraordinary malfunction of Internet infrastructure, data centers, or communications utilities" ]
                                            ]
                                        , section []
                                            [ p []
                                                [ text "government actions taken in response to any of these causes" ]
                                            ]
                                        ]
                                    , section []
                                        [ p []
                                            [ dfn []
                                                [ text "Fees" ] , text "means" 
                                            , span [ class "term" ]
                                                [ text "Software Fees" ] , text "and" 
                                            , span [ class "term" ]
                                                [ text "Support Fees" ] , text "." 
                                            ]
                                        ]
                                    , section []
                                        [ p []
                                            [ dfn []
                                                [ text "Indemnification" ] , text "means indemnifying and holding harmless for all liability, expenses, damages, and costs." 
                                            ]
                                        ]
                                    , section []
                                        [ p []
                                            [ dfn []
                                                [ text "Intellectual Property Right" ] , text "means any patent, copyright, trademark, or trade secret right, or any other legal right typically referred to as an intellectual property right." 
                                            ]
                                        ]
                                    , section []
                                        [ p []
                                            [ dfn []
                                                [ text "Latest Version of the Software" ] , text "means the most recent version of the" 
                                            , span [ class "term" ]
                                                [ text "Software" ] , text "that" 
                                            , span [ class "term" ]
                                                [ text "Provider" ] , text "publicly promotes for use in production, rather than test or development, systems." 
                                            ]
                                        ]
                                    , section []
                                        [ p []
                                            [ dfn []
                                                [ text "Lawsuit" ] , text "means a lawsuit brought by one side against the other, related to these terms or the" 
                                            , span [ class "term" ]
                                                [ text "Software" ] , text "." 
                                            ]
                                        ]
                                    , section []
                                        [ p []
                                            [ dfn []
                                                [ text "Legal Claims" ] , text "means claims, demands, lawsuits, and other legal actions." 
                                            ]
                                        ]
                                    , section []
                                        [ p []
                                            [ dfn []
                                                [ text "Notice" ] , text "means a written communication from one side to the other per" 
                                            , span [ class "reference" ]
                                                [ text "Notice Process" ] , text "." 
                                            ]
                                        ]
                                    , section []
                                        [ p []
                                            [ dfn []
                                                [ text "Permission" ] , text "means prior" 
                                            , span [ class "term" ]
                                                [ text "Notice" ] , text "of consent." 
                                            ]
                                        ]
                                    , section []
                                        [ p []
                                            [ dfn []
                                                [ text "Permitted Use of the Software" ] , text "means" 
                                            , span [ class "term" ]
                                                [ text "Customer" ] , text "'" , text "s use of the" 
                                            , span [ class "term" ]
                                                [ text "Software" ] , text ", other than" 
                                            , span [ class "term" ]
                                                [ text "Use of the Software at Customer" , text "'" , text "s Own Risk" ] ,text "." 
                                            ]
                                        ]
                                    , section []
                                        [ p []
                                            [ dfn []
                                                [ text "Prepaid Fees" ] , text "means" 
                                            , span [ class "term" ]
                                                [ text "Fees" ]
                                            , span [ class "term" ]
                                                [ text "Customer" ] , text "prepaid for time remaining in the current" 
                                            , span [ class "term" ]
                                                [ text "Billing Cycle" ] , text "." 
                                            ]
                                        ]
                                    , section []
                                        [ p []
                                            [ dfn []
                                                [ text "Pricing" ] , text "means" 
                                            , span [ class "term" ]
                                                [ text "Software Pricing" ] , text "and any" 
                                            , span [ class "term" ]
                                                [ text "Support Pricing" ] , text "." 
                                            ]
                                        ]
                                    , section []
                                        [ p []
                                            [ dfn []
                                                [ text "Provider" , text "'" , text "s Local Courts" ] , text "means the state and federal courts with jurisdiction at" 
                                            , span [ class "term" ]
                                                [ text "Provider" , text "'" , text "s Main Office" ] , text "." 
                                            ]
                                        ]
                                    , section []
                                        [ p []
                                            [ dfn []
                                                [ text "Provider" , text "'" , text "s Main Office" ] , text "means" 
                                            , span [ class "term" ]
                                                [ text "Provider" ] , text "'" , text "s office where its most senior executive officer is based on the date of this agreement. If" 
                                            , span [ class "term" ]
                                                [ text "Provider" ] , text "does not have an office," 
                                            , span [ class "term" ]
                                                [ text "Provider" , text "'" , text "s Main Office" ] , text "is the capital of the state under whose laws" 
                                            , span [ class "term" ]
                                                [ text "Provider" ] , text "is organized." 
                                            ]
                                        ]
                                    , section []
                                        [ p []
                                            [ dfn []
                                                [ text "Publicly Licensed" ] , text "means published with a notice of a license to the public, or to everyone who receives a copy." 
                                            ]
                                        ]
                                    , section []
                                        [ p []
                                            [ dfn []
                                                [ text "Public Software Repository" ] , text "means an website or Internet service that provides free-of-charge downloads of" 
                                            , span [ class "term" ]
                                                [ text "Publicly Licensed" ]
                                            , span [ class "term" ]
                                                [ text "Software" ] , text "." 
                                            ]
                                        ]
                                    , section []
                                        [ p []
                                            [ dfn []
                                                [ text "Running Instances" ] , text "means the number of copies of the" 
                                            , span [ class "term" ]
                                                [ text "Software" ]
                                            , span [ class "term" ]
                                                [ text "Customer" ] , text "runs at any given time." 
                                            ]
                                        ]
                                    , section []
                                        [ p []
                                            [ dfn []
                                                [ text "Service-Level Agreement" ] , text "means a" 
                                            , span [ class "term" ]
                                                [ text "Provider" ] , text "commitment to meet specific, measurable standards in providing a service, such as an uptime percentage for" 
                                            , span [ class "term" ]
                                                [ text "Hosted Software" ] , text "or a mean time of response to" 
                                            , span [ class "term" ]
                                                [ text "Support Requests" ] , text "." 
                                            ]
                                        ]
                                    , section []
                                        [ p []
                                            [ dfn []
                                                [ text "Software Features" ] , text "means functions of the" 
                                            , span [ class "term" ]
                                                [ text "Software" ] , text "described in the" 
                                            , span [ class "term" ]
                                                [ text "Documentation" ] , text "." 
                                            ]
                                        ]
                                    , section []
                                        [ p []
                                            [ dfn []
                                                [ text "Special Data Regulations" ] , text "means laws and regulations that impose special requirements on the collection, storage, processing, or transmission of particular kinds of data about individuals. The Gramm-Leach-Bliley Act, Health Insurance Portability and Accountability Act, Children" , text "'" , text "s Online Privacy Protection Act, and Fair Credit Reporting Act are some" 
                                            , span [ class "term" ]
                                                [ text "Special Data Regulations" ] , text ". Laws that apply to data just because they may identify specific individuals are not" 
                                            , span [ class "term" ]
                                                [ text "Special Data Regulations" ] , text "." 
                                            ]
                                        ]
                                    , section []
                                        [ p []
                                            [ dfn []
                                                [ text "Standard License" ] , text "means a nonexclusive license while the" 
                                            , span [ class "term" ]
                                                [ text "Order" ] , text "continues that is conditional on payment of all" 
                                            , span [ class "term" ]
                                                [ text "Software Fees" ] , text "as required by these terms and limited by the" 
                                            , span [ class "term" ]
                                                [ text "Use Allowances" ] , text "." 
                                            ]
                                        ]
                                    , section []
                                        [ p []
                                            [ dfn []
                                                [ text "Support Requests" ] , text "means questions and requests for help concerning the" 
                                            , span [ class "term" ]
                                                [ text "Software" ] , text "from" 
                                            , span [ class "term" ]
                                                [ text "Customer Personnel" ] , text "." 
                                            ]
                                        ]
                                    , section []
                                        [ p []
                                            [ dfn []
                                                [ text "Use of the Software at Customer" , text "'" , text "s Own Risk" ] , text "means:" 
                                            ]
                                        , section []
                                            [ p []
                                                [ text "use of the" , span [ class "term" ]
                                                    [ text "Software" ] , text "in breach of these terms" 
                                                ]
                                            ]
                                        , section []
                                            [ p []
                                                [ text "use of the" , span [ class "term" ]
                                                    [ text "Software" ] , text "with changes, additions, or in combination with other software, computers, or data, in a way that infringes someone else" , text "'" , text "s" 
                                                , span [ class "term" ]
                                                    [ text "Intellectual Property Right" ] , text "or breaks the law, if use of the" 
                                                , span [ class "term" ]
                                                    [ text "Software" ] , text "as provided, as described by the" 
                                                , span [ class "term" ]
                                                    [ text "Documentation" ] , text ", would not" 
                                                ]
                                            ]
                                        , section []
                                            [ p []
                                                [ text "use of other than the" , span [ class "term" ]
                                                    [ text "Latest Version of the Software" ] , text "that infringes someone else" , text "'" , text "s" 
                                                , span [ class "term" ]
                                                    [ text "Intellectual Property Right" ] , text "or breaks the law, if" 
                                                , span [ class "term" ]
                                                    [ text "Customer" ] , text "had" 
                                                , span [ class "term" ]
                                                    [ text "Notice" ] , text "that using the" 
                                                , span [ class "term" ]
                                                    [ text "Latest Version of the Software" ] , text "would not" 
                                                ]
                                            ]
                                        , section []
                                            [ p []
                                                [ text "unauthorized use of the" , span [ class "term" ]
                                                    [ text "Software" ] , text "with" 
                                                , span [ class "term" ]
                                                    [ text "Customer" ]
                                                , span [ class "term" ]
                                                    [ text "Access Credentials" ]
                                                ]
                                            ]
                                        ]
                                    , section []
                                        [ p []
                                            [ dfn []
                                                [ text "User Accounts" ] , text "means the number of" 
                                            , span [ class "term" ]
                                                [ text "Users" ] , text "with" 
                                            , span [ class "term" ]
                                                [ text "Access Credentials" ] , text ", not counting any administrative" 
                                            , span [ class "term" ]
                                                [ text "Access Credentials" ] , text "." 
                                            ]
                                        ]
                                    , section []
                                        [ p []
                                            [ dfn []
                                                [ text "Users" ] , text "means" 
                                            , span [ class "term" ]
                                                [ text "Customer Personnel" ] , text "using the" 
                                            , span [ class "term" ]
                                                [ text "Software" ] , text "and" 
                                            , span [ class "term" ]
                                                [ text "Customer Systems" ] , text "using the" 
                                            , span [ class "term" ]
                                                [ text "Software" ] , text "." 
                                            ]
                                        ]
                                    ]
                                ]
                            ] 
                            ]
                            ]
                    ]
                ]
        , div [ class "text-center bg-light", id "footer-container" ]
            [ img [ class "", id "footer-image", alt "Wireframe graphic of compliance and risk dashboard Haven GRC", src "/img/footer_lines@2x.png" ]
                []
            , footer [ class "bg-primary py-4" ]
                [ div [ class "text-white" ]
                    [ span []
                        [ text "© 2018 "
                        , a [ class "text-white underline", href "https://kindlyops.com", title "Kindly Ops Website" ]
                            [ text "KINDLY OPS" ]
                        ]
                    ]
                ]
            ]
        ]