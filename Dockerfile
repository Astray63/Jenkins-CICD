
FROM node:18 as build
WORKDIR /app
COPY mon-projet-angular/ .
RUN npm install
RUN npm run build -- --configuration=production


FROM nginx:alpine
COPY --from=build /app/dist/ /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
