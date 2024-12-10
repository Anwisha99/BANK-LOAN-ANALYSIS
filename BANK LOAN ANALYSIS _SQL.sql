select * from finance_1;
select * from finance_2;


--1- Year wise loan amount Stats

select 
year(issue_d) as year1,
sum(loan_amnt) as total_stats
from finance_1
group by year(issue_d)

--2.Grade and sub grade wise revol_bal

select 
grade,
sub_grade,
sum(revol_bal) as total_revol_bal
from finance_1 as F1
left join 
finance_2 as F2
on F1.id=F2.id
group by grade,
sub_grade

----3.Total Payment for Verified Status Vs Total Payment for Non Verified Status

select 
f1.verification_status,
sum(f2.total_pymnt) as total_payment
from finance_1 as F1
left join 
finance_2 as F2
on F1.id=F2.id
where f1.verification_status in ('Not Verified','Verified')
group by f1.verification_status

----4.State wise and month wise loan status
select
addr_state,
datename(month,last_credit_pull_d) as last_cred_mnth,
max(loan_status) as loan_status
from finance_1 as F1
inner join 
finance_2 as F2
on F1.id=F2.id
group by addr_state,
datename(month,last_credit_pull_d)

--5.Home ownership Vs last payment date stats

select home_ownership,
year(last_pymnt_d) as last_payment_y ,
sum(last_pymnt_amnt) AS payment_amount
from finance_1 as F1
inner join 
finance_2 as F2
on F1.id=F2.id
group by home_ownership,
year(last_pymnt_d);

----Q6- Region wise loan stats


	select
	region,
	sum(loan_amnt)as total_loan_amount
	from
	(select 
	addr_state,
	loan_amnt,
	CASE 
        WHEN addr_state IN ('ME', 'VT', 'NH', 'MA', 'RI', 'CT', 'NY', 'NJ', 'PA', 'DE', 'MD', 'DC', 'VA', 'WV', 'NC', 'SC', 'GA', 'FL') THEN 'East'
        WHEN addr_state IN ('ND', 'SD', 'NE', 'KS', 'MN', 'IA', 'MO', 'WI', 'IL', 'IN', 'MI', 'OH') THEN 'North'
        WHEN addr_state IN ('TX', 'OK', 'AR', 'LA', 'KY', 'TN', 'AL', 'MS') THEN 'South'
        WHEN addr_state IN ('WA', 'OR', 'CA', 'NV', 'ID', 'MT', 'WY', 'UT', 'CO', 'AZ', 'NM', 'AK', 'HI') THEN 'West'
        ELSE 'Unknown'
    END AS region
	FROM finance_1) as region1
	group by region



	--Q7-region wise count the number of accounts whose loan status are verified and not verified


	SELECT 
	REGION ,
	VERIFICATION_STATUS,
	COUNT(ID) AS TOTAL_ACCOUNT
	FROM (select 
	ID,
	VERIFICATION_STATUS,
	CASE 
        WHEN addr_state IN ('ME', 'VT', 'NH', 'MA', 'RI', 'CT', 'NY', 'NJ', 'PA', 'DE', 'MD', 'DC', 'VA', 'WV', 'NC', 'SC', 'GA', 'FL') THEN 'East'
        WHEN addr_state IN ('ND', 'SD', 'NE', 'KS', 'MN', 'IA', 'MO', 'WI', 'IL', 'IN', 'MI', 'OH') THEN 'North'
        WHEN addr_state IN ('TX', 'OK', 'AR', 'LA', 'KY', 'TN', 'AL', 'MS') THEN 'South'
        WHEN addr_state IN ('WA', 'OR', 'CA', 'NV', 'ID', 'MT', 'WY', 'UT', 'CO', 'AZ', 'NM', 'AK', 'HI') THEN 'West'
        ELSE 'Unknown'
    END AS region
	FROM finance_1 ) AS X
	WHERE VERIFICATION_STATUS IN ('Not Verified','Verified')
	GROUP BY REGION, 
	VERIFICATION_STATUS
	ORDER BY VERIFICATION_STATUS
