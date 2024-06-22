# ベースイメージとして公式のUbuntuイメージを使用
FROM ubuntu:24.04

RUN apt update && apt install -y \
    wget \
    curl \
    git \
    graphviz \
    make \
    default-jre \
    ruby \
    ruby-dev \
    build-essential \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

RUN gem install asciidoctor \
    && gem install asciidoctor-pdf \
    && gem install asciidoctor-diagram 

RUN mkdir -p /usr/share/fonts/kaigen \
    && wget -O /usr/share/fonts/kaigen/KaiGenGothicJP-Regular.ttf https://github.com/chloerei/asciidoctor-pdf-cjk-kai_gen_gothic/releases/download/v0.1.0-fonts/KaiGenGothicJP-Regular.ttf \
    && wget -O /usr/share/fonts/kaigen/KaiGenGothicJP-Regular-Italic.ttf https://github.com/chloerei/asciidoctor-pdf-cjk-kai_gen_gothic/releases/download/v0.1.0-fonts/KaiGenGothicJP-Regular-Italic.ttf \
    && wget -O /usr/share/fonts/kaigen/KaiGenGothicJP-Bold.ttf https://github.com/chloerei/asciidoctor-pdf-cjk-kai_gen_gothic/releases/download/v0.1.0-fonts/KaiGenGothicJP-Bold.ttf \
    && wget -O /usr/share/fonts/kaigen/KaiGenGothicJP-Bold-Italic.ttf https://github.com/chloerei/asciidoctor-pdf-cjk-kai_gen_gothic/releases/download/v0.1.0-fonts/KaiGenGothicJP-Bold-Italic.ttf

WORKDIR /docs

CMD ["/bin/bash"]
