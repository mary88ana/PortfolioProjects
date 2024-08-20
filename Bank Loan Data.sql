SELECT*
FROM bank_loan_data

---KPIs
---Total Loan Applications

SELECT COUNT(DISTINCT id) as total_loan_applications
FROM bank_loan_data

---MTD Applications 
SELECT COUNT (DISTINCT id) as MTD_total_loan_application
FROM bank_loan_data
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date)=2021

---MoM, Month over Month Applications = (MTD-PMTD)/PMTD
---PMTD
SELECT COUNT (DISTINCT id) as PMTD_total_loan_application
FROM bank_loan_data
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date)=2021

---Total Funded Amount 
SELECT SUM(loan_amount) as total_funded_amount
FROM bank_loan_data

---Total Funded Amount MTD
SELECT SUM(loan_amount) as MTD_total_funded_amount
FROM bank_loan_data
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date)=2021

---Total Funded Amount PMTD
SELECT SUM(loan_amount) as PMTD_total_funded_amount
FROM bank_loan_data
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date)=2021

---Total Amount Received 
SELECT SUM(total_payment) as total_amount_received
FROM bank_loan_data

---Total Amount Received MTD
SELECT SUM(total_payment) as MTD_total_amount_received
FROM bank_loan_data
WHERE MONTH(issue_date)=12 AND YEAR(issue_date) = 2021 

---Total Amount Received PMTD
SELECT SUM(total_payment) as PMTD_total_amount_received
FROM bank_loan_data
WHERE MONTH(issue_date)=11 AND YEAR(issue_date) = 2021 

---Avg Interest Rate 
SELECT ROUND((AVG(int_rate)*100),2) as avg_interest_rate
FROM bank_loan_data

--or
SELECT CAST((AVG(int_rate)*100)AS DECIMAL(10,2)) as avg_interest_rate
FROM bank_loan_data


---Avg Interest Rate MTD

SELECT ROUND((AVG(int_rate)*100),2) as MTD_avg_interest_rate
FROM [Bank Loan DB]..bank_loan_data
WHERE MONTH(issue_date)=12 AND YEAR(issue_date)=2021

---PMTD Avg Interest Rate

SELECT ROUND((AVG(int_rate)*100),2) as PMTD_avg_interest_rate
FROM [Bank Loan DB]..bank_loan_data
WHERE MONTH(issue_date)=11 AND YEAR(issue_date)=2021

--- Average DTI
SELECT ROUND(AVG(dti),4) *100 as Avg_DTI 
FROM [Bank Loan DB]..bank_loan_data

--- Average DTI MTD
SELECT ROUND(AVG(dti),4) *100 as MTD_Avg_DTI 
FROM [Bank Loan DB]..bank_loan_data
WHERE MONTH(issue_date)=12 AND YEAR (issue_date)=2021

--- Average DTI PMTD
SELECT ROUND(AVG(dti),4) *100 as PMTD_Avg_DTI 
FROM [Bank Loan DB]..bank_loan_data
WHERE MONTH(issue_date)=11 AND YEAR (issue_date)=2021

SELECT loan_status
FROM [Bank Loan DB]..bank_loan_data

---Percentage of Good Loan Applications, "Current" or/and "Fully Paid"
SELECT 
CAST((COUNT(CASE WHEN loan_status='Fully Paid' OR loan_status = 'Current' THEN id END)*100.0)
/
COUNT(id)AS DECIMAL(10,2)) as good_loan_percentage
FROM [Bank Loan DB]..bank_loan_data

--Count of Good loans
SELECT COUNT(id) as good_loan_count
FROM [Bank Loan DB]..bank_loan_data
WHERE loan_status='Fully paid' OR loan_status='Current'

---Good Loan Funded Amount
SELECT SUM(loan_amount) as good_loan_funded_amount
FROM bank_loan_data
WHERE loan_status='Fully paid' OR loan_status='Current'

---Good Loan Total Received Amount
SELECT SUM(total_payment) as good_loan_payment_received
FROM  bank_loan_data
WHERE loan_status='Fully paid' OR loan_status='Current'


---Percentage of Bad Loan Applications, "Charged Off"
SELECT 
CAST((COUNT(CASE WHEN loan_status='Charged Off' THEN id END)*100.0)
/
COUNT(id)AS DECIMAL(10,2)) as bad_loan_percentage
FROM [Bank Loan DB]..bank_loan_data

---Count of Bad Loans
SELECT COUNT(id) as bad_loans_count
FROM bank_loan_data
WHERE loan_status='Charged Off'

---Bad Loans Funded Amount
SELECT SUM(loan_amount) as bad_loans_funded_amount
FROM bank_loan_data
WHERE loan_status='Charged Off'


---Bad Loans Total Payment Amount
SELECT SUM(total_payment) as bad_loans_received
FROM bank_loan_data
WHERE loan_status='Charged Off'

---Loan Status 
SELECT 
	loan_status,
	COUNT(id) as total_loan_applications,
	SUM(total_payment) as total_amount_received,
	SUM(loan_amount) as total_funded_amount,
	AVG(int_rate *100) as avg_int_rate,
	AVG(dti*100) as avg_dti
FROM bank_loan_data
GROUP BY loan_status


---Loan Status MTD
SELECT 
	loan_status,
	COUNT(id) as total_loan_applications,
	SUM(total_payment) as MTD_total_amount_received,
	SUM(loan_amount) as MTD_total_funded_amount
	
FROM bank_loan_data
WHERE MONTH(issue_date)=12 and YEAR(issue_date)=2021
GROUP BY loan_status


--- Monthly Trends by Issue Date
SELECT 
	MONTH(issue_date) as month_number,
	DATENAME(MONTH,issue_date) as application_month, 
	COUNT(id) as total_loan_applications,
	SUM(loan_amount) as total_funded_loan,
	SUM(total_payment) as total_payment_received
FROM bank_loan_data
GROUP BY MONTH(issue_date), DATENAME(MONTH,issue_date)
ORDER BY MONTH(issue_date)

--- Regional Analysis by State
SELECT 
	address_state, 
	COUNT(id) as total_loan_applications,
	SUM(loan_amount) as total_funded_loan,
	SUM(total_payment) as total_payment_received
FROM bank_loan_data
GROUP BY address_state
ORDER BY COUNT(id) DESC 

---Loan Term Analysis
SELECT 
	term, 
	COUNT(id) as total_loan_applications,
	SUM(loan_amount) as total_funded_loan,
	SUM(total_payment) as total_payment_received
FROM bank_loan_data
GROUP BY term
ORDER BY term 

---Employment Length Analysis
SELECT 
	emp_length, 
	COUNT(id) as total_loan_applications,
	SUM(loan_amount) as total_funded_loan,
	SUM(total_payment) as total_payment_received
FROM bank_loan_data
GROUP BY emp_length
ORDER BY COUNT(id) DESC

---Purpose of the Loan Analysis
SELECT 
	purpose, 
	COUNT(id) as total_loan_applications,
	SUM(loan_amount) as total_funded_loan,
	SUM(total_payment) as total_payment_received
FROM bank_loan_data
GROUP BY purpose
ORDER BY COUNT(id) DESC

---Home Ownership Analysis
SELECT 
	home_ownership, 
	COUNT(id) as total_loan_applications,
	SUM(loan_amount) as total_funded_loan,
	SUM(total_payment) as total_payment_received
FROM bank_loan_data
GROUP BY home_ownership
ORDER BY COUNT(id) DESC








SELECT*
FROM bank_loan_data