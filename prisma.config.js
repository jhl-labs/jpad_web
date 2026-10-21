import r from"node:path";import{defineConfig as o}from"prisma/config";export default o({schema:r.join(process.cwd(),"prisma","schema.prisma"),datasource:{url:process.env.DATABASE_URL}});
