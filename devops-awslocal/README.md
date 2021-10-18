# Lab de awslocal

## commandos uteis

| o que faz                                    | command                                           |
| -------------------------------------------- | ------------------------------------------------- |
| cria bucket(pasta) para subir arquivos na s3 | awslocal s3api create-bucket --bucket bucket-name |

## exemplo de usar o `aws s3 cp`

```bash
[gustavo@manjaro devops-awslocal]$ awslocal s3 cp ./load.sh s3://lab-others/
upload: ./load.sh to s3://lab-others/load.sh
[gustavo@manjaro devops-awslocal]$ awslocal s3 ls s3://lab-others/
2021-10-18 15:29:16       1379 load.sh
[gustavo@manjaro devops-awslocal]$ awslocal s3 cp s3://lab-others/load.sh xpto.sh
download: s3://lab-others/load.sh to ./xpto.sh
[gustavo@manjaro devops-awslocal]$
```
