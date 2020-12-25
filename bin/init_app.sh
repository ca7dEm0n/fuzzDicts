#! /bin/bash -x

sleep 1

token=e09d6153f1c15395397be3639d144794

## 管理后台
curl http://127.0.0.1:8888/api/mg/admin/routes/save -H "X-Api-Token: ${token}" -X POST -d '
{
    "key": "/api/mg/*",
    "protocol": "http",
    "remark": "",
    "prefix": "/api/mg/*",
    "service_name": "mg",
    "status": 1,
    "plugins": [
        "discovery",
        "tracing",
        "rewrite"
    ],
    "props": {
        "rewrite_url_regex": "^/api/mg/",
        "rewrite_replace": "/"
    }
}'

echo

curl http://127.0.0.1:8888/api/mg/admin/services/save -H "X-Api-Token: ${token}" -X POST -d '
{
    "key": "/mg/192.168.0.111:8010",
    "service_name": "mg",
    "upstream": "192.168.0.111:8010",
    "weight": 1,
    "status": 1
}'

echo

### job
curl http://127.0.0.1:8888/api/mg/admin/routes/save -H "X-Api-Token: ${token}" -X POST -d '
{
    "key": "/api/job/*",
    "protocol": "http",
    "remark": "",
    "prefix": "/api/job/*",
    "service_name": "job",
    "status": 1,
    "plugins": [
        "discovery",
        "tracing",
        "rewrite"
    ],
    "props": {
        "rewrite_url_regex": "^/api/job/",
        "rewrite_replace": "/"
    }
}'

echo

curl http://127.0.0.1:8888/api/mg/admin/services/save -H "X-Api-Token: ${token}" -X POST -d '
{
    "key": "/job/pjob-control-api:9100",
    "service_name": "job",
    "upstream": "pjob-control-api:9100",
    "weight": 1,
    "status": 1
}'

echo
