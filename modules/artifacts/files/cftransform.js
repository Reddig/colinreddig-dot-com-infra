function handler(event) {
    var request = event.request;
    var uri = request.uri;

    // Don't rewrite files that already have an extension
    if (uri.includes('.')) {
        return request;
    }

    // Root is already /index.html
    if (uri === '/') {
        return request;
    }

    // /foo -> /foo.html
    request.uri = uri + '.html';

    return request;
}