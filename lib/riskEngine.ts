export type Telemetry = { activeCall:boolean; screenShare:boolean; clipboard:boolean; hesitation:number };
export type PaymentInput = { beneficiary:string; upi:string; amount:number; remarks:string };
export type RiskResult = { score:number; level:'SAFE'|'HIGH'|'CRITICAL'; triggers:string[] };
export type CustomerProfile = { customer_id:string; full_name:string; phone_number:string; bank_name:string; account_number:string; upi_id:string; profile_image_url:string; balance:number; upi_pin:string; age_group:string; digital_literacy:'Basic'|'Moderate'|'Advanced'; average_tx_amount:number; normal_hours:string[]; known_beneficiaries:{name:string;upi_id:string}[] };
const urgency = /\b(cbi|police|electricity\s*(cut|disconnection)?|urgent|penalty|legal action|freeze)\b/i;
export function calculateRisk(payment:PaymentInput, telemetry:Telemetry, profile:CustomerProfile, now=new Date()):RiskResult {
 let score=0; const triggers:string[]=[]; const known=profile.known_beneficiaries.some(b=>b.upi_id.toLowerCase()===payment.upi.toLowerCase()||b.name.toLowerCase()===payment.beneficiary.toLowerCase());
 const verifiedMedical=/hospital|pharmacy|medical/i.test(`${payment.beneficiary} ${payment.upi} ${payment.remarks}`);
 if(verifiedMedical&&!telemetry.activeCall&&!telemetry.screenShare&&!telemetry.clipboard)return {score:18,level:'SAFE',triggers:['Verified medical emergency: no coercion telemetry detected']};
 if(payment.amount>profile.average_tx_amount*5){score+=40;triggers.push('Amount is more than 5× the usual payment');}
 if(!known){score+=25;triggers.push('New beneficiary outside saved contacts');}
 if(telemetry.activeCall){score+=30;triggers.push('Active scam-call signal');}
 if(telemetry.clipboard){score+=15;triggers.push('Beneficiary pasted from clipboard');}
 if(urgency.test(payment.remarks)){score+=20;triggers.push('Urgency or authority-pressure words detected');}
 const hour=now.getHours(), start=Number(profile.normal_hours[0].slice(0,2)), end=Number(profile.normal_hours[1].slice(0,2));
 if(hour<start||hour>=end){score+=15;triggers.push('Payment attempted outside usual hours');}
 score=Math.min(score,100); return {score,level:score>=75?'CRITICAL':score>=40?'HIGH':'SAFE',triggers};
}
