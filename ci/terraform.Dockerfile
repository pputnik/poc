FROM hashicorp/terraform:0.12.29

ENV kubectl_url="https://amazon-eks.s3.us-west-2.amazonaws.com/1.17.7/2020-07-08/bin/linux/amd64/kubectl"

RUN apk add --no-cache aws-cli openssh-client curl bash jq mysql
RUN addgroup -S ci -g 1000 && adduser -S ci-user -u 1000 -G ci
RUN curl -s -o kubectl ${kubectl_url} \
        && chmod +x kubectl \
        && mv kubectl /bin/kubectl
USER ci-user
ENTRYPOINT ["/bin/sh", "-c"]
CMD [""]