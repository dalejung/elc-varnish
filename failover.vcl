vcl 4.0;

backend default {
    .host = "app";
    .port = "5000";
}

sub vcl_recv {
    # remove port
    set req.http.Host = regsub(req.http.Host, ":[0-9]+", "");

    unset req.http.Cookie;
    if(req.http.X-Fetch == "1") {
        set req.hash_always_miss = true;
    }
    return (hash);
}

sub vcl_backend_response {
    set beresp.ttl = 24h;
    set beresp.grace = 6h;

    return (deliver);
}

sub vcl_deliver {
    set resp.http.X-Failover = "TRUE";

    return (deliver);
}

sub vcl_hash {
    # for testing only cache on path
    hash_data(req.url);
    return (lookup);
}
