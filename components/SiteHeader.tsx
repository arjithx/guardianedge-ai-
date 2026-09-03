import Link from 'next/link';
import { Landmark, Shield } from 'lucide-react';
export function SiteHeader(){return <header className="mx-auto flex max-w-7xl items-center justify-between px-5 py-6"><Link href="/" className="flex items-center gap-2 text-xl font-black text-navy"><span className="rounded-xl bg-teal p-2 text-white"><Shield size={22}/></span>GuardianEdge AI</Link><Link href="/bank-console" className="flex items-center gap-2 rounded-lg px-3 py-2 text-sm font-bold text-slate-600 hover:bg-white"><Landmark size={17}/> Bank Console</Link></header>}
