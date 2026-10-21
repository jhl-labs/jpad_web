export async function revokeUserCredentials(e,s){await e.user.update({where:{id:s},data:{sessionVersion:{increment:1}}});await e.userApiToken.updateMany({where:{userId:s,revokedAt:null},data:{revokedAt:new Date}});await e.ssoLoginToken.deleteMany({where:{userId:s}})}export async function lockActiveCredentialIssuer(e,s,n){const r=await(e.$queryRaw`
    SELECT "sessionVersion", "disabledAt" FROM "User" WHERE "id" = ${s} FOR UPDATE
  `);const t=r[0];if(!t||t.disabledAt||t.sessionVersion!==n){throw new Error("Unauthorized")}}
