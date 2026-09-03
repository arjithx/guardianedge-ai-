import type { Config } from 'tailwindcss';
const config: Config = { content: ['./app/**/*.{ts,tsx}','./components/**/*.{ts,tsx}'], theme: { extend: { colors: { ink:'#10233f', navy:'#071b35', teal:'#00a7a0', coral:'#ef5b5b', mist:'#f3f7fb' }, boxShadow:{card:'0 12px 35px rgba(20,43,76,.09)'} } }, plugins: [] };
export default config;
