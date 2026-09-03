$ErrorActionPreference = 'Stop'

$firstNames = @('Ramaswamy','Aarav','Diya','Kabir','Meera','Arjun','Anaya','Vihaan','Isha','Rohan','Kavya','Dev','Tara','Ishaan','Naina','Reyansh','Aditi','Neil','Mira','Yash','Saanvi','Advik','Riya','Karan','Pooja')
$lastNames = @('Iyer','Demo','Sample','Test','Example','Mock','Prototype','Sandbox','Training','Fictional')
$beneficiarySets = @(
    'anand@apexbank|Anand (Son);tneb@trustpay|TNEB Electricity;nilgiris@trustpay|Nilgiris Supermarket',
    'family@trustpay|Family Contact;utility@trustpay|Utility Payment;grocers@trustpay|Demo Grocers',
    'clinic@trustpay|City Care Clinic;rent@trustpay|Rental Account;mobile@trustpay|Mobile Recharge'
)

$records = foreach ($number in 101..600) {
    $index = $number - 101
    $first = $firstNames[$index % $firstNames.Count]
    $last = $lastNames[($index * 3) % $lastNames.Count]
    $name = if ($number -eq 101) { 'Ramaswamy Iyer' } else { "$first $last $number" }
    $slug = ($name.ToLower() -replace '[^a-z0-9]', '')
    $age = if ($number -eq 101) { 'Senior Citizen (72 yrs)' } elseif ($number % 4 -eq 0) { '18-30' } elseif ($number % 4 -eq 1) { '31-45' } elseif ($number % 4 -eq 2) { '46-60' } else { '61-75' }
    $literacy = if ($number -eq 101) { 'Basic' } elseif ($number % 3 -eq 0) { 'Advanced' } elseif ($number % 3 -eq 1) { 'Moderate' } else { 'Basic' }
    $balance = if ($number -eq 101) { 148500.00 } else { 12500 + (($index * 937) % 467501) }
    $average = if ($number -eq 101) { 1850 } else { 500 + (($index * 73) % 18000) }
    $normalHours = if ($number -eq 101) { '08:00-20:00' } elseif ($number % 3 -eq 0) { '07:00-22:00' } elseif ($number % 3 -eq 1) { '09:00-19:00' } else { '08:00-21:00' }
    [pscustomobject]@{
        dataset_notice = 'SYNTHETIC TEST DATA - NOT A REAL PERSON, ACCOUNT, OR PIN'
        customer_id = "C$number"
        full_name = $name
        phone_number = ('+91 98{0:D3} {1:D5}' -f ($index % 1000), $number)
        bank_name = 'Apex Global Bank'
        account_number = ('XXXX-XXXX-{0:D4}' -f (4800 + ($index % 100)))
        upi_id = if ($number -eq 101) { 'ramaswamy72@apexbank' } else { "$slug@trustpay" }
        profile_image_url = ('https://api.dicebear.com/9.x/initials/svg?seed=trustpay-c{0}' -f $number)
        balance = ('INR {0:N2}' -f $balance)
        upi_pin = if ($number % 2 -eq 0) { ('{0:D4}' -f (($index * 17) % 10000)) } else { ('{0:D6}' -f (($index * 173) % 1000000)) }
        age_group = $age
        digital_literacy = $literacy
        average_tx_amount = ('INR {0:N2}' -f $average)
        normal_hours = $normalHours
        known_beneficiaries = $beneficiarySets[$index % $beneficiarySets.Count]
    }
}

$destination = Join-Path $PSScriptRoot '..\outputs\trustpay_synthetic_banking_dataset_500.csv'
$records | Export-Csv -LiteralPath $destination -NoTypeInformation -Encoding utf8
Write-Output "Created $destination with $($records.Count) synthetic TrustPay records."
