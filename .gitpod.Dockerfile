FROM gitpod/workspace-full:latest

RUN curl -L https://foundry.paradigm.xyz | bash && \
    foundryup
