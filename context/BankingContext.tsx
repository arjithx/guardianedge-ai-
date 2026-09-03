'use client';
import { createContext, useContext, useEffect, useMemo, useRef, useState } from 'react';
import profiles from '@/data/banking_dataset.json';
import { calculateRisk, type CustomerProfile, type PaymentInput, type RiskResult, type Telemetry } from '@/lib/riskEngine';
export type Transaction = PaymentInput & { id:string; createdAt:string; status:'SETTLED'|'HELD'|'FROZEN'; risk:RiskResult; telemetry:Telemetry; answers?:boolean[] };
type Store = { profile:CustomerProfile; authenticated:boolean; login:(customerId:string)=>boolean; logout:()=>void; telemetry:Telemetry; setTelemetry:(x:Telemetry)=>void; pending:Transaction|null; setPending:(x:Transaction|null)=>void; transactions:Transaction[]; addTransaction:(x:Transaction)=>void; updateTransaction:(id:string,status:Transaction['status'])=>void; makeRisk:(x:PaymentInput)=>RiskResult };
const defaults:Telemetry = { activeCall:false, screenShare:false, clipboard:false, hesitation:0 };
const C = createContext<Store | null>(null);
export function BankingProvider({children}:{children:React.ReactNode}) {
 const [activeCustomer,setActiveCustomer] = useState('C101'); const [authenticated,setAuthenticated] = useState(false);
 const profile = (profiles.find(p=>p.customer_id===activeCustomer)||profiles[0]) as CustomerProfile;
 const [telemetry,setTelemetry] = useState(defaults); const [pending,setPending] = useState<Transaction|null>(null); const [transactions,setTransactions] = useState<Transaction[]>([]);
 const hydrated = useRef(false);
 useEffect(()=>{ const raw=localStorage.getItem('guardianedge-state'); if(raw){try { const v=JSON.parse(raw); setTelemetry(v.telemetry||defaults); setPending(v.pending||null); setTransactions(v.transactions||[]); setActiveCustomer(v.activeCustomer||'C101'); setAuthenticated(Boolean(v.authenticated)); }catch{}} hydrated.current=true; },[]);
 useEffect(()=>{ if(hydrated.current) localStorage.setItem('guardianedge-state',JSON.stringify({telemetry,pending,transactions,activeCustomer,authenticated})); },[telemetry,pending,transactions,activeCustomer,authenticated]);
 const value=useMemo(()=>({profile,authenticated,login:(id:string)=>{const valid=profiles.some(p=>p.customer_id===id.toUpperCase());if(valid){setActiveCustomer(id.toUpperCase());setAuthenticated(true)}return valid},logout:()=>setAuthenticated(false),telemetry,setTelemetry,pending,setPending,transactions,addTransaction:(x:Transaction)=>setTransactions(v=>[x,...v]),updateTransaction:(id:string,status:Transaction['status'])=>setTransactions(v=>v.map(x=>x.id===id?{...x,status}:x)),makeRisk:(x:PaymentInput)=>calculateRisk(x,telemetry,profile)}),[profile,authenticated,telemetry,pending,transactions]);
 return <C.Provider value={value}>{children}</C.Provider>;
}
export const useBanking=()=>{const c=useContext(C); if(!c) throw new Error('BankingProvider missing'); return c;};
