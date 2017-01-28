vcl 4.0;

backend default {
    .host = "app";
    .port = "5000";
}

sub vcl_recv {
    unset req.http.Cookie;
    return (hash);
}

sub vcl_backend_response {
     set beresp.ttl = 5s; # Important, you shouldn't rely on this, SET YOUR HEADERS in the backend

    # Allow stale content, in case the backend goes down.
    # make Varnish keep all objects for 6 hours beyond their TTL
    set beresp.grace = 6h;

    return (deliver);
}

sub vcl_hit {
    return (deliver);
}
