import{NextResponse as t}from"next/server";export function GET(){return t.json({status:"ok",uptime:process.uptime()})}
