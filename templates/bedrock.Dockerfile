FROM --platform=linux/amd64 debian AS builder
WORKDIR /build
ARG VERSION
ADD https://minecraft.azureedge.net/bin-linux/bedrock-server-$VERSION.zip bedrock.zip

RUN apt update && apt install -y unzip
RUN unzip bedrock.zip
RUN rm -rf bedrock.zip bedrock_server_*
RUN mkdir user-folder

RUN mv allowlist.json user-folder/
RUN mv permissions.json user-folder/
RUN mv server.properties user-folder/

RUN ln -s user-folder/allowlist.json allowlist.json
RUN ln -s user-folder/permissions.json permissions.json
RUN ln -s user-folder/server.properties server.properties
RUN chmod +x bedrock_server

# Make the final image
FROM --platform=linux/amd64 debian:12-slim

COPY --from=builder /build /app
WORKDIR /app
ENV LD_LIBRARY_PATH .

RUN apt update && apt install curl -y

CMD ./bedrock_server
