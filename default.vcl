vcl 4.0;

import std;

probe elc_probe {
    .window = 1;
    .threshold = 1;
}

backend default {
    .host = "app";
    .port = "5000";
    .probe = elc_probe;
}

backend failover {
    .host = "failover";
    .port = "80";
}

sub vcl_recv {
    unset req.http.Cookie;

    set req.backend_hint = failover;

    if(std.healthy(default)) {
        set req.http.X-Fetch = "1";
    }

    return (hash);
}

sub vcl_backend_response {
    set beresp.ttl = 10s;
    set beresp.grace = 6h;

    if(beresp.http.X-Failover == "1") {
        // send lower akamai edge cache control header
    }

    if (beresp.status == 500 || beresp.status == 502 || beresp.status == 503 || beresp.status == 504) {
        return (abandon);
    }

    return (deliver);
}

sub vcl_hash {
    # for testing only cache on path
    hash_data(req.url);
    return (lookup);
}
