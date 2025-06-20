FROM ubuntu:24.04

# Set a predictable location for global npm packages
ENV NPM_CONFIG_PREFIX=/usr/local
# Ensure /usr/local/bin is in PATH for subsequent RUN commands and for the container
ENV PATH=${NPM_CONFIG_PREFIX}/bin:${PATH}

RUN apt update && apt install -y --no-install-recommends \
    wget \
    graphviz \
    make \
    default-jre \
    ruby \
    npm \
    && apt clean -y \
    && rm -rf /var/lib/apt/lists/*

RUN gem install asciidoctor \
    && gem install asciidoctor-pdf \
    && gem install asciidoctor-diagram 

RUN mkdir -p /usr/share/fonts/kaigen \
    && wget -O /usr/share/fonts/kaigen/KaiGenGothicJP-Regular.ttf https://github.com/chloerei/asciidoctor-pdf-cjk-kai_gen_gothic/releases/download/v0.1.0-fonts/KaiGenGothicJP-Regular.ttf \
    && wget -O /usr/share/fonts/kaigen/KaiGenGothicJP-Regular-Italic.ttf https://github.com/chloerei/asciidoctor-pdf-cjk-kai_gen_gothic/releases/download/v0.1.0-fonts/KaiGenGothicJP-Regular-Italic.ttf \
    && wget -O /usr/share/fonts/kaigen/KaiGenGothicJP-Bold.ttf https://github.com/chloerei/asciidoctor-pdf-cjk-kai_gen_gothic/releases/download/v0.1.0-fonts/KaiGenGothicJP-Bold.ttf \
    && wget -O /usr/share/fonts/kaigen/KaiGenGothicJP-Bold-Italic.ttf https://github.com/chloerei/asciidoctor-pdf-cjk-kai_gen_gothic/releases/download/v0.1.0-fonts/KaiGenGothicJP-Bold-Italic.ttf

RUN npm install -g @mermaid-js/mermaid-cli
RUN mkdir -p /usr/local/etc/mermaid && \
    echo '{"args": ["--no-sandbox"]}' > /usr/local/etc/mermaid/puppeteer-config.json && \
    mv "${NPM_CONFIG_PREFIX}/bin/mmdc" "${NPM_CONFIG_PREFIX}/bin/mmdc-original" && \
    printf '#!/bin/bash\n\nexec "%s/bin/mmdc-original" -p "/usr/local/etc/mermaid/puppeteer-config.json" "$@"\n' "${NPM_CONFIG_PREFIX}" > "${NPM_CONFIG_PREFIX}/bin/mmdc" && \
    chmod +x "${NPM_CONFIG_PREFIX}/bin/mmdc"

WORKDIR /docs

CMD ["/bin/bash"]
