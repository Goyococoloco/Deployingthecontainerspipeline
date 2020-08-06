FROM nginx

## 1.Step:
RUN rm /usr/share/nginx/html/index.html

## 2.Step:
## Copying the code to the working directory
COPY index.html /usr/share/nginx/html