FROM --platform=linux/amd64 node:26-slim

LABEL "com.github.actions.name"="Puppeteer Headful"
LABEL "com.github.actions.description"="A GitHub Action / Docker image for Puppeteer, the Headful Chrome Node API"
LABEL "com.github.actions.icon"="layout"
LABEL "com.github.actions.color"="blue"

LABEL "repository"="https://github.com/mujo-code/puppeteer-headful"
LABEL "homepage"="https://github.com/mujo-code/puppeteer-headful"
LABEL "maintainer"="Jacob Lowe"

RUN apt-get update && apt-get install -y --no-install-recommends \
     gnupg \
     wget \
     xvfb \
     ca-certificates \
     equivs \
     && printf "Section: libs\nPriority: optional\nPackage: libasound2\nVersion: 2.0.0\nProvides: libasound2\nDescription: Dummy libasound2\n" > /tmp/libasound2.control \
     && equivs-build /tmp/libasound2.control \
     && dpkg -i libasound2_*.deb \
     && mkdir -p /etc/apt/keyrings \
     && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /etc/apt/keyrings/google-chrome.gpg \
     && echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list \
     && apt-get update \
     && apt-get install -y --no-install-recommends \
     google-chrome-stable \
     fonts-ipafont-gothic \
     fonts-wqy-zenhei \
     fonts-thai-tlwg \
     fonts-freefont-ttf \
     libxss1 \
     && rm -rf /var/lib/apt/lists/* /tmp/*

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/google-chrome-stable

COPY README.md /
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
