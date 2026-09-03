import type { Telemetry } from './riskEngine';
export type CadenceTracker = { last:number; samples:number[] };
export const newCadenceTracker=():CadenceTracker=>({last:0,samples:[]});
export function recordKeypress(tracker:CadenceTracker, at=Date.now()){if(tracker.last)tracker.samples.push(at-tracker.last);tracker.last=at;return tracker;}
export function edgeTelemetry(tracker:CadenceTracker, flags:Pick<Telemetry,'activeCall'|'screenShare'|'clipboard'>):Telemetry{const avg=tracker.samples.length?Math.round(tracker.samples.reduce((a,b)=>a+b,0)/tracker.samples.length):0;return {...flags,hesitation:avg};}
export const isCoercionCadence=(ms:number)=>ms>850;
