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


create_infra(){
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

    echo "fazer o trigger dos arquivos que subirem nos buckets para notificar os topicos"

    echo "criar regras de filtro nos topicos de acordo com o nome do bucket"
    echo "xml,json ->sns:topico-arquivos e txt,others->topico-validacao-binario"
}

create_infra()

echo "listar filas "
awslocal sqs list-queues

echo "listar topicos "
awslocal sns list-topics

echo "listar buckets "
awslocal s3api list-buckets

echo "listar arquivos ?"
