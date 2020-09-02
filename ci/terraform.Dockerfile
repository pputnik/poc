FROM hashicorp/terraform:0.12.29

ENV kubectl_url="https://amazon-eks.s3.us-west-2.amazonaws.com/1.17.7/2020-07-08/bin/linux/amd64/kubectl"

RUN apk update
RUN apk add --no-cache aws-cli openssh-client curl bash jq mysql-client
RUN addgroup -S ci -g 1000 && adduser -S ci-user -u 1000 -G ci
USER ci-user
ENTRYPOINT ["/bin/sh", "-c"]
CMD [""]