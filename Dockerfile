FROM alpine:edge

WORKDIR /root

RUN apk add --update \
    git \
    nodejs npm \
    neovim ripgrep alpine-sdk \
    go python3
# Lot of deps are for lsp servers

COPY . /root/.config/nvim/

ENTRYPOINT [ "nvim" ]
