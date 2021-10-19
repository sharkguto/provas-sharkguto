#!/bin/bash

SCRIPTPATH="$(
    cd "$(dirname $0)"
    pwd -P
)"

echo "script is running at: $SCRIPTPATH"

if ! command -v awslocal &>/dev/null; then
    echo "nao tenho awslocal instalado"
    sudo python3 -m pip install localstack
    sudo python3 -m pip install awscli-local[ver1]
fi

RUNNING_LS=$(docker ps | grep -i localstack)

if [ -z "$RUNNING_LS" ]; then
    echo "Localstack not running... start it"
    ENTRYPOINT=-d LOCALSTACK_DATA_DIR=/tmp/localstack/data LOCALSTACK_SERVICES="ec2,s3,sqs,sns" localstack start --docker
fi

create_infra() {
    echo "criar buckets"
    awslocal s3api create-bucket --bucket lab-others
    awslocal s3api create-bucket --bucket lab-xml
    awslocal s3api create-bucket --bucket lab-json
    awslocal s3api create-bucket --bucket lab-txt

    echo "criar topicos"
    awslocal sns create-topic --name topico-arquivos
    awslocal sns create-topic --name topico-validacao-binario

    echo "criar filas"
    awslocal sqs create-queue --queue-name fila-arquivos
    awslocal sqs create-queue --queue-name fila-arquivos-binarios

    echo "dlq das filas criadas"
    awslocal sqs create-queue --queue-name fila-arquivos-binarios-dlq
    awslocal sqs create-queue --queue-name fila-arquivos-dlq

    echo "fazer a subscription das filas nos topicos"

    awslocal sns subscribe \
        --topic-arn arn:aws:sns:us-east-1:000000000000:topico-arquivos \
        --protocol sqs \
        --notification-endpoint arn:aws:sqs:us-east-1:000000000000:fila-arquivos

    awslocal sns subscribe \
        --topic-arn arn:aws:sns:us-east-1:000000000000:topico-validacao-binario \
        --protocol sqs \
        --notification-endpoint arn:aws:sqs:us-east-1:000000000000:fila-arquivos-binarios

    awslocal sns list-subscriptions-by-topic --topic-arn arn:aws:sns:us-east-1:000000000000:topico-arquivos
    awslocal sns list-subscriptions-by-topic --topic-arn arn:aws:sns:us-east-1:000000000000:topico-validacao-binario

    echo "setar atributos das filas, retençao 14 dias"

    cat <<EOF >set-queue-attributes.json
{
  "DelaySeconds": "0",
  "MaximumMessageSize": "262144",
  "MessageRetentionPeriod": "1209600",
  "ReceiveMessageWaitTimeSeconds": "1",
  "RedrivePolicy": "{\"deadLetterTargetArn\":\"arn:aws:sqs:us-east-1:000000000000:fila-arquivos-dlq\",\"maxReceiveCount\":\"2\"}",
  "VisibilityTimeout": "5"
}
EOF

    awslocal sqs set-queue-attributes \
        --queue-url http://localhost:4566/000000000000/fila-arquivos \
        --attributes file://set-queue-attributes.json

    cat <<EOF >set-queue-attributes.json
{
  "DelaySeconds": "0",
  "MaximumMessageSize": "262144",
  "MessageRetentionPeriod": "1209600",
  "ReceiveMessageWaitTimeSeconds": "1",
  "RedrivePolicy": "{\"deadLetterTargetArn\":\"arn:aws:sqs:us-east-1:000000000000:fila-arquivos-binarios-dlq\",\"maxReceiveCount\":\"2\"}",
  "VisibilityTimeout": "5"
}
EOF

    awslocal sqs set-queue-attributes \
        --queue-url http://localhost:4566/000000000000/fila-arquivos-binarios \
        --attributes file://set-queue-attributes.json

    echo "fazer o trigger dos arquivos que subirem nos buckets para notificar os topicos"

    cat <<EOF >set-notification-attr.json
{
  "TopicConfigurations": [
    {
      "TopicArn": "arn:aws:sns:us-east-1:000000000000:topico-arquivos",
      "Events": ["s3:ObjectCreated:*"]
    }
  ]
}
EOF

    awslocal s3api put-bucket-notification-configuration \
        --bucket "lab-json" \
        --notification-configuration file://set-notification-attr.json
    awslocal s3api get-bucket-notification-configuration --bucket "lab-json"

    echo "criar regras de filtro nos topicos de acordo com o nome do bucket"
    echo "xml,json ->sns:topico-arquivos e txt,others->topico-validacao-binario"

    #http://localhost:4566/000000000000/fila-arquivos

}

show_queues() {
    awslocal sqs get-queue-attributes --queue-url http://localhost:4566/000000000000/fila-arquivos-binarios --attribute-names All
    awslocal sqs get-queue-attributes --queue-url http://localhost:4566/000000000000/fila-arquivos-binarios-dlq --attribute-names All
    awslocal sqs get-queue-attributes --queue-url http://localhost:4566/000000000000/fila-arquivos --attribute-names All
    awslocal sqs get-queue-attributes --queue-url http://localhost:4566/000000000000/fila-arquivos-dlq --attribute-names All
}

create_infra

echo "listar filas "
awslocal sqs list-queues

echo "listar topicos "
awslocal sns list-topics

echo "listar buckets "
awslocal s3api list-buckets

#echo "descrição das filas"
#show_queues

echo "listar arquivos ?"
