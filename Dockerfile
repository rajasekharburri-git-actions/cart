# FROM node:20.19.5-alpine3.21 AS build
# WORKDIR /opt/server
# COPY package.json .
# COPY *.js .
# # this may add extra cache memory
# RUN npm install 


# FROM node:20.19.5-alpine3.21
# # Create a group and user
# WORKDIR /opt/server
# RUN addgroup -S roboshop && adduser -S roboshop -G roboshop && \
#     chown -R roboshop:roboshop /opt/server
# EXPOSE 8080
# LABEL com.project="roboshop" \
#       component="cart" \
#       created_by="sivakumar"
# ENV REDIS_HOST="redis" \
#     CATALOGUE_HOST="catalogue" \
#     CATALOGUE_PORT="8080"
# COPY --from=build --chown=roboshop:roboshop /opt/server /opt/server
# USER roboshop
# CMD ["server.js"]
# ENTRYPOINT ["node"]


FROM node:20.19.5-alpine3.21 AS build
WORKDIR /opt/server
COPY package.json .
COPY *.js .
RUN npm install 


FROM node:20.19.5-alpine3.21

# ✅ Upgrade all Alpine packages to pull in CVE fixes for:
#    libcrypto3/libssl3 (→ 3.3.7-r0), musl/musl-utils (→ 1.2.5-r11),
#    busybox (→ 1.37.0-r14), zlib (→ 1.3.2-r0)
RUN apk upgrade --no-cache

WORKDIR /opt/server
RUN addgroup -S roboshop && adduser -S roboshop -G roboshop && \
    chown -R roboshop:roboshop /opt/server
EXPOSE 8080
LABEL com.project="roboshop" \
      component="cart" \
      created_by="sivakumar"
ENV REDIS_HOST="redis" \
    CATALOGUE_HOST="catalogue" \
    CATALOGUE_PORT="8080"
COPY --from=build --chown=roboshop:roboshop /opt/server /opt/server
USER roboshop
CMD ["server.js"]
ENTRYPOINT ["node"]