FROM public.ecr.aws/bitnami/node:latest as dependencies
WORKDIR /my-proyect
COPY package.json package-lock.json ./
RUN ["npm",  "install"]

FROM public.ecr.aws/bitnami/node:latest as builder
WORKDIR /my-proyect
COPY [".", "."]
COPY --from=dependencies /my-proyect/node_modules ./node_modules
RUN ["npm", "run", "export"]


FROM public.ecr.aws/bitnami/node:latest as runner
WORKDIR /my-proyect
ENV NODE_ENV production 
COPY --from=builder /my-proyect/public ./public
COPY --from=builder /my-proyect/.next ./.next
COPY --from=builder /my-proyect/node_modules ./node_modules
COPY --from=builder /my-proyect/package.json ./package.json

EXPOSE 8080
CMD ["npm", "start"]




