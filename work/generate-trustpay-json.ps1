$ErrorActionPreference = 'Stop'
$firstNames = @('Ramaswamy','Aarav','Diya','Kabir','Meera','Arjun','Anaya','Vihaan','Isha','Rohan','Kavya','Dev','Tara','Ishaan','Naina','Reyansh','Aditi','Neil','Mira','Yash','Saanvi','Advik','Riya','Karan','Pooja')
$lastNames = @('Iyer','Demo','Sample','Test','Example','Mock','Prototype','Sandbox','Training','Fictional')
$beneficiarySets = @(
    @(@{ name='Anand (Son)'; upi_id='anand@apexbank' },@{ name='TNEB Electricity'; upi_id='tneb@trustpay' },@{ name='Nilgiris Supermarket'; upi_id='nilgiris@trustpay' }),
    @(@{ name='Family Contact'; upi_id='family@trustpay' },@{ name='Utility Payment'; upi_id='utility@trustpay' },@{ name='Demo Grocers'; upi_id='grocers@trustpay' }),
    @(@{ name='City Care Clinic'; upi_id='clinic@trustpay' },@{ name='Rental Account'; upi_id='rent@trustpay' },@{ name='Mobile Recharge'; upi_id='mobile@trustpay' })
)
$records = foreach ($number in 101..600) {
  $index=$number-101; $name=if($number-eq 101){'Ramaswamy Iyer'}else{"$($firstNames[$index % $firstNames.Count]) $($lastNames[($index*3)%$lastNames.Count]) $number"}; $slug=($name.ToLower()-replace '[^a-z0-9]','')
  [pscustomobject]@{ customer_id="C$number"; full_name=$name; phone_number=('+91 98{0:D3} {1:D5}' -f ($index%1000),$number); bank_name='Apex Global Bank'; account_number=if($number-eq 101){'XXXX-XXXX-4819'}else{('XXXX-XXXX-{0:D4}' -f (4800+($index%100)))}; upi_id=if($number-eq 101){'ramaswamy72@apexbank'}else{"$slug@trustpay"}; profile_image_url=('https://api.dicebear.com/9.x/initials/svg?seed=trustpay-c{0}' -f $number); balance=if($number-eq 101){148500}else{12500+(($index*937)%467501)}; upi_pin=if($number%2-eq 0){('{0:D4}' -f (($index*17)%10000))}else{('{0:D6}' -f (($index*173)%1000000))}; age_group=if($number-eq 101){'Senior Citizen (72 yrs)'}elseif($number%4-eq 0){'18-30'}elseif($number%4-eq 1){'31-45'}elseif($number%4-eq 2){'46-60'}else{'61-75'}; digital_literacy=if($number-eq 101){'Basic'}elseif($number%3-eq 0){'Advanced'}elseif($number%3-eq 1){'Moderate'}else{'Basic'}; average_tx_amount=if($number-eq 101){1850}else{500+(($index*73)%18000)}; normal_hours=if($number-eq 101){@('08:00','20:00')}elseif($number%3-eq 0){@('07:00','22:00')}elseif($number%3-eq 1){@('09:00','19:00')}else{@('08:00','21:00')}; known_beneficiaries=$beneficiarySets[$index%$beneficiarySets.Count] }
}
$destination=Join-Path $PSScriptRoot '..\data\banking_dataset.json'
$records | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $destination -Encoding utf8
Write-Output "Created $destination with $($records.Count) synthetic profiles."
