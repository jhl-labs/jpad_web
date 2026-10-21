export function isHttpUrl(t){try{const r=new URL(t).protocol;return r==="http:"||r==="https:"}catch{return false}}export function toSafeExternalHref(t){return isHttpUrl(t)?t:"#"}
