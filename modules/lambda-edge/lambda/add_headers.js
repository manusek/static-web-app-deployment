'use strict';

exports.handler = (event, context, callback) => {
    const response = event.Records[0].cf.response;
    const headers = response.headers;

    // Dodawanie nagłówków bezpieczeństwa
    headers['strict-transport-security'] = [
        { key: 'Strict-Transport-Security', value: 'max-age=63072000; includeSubDomains; preload' }
    ];
    headers['x-content-type-options'] = [
        { key: 'X-Content-Type-Options', value: 'nosniff' }
    ];
    headers['x-xss-protection'] = [
        { key: 'X-XSS-Protection', value: '1; mode=block' }
    ];
    headers['x-frame-options'] = [
        { key: 'X-Frame-Options', value: 'DENY' }
    ];

    // Zwrócenie odpowiedzi do CloudFront
    callback(null, response);
};