export class InputError extends Error{status;constructor(r,t=400){super(r);this.status=t;this.name="InputError"}}
