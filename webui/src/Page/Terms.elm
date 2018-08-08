module Page.Terms exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Markdown exposing (..)


viewTerms : Html msg
viewTerms =
    Markdown.toHtml [ class "terms" ] """

**first edition, second update**

**Provider** and **Customer** agree:

1. _Software_.

    (a) The **Software** is Haven GRC, for tamper proof evidence storage, security culture metrics, and risk dashboard.

    (b) The **Website** is at https://havengrc.com/.

    (c) The **Account Dashboard** is at https://account.havengrc.com/.

    (d) The **Documentation** is at https://docs.havengrc.com/.

2. _Order_.

    (a) These terms, together with the specifics of the accompanying Order, govern Customer&#39;s use of the Software. The **Order** is either:

    (i) the order Customer submitted through the Account Dashboard, for a Product Package that Provider offered through the Account Dashboard

    (ii) the purchase order Customer sent Provider, for a Product Package that Provider quoted to Customer

    (b) A **Product Package** is an offer of specific **Deal Terms** from Provider:

    (i) Hosted Software or Licensed Software

    (ii) a **Feature Set** of Software Features

    (iii)  **Use Allowances** : numeric limits on use of the Software, such as &quot;ten User Accounts&quot;, &quot;two Running Instances&quot;, or &quot;twenty Concurrent Users&quot;

    (iv)  **Software Pricing** : a way to calculate **Software Fees** , such as a flat amount for a set number of User Accounts, an amount based on the number of Running Instances, or a free trial followed by a flat monthly fee

    (v) a **Commitment Period** : the recurring period of time, starting on the Order date, when Provider commits to the Deal Terms, such as each month, each quarter, or each year

    (vi) a **Payment Method** such as automatic credit card charges or invoices paid by wire transfer

    (vii) a **Billing Cycle** such as monthly or annually, on which Customer will pay for use of the Software

    (viii) if the Product Package is for Hosted Software, any Service-Level Agreement for the Website

    (ix) if the Product Package includes support services:

    (A)  **Support Terms** setting how and when Provider will respond to Support Requests

    (B)  **Support Pricing** : a way to calculate **Support Fees**

    (C) any Service-Level Agreement for response to Support Requests

    (x) any **Eligibility Criteria** that Customer must meet to order the Product Package, such as 501(c)(3) tax-exempt status

    (c) _Custom Deal Terms_. A Product Package may allow Customer to choose particular Deal Terms for itself, such as Use Allowances numbers or Payment Method. Customer&#39;s choices on entering this agreement are also part of the Order.

    (d) _Default Deal Terms_.

    (i) If a Product Package doesn&#39;t mention a currency for Software Pricing or Support Pricing, the currency is United States Dollars.

    (ii) If a Product Package doesn&#39;t mention a Feature Set, the Feature Set is all Software Features described in the Documentation on the Order date.

    (iii) If a Product Package offers a Payment Method that Provider must start by billing Customer, but does not mention payment terms, payments are due within thirty calendar days of receiving each bill, with late-payment interest of 1.5%, compounded monthly.

    (iv) If a Product Package includes support services, but doesn&#39;t say when Provider will respond to Support Requests, Provider will respond on Business Days from 8:30 AM to 6:30 PM in the time zone of Provider&#39;s Main Office.

3. _Provider&#39;s Obligations_.

    (a) _Provide the Software_.

    (i) _Hosted_. If the Order is for **Hosted Software** :

    (A) _Run the Software_. While the Order continues, Provider agrees to run the Software so that Customer Personnel can use the Feature Set by visiting the Website with computers and software that meet any requirements set out in the current Documentation.

    (B) _Send Access Credentials_. Provider agrees to send Customer a set of administrative Access Credentials for the Software on entering into this agreement. While the Order continues, Provider agrees to send Customer a new set of administrative Access Credentials on request.

    (C) _Keep Customer Data Confidential_. Provider agrees not to access, use, or disclose Customer Data without Permission, except:

    (I) as needed to provide the Software

    (II) to monitor use of the Software to prevent, detect, and mitigate breach of these terms

    (III) to respond to Support Requests

    (D) _Take Security Precautions_. Provider agrees to take industry-standard security precautions to keep Customer Data that it has secure from inadvertent publication, leak, and hacker attack. Provider does not agree to make sure Customer Data is completely free of software bugs or configuration errors affecting security, or completely secure from all possible hacker attacks.

    (E) _Prepare for Disasters_. While the Order continues, Provider agrees to:

    (I) adopt, maintain, and periodically review a written plan to recover from any Disaster affecting the computers used to provide the Software or the integrity of Customer Data

    (II) share the plan with relevant Provider personnel

    (III) give Customer a copy of the current plan on request

    (IV) follow the plan if a Disaster happens

    (F) _Use Responsible Subcontractors_. Provider agrees to make sure its employees and contractors abide by _Section 3(a)(i)(C) (Keep Customer Data Confidential)_, _Section 3(a)(i)(D) (Take Security Precautions)_, _Section 3(a)(i)(E) (Prepare for Disasters)_, and _Section 3(g) (Keep Malicious Code Out of the Software)_. Provider may contract with others to provide computers and software services used to provide the Software to Customer.

    (ii) _Licensed_. If the Order is for **Licensed Software** :

    (A) _Provide a Download_. While the Order continues, Provider agrees to make the Latest Version of the Software supporting the Feature Set available for Customer to download through the Account Dashboard.

    (B) _Document Installation and Configuration_. While the Order continues, Provider agrees to make sure the Documentation has instructions that enable a system administrator experienced with a supported operating system to install, configure, and run the Latest Version of the Software.

    (C) _Make Sure Customer Can Download Software Dependencies_. While the Order continues, Provider agrees to make sure any Software Dependencies not included in the download of the Latest Version of the Software from the Account Dashboard are Publicly Licensed and generally available for Customer to download from a Public Software Repository. Provider does not agree to any Service-Level Agreement or other specific guarantee about any Public Software Repository.

    (b) _Provide Support_. While the Order continues, if the Order includes Support Terms, Provider agrees to respond to Support Requests as the Support Terms describe.

    (c) _Publish Documentation_. While the Order continues, Provider agrees to host the Documentation so Customer personnel can read it via the Internet.

    (d) _Give Credits for Bad Service_. If the Order includes any Service-Level Agreement, Provider agrees to credit Customer&#39;s account on Notice and verification that it failed to provide service according to the Service-Level Agreement. Provider agrees to apply credits against Customer&#39;s obligations to pay Fees as soon as possible. Provider does not agree to refund any credits.

    (e) _Refund Fees for Poor Service_. If Provider credits Customer&#39;s account under a Service-Level Agreement for three months in a row, and Customer ends the Order during the third month, citing poor service, Provider agrees to refund Fees that Customer paid for those three months, as well as any Prepaid Fees.

    (f) _Refund Prepaid Fees for Removed Features_. If Provider changes or removes Software Features from the Latest Version of the Software that were part of the Feature Set, substantially reducing how useful the Software is to Customer, and Customer ends the Order within three calendar months of the change, citing the change, Provider agrees to refund any Prepaid Fees.

    (g) _Keep Malicious Code Out of the Software_. While the Order continues, Provider agrees to make sure the Latest Version of the Software is free of malicious code.

    (h) _Limit Validation Code in the Software_. Provider may include code in the Latest Version of the Software that automatically disables Software Features on failure to validate administrative Access Credentials, but agrees not to include any code that disables Software Features based on monitoring of Use Allowances. Provider may include code that monitors Use Allowances, validates administrative Access Credentials, and reports results back to Provider systems.

    (i) _Protect Customer from Liability_. So long as the Pricing requires Customer to pay some amount of Software Fees, and Customer has paid all Fees as required by the Pricing:

    (i) _Indemnify Customer_. Subject to _Section 8(a) (Indemnification Process)_, Provider agrees to give Customer Indemnification for Legal Claims by others alleging that Permitted Use of the Software infringes any copyright, trademark, or trade secret right, or breaks any law.

    (ii) _Provide Assurance about Patents_. As of the Order date, Provider is not aware of any patent that Provider would infringe by licensing or providing the Software under these terms, or that Customer would infringe by Permitted Use of the Software.

    (iii) _Address Legal Problems_. Provider agrees that if someone else gets a court order against Customer&#39;s Permitted Use of the Software based on a claim that it infringes any Intellectual Property Right, or breaks any law, and whenever Provider anticipates that kind of claim, Provider will give Customer prompt Notice, and may take any of these added steps:

    (A) Provider may release a new Latest Version of the Software so that Permitted Use of the Software will no longer infringe or break the law.

    (B) If the Order is for Hosted Software, Provider may change how it provides the Software so that Permitted Use of the Software will no longer infringe or break the law.

    (C) If the problem is infringement, Provider may get a license for Customer so that Permitted Use of the Software will no longer infringe.

    (D) If the problem is illegality, Provider may get the government approvals, licenses, or other requirements needed to abide by the law.

    (E) Provider may end the Order and refund any Prepaid Fees.

4. _Customer&#39;s Obligations_.

    (a) _Pay Fees_. Customer agrees to pay all Fees, in advance, for each period on the Billing Cycle, using the agreed Payment Method. Customer agrees to pay all tax on Software Fees and Support Fees, except tax Provider owes on income.

    (b) _Follow Rules About Use_. Customer agrees not to:

    (i) reverse engineer the Software

    (ii) circumvent any access controls or other limits of the Software

    (iii) circumvent code permitted under _Section 3(h) (Limit Validation Code in the Software)_

    (iv) violate others others&#39; intellectual property or other rights using the Software

    (v) breach any agreement using the Software

    (vi) break the law using the Software

    (vii) license, sell, lease, or otherwise let anyone but Customer Personnel use Software Features

    (viii) furnish Customer Data in any way that infringes any Intellectual Property Right, breaks any law, or breaches any other agreement

    (ix) furnish Customer Data subject to Special Data Regulations

    (x) reuse any one set of Access Credentials for multiple Users

    (xi) remove proprietary notices from Software or Documentation

    (xii) use the Software for competitive analysis

    (xiii) if the Order is for Hosted Software, strain the technical infrastructure of the Software with an unreasonable volume of requests, or requests expected to impose an unreasonable load

    (xiv) publish data about the performance of the Software

    (c) _Enforce Rules About Use_. Customer agrees to make sure Customer Personnel and other personnel abide by _Section 4(b) (Follow Rules About Use)_ and _Section 4(g) (Abide by Export Controls)_.

    (d) _Update Account Details_. While the Order continues, Customer agrees to use the Account Dashboard to keep its contact, payment, and other administrative details complete, accurate, and up-to-date.

    (e) _Notify Provider if it Becomes Ineligible for the Package_. Customer agrees to give Notice if it stops meeting any of the Eligibility Criteria before the Order ends.

    (f) _Keep Access Credentials Secret and Secure_. Customer agrees to make sure Customer Personnel only share Access Credentials as needed to use the Software and services under these terms, and secure Access Credentials at least as well as Customer&#39;s own confidential information.

    (g) _Abide by Export Controls_. The Software is subject to United States export restrictions, and may be subject to foreign import restrictions. Customer agrees not to break any import or export law by exporting or reexporting the Software.

    (h) _Indemnify Provider_. Subject to _Section 8(a) (Indemnification Process)_, Customer agrees to give Provider Indemnification from Legal Claims by others based on:

    (i) breach of these terms

    (ii) Customer Data

    (iii) Use of the Software at Customer&#39;s Own Risk

    (iv) misuse of Customer&#39;s Access Credentials

5. _Intellectual Property_.

    (a) _Copyright License_. If the Order is for Licensed Software, Provider grants Customer and each of the Users a Standard License, for any copyrights Provider can license, to copy, install, back up, and make Permitted Use of the Software and Documentation.

    (b) _Patent License_. Provider grants Customer and each of the Users a Standard License, for any patents Provider can license, to make Permitted Use of the Software.

    (c) _No Other Licenses_. With the exceptions of the licenses in _Section 5 (Intellectual Property)_, these terms do not license or assign any Intellectual Property Right.

6. _Changes_.

    (a) _Changes Customer May Make_. Subject to _Section 8(c) (Change Process)_:

    (i) Customer may end the Order at any time.

    (ii) If Software Pricing and any Support Pricing can calculate Fees for different Use Allowances, Customer may change its Use Allowances within any Pricing limits at any time. Customer changes to Use Allowances take effect as soon as Customer pays any added Fees under the Pricing.

    (b) _Changes Provider May Make_. Subject to _Section 8(c) (Change Process)_:

    (i) Provider may end the Order whenever Pricing does not require Customer to pay any amount of Software Fees.

    (ii) Provider may end the Order if Customer stops meeting any of the Eligibility Criteria.

    (iii) Provider may end the Order at the end of any Commitment Period by giving Notice at least one Billing Cycle in advance.

    (iv) Provider may end the Order immediately if Customer breaches these terms.

    (v) Provider may add, remove, and change Software Features in the Latest Version of the Software.

    (vi) Provider may add, remove, and change the functionality of the Account Dashboard and Documentation.

    (vii) Provider may make changes under _Section 3(i)(iii) (Address Legal Problems)_.

    (c) _Renewal_. The Order will automatically renew for another Commitment Period when the prior Commitment Period ends. Either side may stop the Order from renewing by ending it before it renews.

7. _Liability_.

    (a) _Agreed Legal Remedies_.

    (i) Each side&#39;s only legal remedy for Legal Claims covered by Indemnification will be Indemnification.

    (ii) Customer&#39;s only legal remedy for failures to meet any Service-Level Agreement will be credits under _Section 3(d) (Give Credits for Bad Service)_.

    (iii) Customer&#39;s only legal remedy for changes to Software Features in the Latest Version of the Software will be refunds under _Section 3(f) (Refund Prepaid Fees for Removed Features)_.

    (b) _Valid Excuses_. Neither side will be liable for any failure or delay in meeting any obligation under these terms caused by a Disaster, failure of the other side or its personnel to meet their obligations under these terms, or actions done or delayed on written request of the other side.

    (c)  **Only Express Warranties**. **With the exception of its obligations in Section 3 (Provider&#39;s Obligations), Provider provides the Software &quot;as is&quot;, without express or implied warranties about the quality of the Software, the security or correct operation of any Hosted Software, or the quality of any services. Provider disclaims any warranties the law might otherwise imply, like warranties of merchantability, fitness for any particular purpose, title, or noninfringement.**

    (d)  **Limited Damages**.

    (i) **Subject to Section 7(d)(iii) (Damages Limit Exceptions), neither side&#39;s total liability for breach of these terms will exceed the amount of Fees Provider received from Customer during the twelve months before the first claim is filed. This limit applies even if the one liable is advised that the other may suffer damages, and even if Customer paid no fees at all.**

    (ii) **Subject to Section 7(d)(iii) (Damages Limit Exceptions), neither side will be liable for breach-of-contract damages they could not have reasonably foreseen when agreeing to these terms.**

    (iii) _Damages Limit Exceptions_. _Section 7(d) (Limited Damages)_ does not limit damages for breach of:

    (A) _Section 4(a) (Pay Fees)_

    (B) _Section 3(a)(i)(C) (Keep Customer Data Confidential)_

    (C) _Section 4(b) (Follow Rules About Use)_

    (D) _Section 4(c) (Enforce Rules About Use)_

    (E) _Section 3(i)(ii) (Provide Assurance about Patents)_

    (F) _Section 4(g) (Abide by Export Controls)_

    (G) _Section 3(i)(i) (Indemnify Customer)_

    (H) _Section 4(h) (Indemnify Provider)_

8. _Process_.

    (a) _Indemnification Process_. Both sides agree that to receive Indemnification under these terms, they must give Notice of any covered Legal Claims quickly, allow the other side to control investigation, defense, and settlement, and cooperate with those efforts. Both sides agree that if they fail to give Notice of any covered Legal Claims quickly, Indemnification will not cover amounts that could have been defended against or mitigated if Notice had been given quickly. Both sides agree that if they take control of the defense and settlement of any Legal Claims covered by Indemnification, they will not agree to any settlements that admit fault or impose obligations on the other side without their Permission.

    (b) _Notice Process_. Both sides agree that to give Notice under these terms, the side giving Notice must send by e-mail to the address the recipient given with its signature, or to a different address given later for Notice going forward. If either side finds that e-mail can&#39;t be delivered to the e-mail address given, it may give Notice by registered mail to the address on file for the recipient with the state under whose laws it is organized.

    (c) _Change Process_. Customer agrees to make changes to the Order through the Account Dashboard whenever possible. If the Account Dashboard does not provide a user interface for making a particular change, or the Account Dashboard is not available or malfunctions, Customer may make its change by Notice to Provider. Provider agrees to make changes to the Order by Notice.

9. _General Contract Terms_.

    (a) _Governing Law_. The law of the state of Provider&#39;s Main Office will govern these terms.

    (b) _No CCSG_. The United Nations Convention on Contracts for the Sale of Goods will not apply to these terms.

    (c) _No UCITA_. The Uniform Computer Information Transactions Act will not apply to these terms.

    (d) _Government Procurement_. The Software is commercial computer software, and the Documentation is commercial computer software documentation. Both Software and the Documentation were developed exclusively at private expense. If Customer&#39;s procurement of the Software and Documentation is subject to Federal Acquisition Regulation 12.212 or Defense Federal Acquisition Regulation Supplement 227.7202, Customer&#39;s rights in the Software and Documentation will be only those stated in the Order and these terms.

    (e) _Whole Agreement_. Both sides intend the Order and these terms as the final, complete, and only expression of their terms about use of the Software and related support services. However, these terms do not affect the terms of any separate nondisclosure or confidentiality agreement Provider and Customer may have.

    (f) _Enforcement_. Only Provider and Customer may enforce these terms.

    (g) _Assignment_. Each side may assign all its rights, licenses, and obligations under these terms, as a whole, to a new legal entity created to change its jurisdiction or legal form of organization, or to an entity that acquires substantially all of its assets or enough securities to control its management. Otherwise, each side needs Permission to assign any right or license under these terms. Attempts to assign against these terms will have no legal effect.

    (h) _Lawsuits_.

    (i) _Forum_. Both sides agree to bring any Lawsuit in Provider&#39;s Local Courts.

    (ii) _Exclusive Jurisdiction_. Both sides consent to the exclusive jurisdiction of Provider&#39;s Local Courts. Both sides may enforce judgments from Provider&#39;s Local Courts in other jurisdictions.

    (iii) _Inconvenient Forum Waiver_. Both sides waive any objection to venue for any Lawsuit in Provider&#39;s Local Courts and any claim that the other brought any Lawsuit in Provider&#39;s Local Courts in an inconvenient forum.

10. _Definitions_.

    (a)  **Access Credentials** means a user name and password, license key, or other secret that affords use of the Software.

    (b)  **Business Days** means days other than Saturdays, Sundays, and days when commercial banks in the capital of the state of Provider&#39;s Main Office typically stay closed.

    (c)  **Concurrent Users** means the number of Users logged into or using the Software at any given time.

    (d)  **Customer Data** means data that:

    (i) Users furnish to the Software, such as by entering it or configuring the Software to gather or receive it, if doing so doesn&#39;t breach these terms

    (ii) the Software collects about Users and how they use the Software

    (e)  **Customer Personnel** means Customer&#39;s employees and each Customer subsidiary&#39;s employees, as well as independent contractors providing services to Customer.

    (f)  **Customer Systems** means computer programs run by Customer or by independent contractors for Customer.

    (g)  **Software Dependencies** means software from others that the Software depends on, installs, configures, or links, directly or indirectly, to provide the Feature Set.

    (h)  **Disaster** means:

    (i) fire, flood, earthquake, and other natural disasters

    (ii) declared and undeclared wars, acts of terrorism, sabotage, riots, civil disorders, rebellions, and revolutions

    (iii) extraordinary malfunction of Internet infrastructure, data centers, or communications utilities

    (iv) government actions taken in response to any of these causes

    (i)  **Fees** means Software Fees and Support Fees.

    (j)  **Indemnification** means indemnifying and holding harmless for all liability, expenses, damages, and costs.

    (k)  **Intellectual Property Right** means any patent, copyright, trademark, or trade secret right, or any other legal right typically referred to as an intellectual property right.

    (l)  **Latest Version of the Software** means the most recent version of the Software that Provider publicly promotes for use in production, rather than test or development, systems.

    (m)  **Lawsuit** means a lawsuit brought by one side against the other, related to these terms or the Software.

    (n)  **Legal Claims** means claims, demands, lawsuits, and other legal actions.

    (o)  **Notice** means a written communication from one side to the other per _Section 8(b) (Notice Process)_.

    (p)  **Permission** means prior Notice of consent.

    (q)  **Permitted Use of the Software** means Customer&#39;s use of the Software, other than Use of the Software at Customer&#39;s Own Risk.

    (r)  **Prepaid Fees** means Fees Customer prepaid for time remaining in the current Billing Cycle.

    (s)  **Pricing** means Software Pricing and any Support Pricing.

    (t)  **Provider&#39;s Local Courts** means the state and federal courts with jurisdiction at Provider&#39;s Main Office.

    (u)  **Provider&#39;s Main Office** means Provider&#39;s office where its most senior executive officer is based on the date of this agreement. If Provider does not have an office, Provider&#39;s Main Office is the capital of the state under whose laws Provider is organized.

    (v)  **Publicly Licensed** means published with a notice of a license to the public, or to everyone who receives a copy.

    (w)  **Public Software Repository** means an website or Internet service that provides free-of-charge downloads of Publicly Licensed Software.

    (x)  **Running Instances** means the number of copies of the Software Customer runs at any given time.

    (y)  **Service-Level Agreement** means a Provider commitment to meet specific, measurable standards in providing a service, such as an uptime percentage for Hosted Software or a mean time of response to Support Requests.

    (z)  **Software Features** means functions of the Software described in the Documentation.

    (aa)  **Special Data Regulations** means laws and regulations that impose special requirements on the collection, storage, processing, or transmission of particular kinds of data about individuals. The Gramm-Leach-Bliley Act, Health Insurance Portability and Accountability Act, Children&#39;s Online Privacy Protection Act, and Fair Credit Reporting Act are some Special Data Regulations. Laws that apply to data just because they may identify specific individuals are not Special Data Regulations.

    (ab)  **Standard License** means a nonexclusive license while the Order continues that is conditional on payment of all Software Fees as required by these terms and limited by the Use Allowances.

    (ac)  **Support Requests** means questions and requests for help concerning the Software from Customer Personnel.

    (ad)  **Use of the Software at Customer&#39;s Own Risk** means:

    (i) use of the Software in breach of these terms

    (ii) use of the Software with changes, additions, or in combination with other software, computers, or data, in a way that infringes someone else&#39;s Intellectual Property Right or breaks the law, if use of the Software as provided, as described by the Documentation, would not

    (iii) use of other than the Latest Version of the Software that infringes someone else&#39;s Intellectual Property Right or breaks the law, if Customer had Notice that using the Latest Version of the Software would not

    (iv) unauthorized use of the Software with Customer Access Credentials

    (ae)  **User Accounts** means the number of Users with Access Credentials, not counting any administrative Access Credentials.

    (af)  **Users** means Customer Personnel using the Software and Customer Systems using the Software.
"""


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
                    [ div [ class "row px-5" ]
                        [ div [ class "col-12 px-12" ]
                            [ viewTerms ]
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
