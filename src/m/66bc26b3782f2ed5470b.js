export function withEditorIdentity(t){return{...t,editorId:crypto.randomUUID()}}export function withoutEditorIdentity(t){const{editorId:o,...r}=t;return r}
