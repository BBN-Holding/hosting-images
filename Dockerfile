FROM denoland/deno:latest
WORKDIR /app

COPY . .

RUN deno compile -A --output imagepusher index.ts

CMD ["/imagepusher"]