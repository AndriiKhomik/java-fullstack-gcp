import http from 'k6/http'
import { sleep, check } from 'k6'

export let options = {
    vus: 40,
    duration: '60s',
    thresholds: {
        http_req_duration: ['p(95)<500'], // 95% of requests should be below 500ms
    },
    ext: {
        loadimpact: {
            name: "Load test",
        },
        prometheus: {
            url: 'http://35.228.111.248:9090/api/v1/write',
            push_interval: '1s', // Interval to push metrics
        }
    },
}

export default function () {
    let url = 'http://35.228.204.198:80'

    let response = http.get(url)

    check(response, {
        'status is 200': (r) => r.status === 200,
        'transaction time ok': (r) => r.timings.duration < 2000
    })

    sleep(1)
}