$ErrorActionPreference = 'Stop'

$firstNames = @('Aarav','Diya','Kabir','Meera','Arjun','Anaya','Vihaan','Isha','Rohan','Kavya','Dev','Tara','Ishaan','Naina','Reyansh','Aditi','Neil','Mira','Yash','Saanvi','Advik','Riya','Karan','Pooja','Samar')
$lastNames = @('Demo','Sample','Test','Example','Mock','Prototype','Sandbox','Training','Simulated','Fictional')
$employers = @('Example Retail Ltd','Demo Health Services','Sample Manufacturing','Test Education Trust','Sandbox Logistics','Prototype Systems','Example Foods','Mock Finance Services')
$jobs = @('Accounts Executive','Teacher','Store Manager','Nurse','Software Analyst','Sales Associate','Operations Lead','Self-employed Consultant')
$merchants = @('Demo Grocers','Sample Pharmacy','Example Fuel Station','Test Cafe','Mock Electronics','Sandbox Market')
$records = foreach ($n in 1..500) {
    $first = $firstNames[($n - 1) % $firstNames.Count]
    $last = $lastNames[(($n - 1) * 3) % $lastNames.Count]
    $income = 360000 + (($n * 17300) % 1800000)
    $balance = 12000 + (($n * 4927) % 890000)
    $credit = 610 + (($n * 7) % 221)
    $month = 1 + (($n - 1) % 12)
    $day = 1 + (($n * 3) % 27)
    $merchant = $merchants[($n - 1) % $merchants.Count]
    $payee = if ($n % 3 -eq 0) { 'B001 - Family Transfer (Synthetic)' } elseif ($n % 3 -eq 1) { 'B002 - Utility Account (Synthetic)' } else { 'B003 - Merchant Settlement (Synthetic)' }
    $depositDay = 1 + (($day + 9) % 27)
    $transferDay = 1 + (($day + 4) % 27)
    $salaryDeposit = [math]::Round($income / 12)
    $withdrawal = 500 + (($n * 37) % 9000)
    $sentTransfer = 500 + (($n * 83) % 45000)
    $receivedTransfer = 1000 + (($n * 29) % 30000)
    [pscustomobject]@{
        dataset_notice = 'SYNTHETIC TEST DATA — NOT A REAL PERSON OR ACCOUNT'
        client_id = ('SYN-CL-{0:D4}' -f $n)
        full_name = "$first $last $n"
        date_of_birth = ('{0:D4}-{1:D2}-{2:D2}' -f (1948 + ($n % 45)), $month, $day)
        home_address = ('{0} Example Lane, Demo Nagar, Test State 000000' -f (100 + $n))
        phone_number = ('+91-00000-{0:D5}' -f $n)
        email_address = ('client{0:D4}@example.invalid' -f $n)
        government_id_passport = ('SYN-PPT-{0:D6}' -f $n)
        government_id_tax = ('SYN-TAX-{0:D6}' -f $n)
        job_title = $jobs[($n - 1) % $jobs.Count]
        employer_name = $employers[($n - 1) % $employers.Count]
        annual_income_inr = $income
        source_of_money = if ($n % 4 -eq 0) { 'Synthetic business income' } else { 'Synthetic salary income' }
        credit_score = $credit
        credit_history = if ($credit -ge 750) { 'Synthetic: strong repayment pattern' } elseif ($credit -ge 680) { 'Synthetic: satisfactory repayment pattern' } else { 'Synthetic: limited repayment history' }
        other_assets_inr = (50000 + (($n * 11903) % 3200000))
        outstanding_loans_inr = (($n * 2309) % 950000)
        account_balance_inr = $balance
        deposit_withdrawal_history = ("2026-{0:D2}-{1:D2} Deposit: Synthetic salary INR {2}; 2026-{0:D2}-{3:D2} Withdrawal: Synthetic ATM INR {4}" -f $month,$day,$salaryDeposit,$depositDay,$withdrawal)
        transfer_history = ("2026-{0:D2}-{1:D2} Sent INR {2} to {3}; 2026-{0:D2}-{4:D2} Received INR {5} from Synthetic sender" -f $month,$day,$sentTransfer,$payee,$transferDay,$receivedTransfer)
        card_purchase_locations = ("$merchant, Demo Sector $((($n - 1) % 25) + 1); Example Metro, Test District")
        payees_merchants = "$payee; $merchant"
        ip_address = ('198.51.100.{0}' -f (1 + (($n - 1) % 254)))
        device_type = if ($n % 2 -eq 0) { 'Synthetic Android test device' } else { 'Synthetic iOS test device' }
        mobile_app_usage_habits = if ($n % 3 -eq 0) { 'Synthetic: daily balance check, monthly transfer' } else { 'Synthetic: weekly balance check, card payment' }
        last_login_datetime = ('2026-08-{0:D2} {1:D2}:{2:D2}:00 IST' -f (1 + (($n * 5) % 28)), (8 + ($n % 12)), (($n * 7) % 60))
        app_location_data = ('SIMULATED: Demo Zone {0}, Example City, Test State' -f (1 + (($n - 1) % 20)))
    }
}

$destination = Join-Path $PSScriptRoot '..\outputs\guardianedge_synthetic_bank_clients_500.csv'
$records | Export-Csv -LiteralPath $destination -NoTypeInformation -Encoding utf8
Write-Output "Created $destination with $($records.Count) synthetic client records."
