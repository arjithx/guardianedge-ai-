import './globals.css';
import { BankingProvider } from '@/context/BankingContext';
import { DemoControlBar } from '@/components/DemoControlBar';
export const metadata = { title: 'GuardianEdge AI', description: 'Real-time APP scam shield' };
export default function RootLayout({ children }: { children: React.ReactNode }) { return <html lang="en"><body><BankingProvider><DemoControlBar />{children}</BankingProvider></body></html>; }
