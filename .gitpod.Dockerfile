FROM gitpod/workspace-full:latest

RUN curl -L https://foundry.paradigm.xyz | bash && \
    /home/gitpod/.foundry/bin/foundryup
