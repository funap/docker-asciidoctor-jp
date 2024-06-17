ARG ERD_GOLANG_BUILDER_TAG=1.15-alpine
ARG A2S_GOLANG_BUILDER_TAG=1.20-alpine3.18
ARG alpine_version=3.20.0
FROM alpine:${alpine_version} AS base

FROM base AS main-minimal

ARG asciidoctor_version=2.0.23
ARG asciidoctor_pdf_version=2.3.17

ENV ASCIIDOCTOR_VERSION=${asciidoctor_version} \
    ASCIIDOCTOR_PDF_VERSION=${asciidoctor_pdf_version}
    
RUN apk add --no-cache ruby \
  && gem install --no-document \
  "asciidoctor:${ASCIIDOCTOR_VERSION}" \
  "asciidoctor-pdf:${ASCIIDOCTOR_PDF_VERSION}"

FROM golang:${ERD_GOLANG_BUILDER_TAG} as erd-builder
ARG ERD_VERSION=v2.0.0
RUN apk add --no-cache git \
  && git clone https://github.com/kaishuu0123/erd-go -b "${ERD_VERSION}" /app
WORKDIR /app
RUN CGO_ENABLED=0 GOOS=linux go build

FROM golang:${A2S_GOLANG_BUILDER_TAG} as a2s-builder
ARG A2S_VERSION=ca82a5c
RUN GOBIN=/app go install github.com/asciitosvg/asciitosvg/cmd/a2s@"${A2S_VERSION}"

FROM main-minimal AS main
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

ARG TARGETARCH

RUN apk add --no-cache \
  bash \
  curl \
  ca-certificates \
  findutils \
  font-bakoma-ttf \
  git \
  graphviz \
  inotify-tools \
  make \
  openjdk17-jre \
  python3 \
  py3-cairo \
  py3-setuptools \
  ruby-bigdecimal \
  # Required for asciidoctor-epub
  ruby-ffi \
  ruby-mathematical \
  ruby-rake \
  ttf-liberation \
  ttf-dejavu \
  tzdata \
  unzip \
  which \ 
  font-noto-cjk
 
ARG asciidoctor_confluence_version=0.0.2
ARG asciidoctor_diagram_version=2.3.0
ARG asciidoctor_epub3_version=2.1.3
ARG asciidoctor_fb2_version=0.7.0
ARG asciidoctor_mathematical_version=0.3.5
ARG asciidoctor_revealjs_version=5.1.0
ARG kramdown_asciidoc_version=2.1.0
ARG asciidoctor_bibtex_version=0.9.0
ARG asciidoctor_kroki_version=0.10.0
ARG asciidoctor_reducer_version=1.0.2

ENV ASCIIDOCTOR_CONFLUENCE_VERSION=${asciidoctor_confluence_version} \
  ASCIIDOCTOR_DIAGRAM_VERSION=${asciidoctor_diagram_version} \
  ASCIIDOCTOR_EPUB3_VERSION=${asciidoctor_epub3_version} \
  ASCIIDOCTOR_FB2_VERSION=${asciidoctor_fb2_version} \
  ASCIIDOCTOR_MATHEMATICAL_VERSION=${asciidoctor_mathematical_version} \
  ASCIIDOCTOR_REVEALJS_VERSION=${asciidoctor_revealjs_version} \
  KRAMDOWN_ASCIIDOC_VERSION=${kramdown_asciidoc_version} \
  ASCIIDOCTOR_BIBTEX_VERSION=${asciidoctor_bibtex_version} \
  ASCIIDOCTOR_KROKI_VERSION=${asciidoctor_kroki_version} \
  ASCIIDOCTOR_REDUCER_VERSION=${asciidoctor_reducer_version}

RUN apk add --no-cache --virtual .rubymakedepends \
  build-base \
  libxml2-dev \
  ruby-dev \
  && gem install --no-document \
  "asciidoctor-confluence:${ASCIIDOCTOR_CONFLUENCE_VERSION}" \
  "asciidoctor-diagram:${ASCIIDOCTOR_DIAGRAM_VERSION}" \
  "asciidoctor-epub3:${ASCIIDOCTOR_EPUB3_VERSION}" \
  "asciidoctor-fb2:${ASCIIDOCTOR_FB2_VERSION}" \
  "asciidoctor-mathematical:${ASCIIDOCTOR_MATHEMATICAL_VERSION}" \
  asciimath \
  "asciidoctor-revealjs:${ASCIIDOCTOR_REVEALJS_VERSION}" \
  coderay \
  epubcheck-ruby:4.2.4.0 \
  haml \
  "kramdown-asciidoc:${KRAMDOWN_ASCIIDOC_VERSION}" \
  pygments.rb \
  rouge \
  slim \
  thread_safe \
  tilt \
  text-hyphen \
  "asciidoctor-bibtex:${ASCIIDOCTOR_BIBTEX_VERSION}" \
  "asciidoctor-kroki:${ASCIIDOCTOR_KROKI_VERSION}" \
  "asciidoctor-reducer:${ASCIIDOCTOR_REDUCER_VERSION}" \
  && apk del -r --no-cache .rubymakedepends

ENV PIPX_HOME=/opt/pipx
ENV PIPX_BIN_DIR=/usr/local/bin
ENV PIPX_MAN_DIR=/usr/local/share/man

RUN apk add --no-cache \
    pipx \
    py3-pip \
  && apk add --no-cache --virtual .pythonmakedepends \
    build-base \
    freetype-dev \
    python3-dev \
    jpeg-dev \
  && for pipx_app in \
    actdiag \
    'blockdiag[pdf]' \
    nwdiag \
    seqdiag \
  ;do pipx install --system-site-packages --pip-args='--no-cache-dir' "${pipx_app}"; \
  pipx runpip "$(echo "$pipx_app" | cut -d'[' -f1)" install Pillow==9.5.0; done \
&& apk del -r --no-cache .pythonmakedepends

# 追加フォント
RUN mkdir -p /usr/share/fonts/kaigen \
  && wget -O /usr/share/fonts/kaigen/KaiGenGothicJP-Regular.ttf https://github.com/chloerei/asciidoctor-pdf-cjk-kai_gen_gothic/releases/download/v0.1.0-fonts/KaiGenGothicJP-Regular.ttf \
  && wget -O /usr/share/fonts/kaigen/KaiGenGothicJP-Regular-Italic.ttf https://github.com/chloerei/asciidoctor-pdf-cjk-kai_gen_gothic/releases/download/v0.1.0-fonts/KaiGenGothicJP-Regular-Italic.ttf \
  && wget -O /usr/share/fonts/kaigen/KaiGenGothicJP-Bold.ttf https://github.com/chloerei/asciidoctor-pdf-cjk-kai_gen_gothic/releases/download/v0.1.0-fonts/KaiGenGothicJP-Bold.ttf \
  && wget -O /usr/share/fonts/kaigen/KaiGenGothicJP-Bold-Italic.ttf https://github.com/chloerei/asciidoctor-pdf-cjk-kai_gen_gothic/releases/download/v0.1.0-fonts/KaiGenGothicJP-Bold-Italic.ttf \
  && fc-cache -f

COPY --from=a2s-builder /app/a2s /usr/local/bin/
COPY --from=erd-builder /app/erd-go /usr/local/bin/
RUN ln -snf /usr/local/bin/erd-go /usr/local/bin/erd

WORKDIR /docs

CMD ["/bin/bash"]