FROM node:22-alpine
WORKDIR /app

COPY chain/*.sol ./contracts/
COPY chain/deploy.js ./scripts/

RUN npm init -y && \
    npm pkg set type="module" && \
    npm install --save-dev hardhat && \
    npm install ethers

RUN printf 'export default {\n  solidity: "0.8.20"\n};\n' > hardhat.config.js
RUN npx hardhat compile
RUN printf '#!/bin/sh\necho \nnpx hardhat node --hostname 0.0.0.0 &\nNODE_PID=$!\necho \nsleep 5\necho \nnode scripts/deploy.js || echo "部署失败"\necho "運行中..."\nwait $NODE_PID\n' > start.sh && \
    chmod +x start.sh

EXPOSE 8545
CMD ["./start.sh"]