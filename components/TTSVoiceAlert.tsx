'use client';
import { useEffect, useState } from 'react';
import { Volume2 } from 'lucide-react';
const message='Warning. Your bank will never call demanding instant transfers to avoid power cut or legal action.';
export function TTSVoiceAlert(){ const [on,setOn]=useState(false); const speak=()=>{ if(typeof window==='undefined'||!window.speechSynthesis)return; window.speechSynthesis.cancel(); const u=new SpeechSynthesisUtterance(message); u.rate=.88; window.speechSynthesis.speak(u); setOn(true); }; useEffect(()=>{speak(); return ()=>window.speechSynthesis?.cancel()},[]); return <button onClick={speak} className="flex w-full items-center gap-3 rounded-xl bg-blue-50 p-4 text-left text-blue-900"><Volume2 className={on?'animate-pulse text-teal':'text-teal'} /><span><b>Voice safety alert</b><br/><span className="text-sm">Tap to hear this warning again.</span></span></button> }
