# https-server-proxy

This is reverse-proxy meant to run at 'the front' of live web server. It will:

* encrypt/decrypt https using TLS-certs (by default from LetsEncrypt)
* use version 2 of the http-protocol
* proxy applications using http version 1.0/1.1 (such as Express applications) so that they are served as http version 2.
* let you run one application per domain/sub-domain by pointing out the internal ports each domain should be proxied to
* allow redirects from one domain (or subdomain) to another. (For example if you want to redirect traffic from www.domain.com to domain.com - or vice versa.)
* enable you to use several certificates if necessary, 
* support web sockets.

### Install

```
npm install https-reverse-proxy
```

### Basic usage
Call **proxy** with the name of your certificate as the first argument and a mapping object between domains/subdomain-names and internal ports as your second argument. You can also choose to redirect one domain to another (see below).

```js
const proxy = require('https-reverse-proxy');

proxy('some.domain.org' /*cert name*/, {
  'some.domain.org': 3002,
  'domain.com': 3003,
  'www.domain.com': { redirect: "domain.com" }
});
```

(If you need to use several certificates then add another cert-name as argument 3, the mapping for domains in this certificate as argument 4 etc.)

### Settings
There are some settings you change by calling *proxy.settings()*, see the default values below):

```js
const proxy = require('https-reverse-proxy');

proxy.settings({
  httpPort: 80,
  httpsPort: 443,
  pathToCerts: '/etc/letsencrypt/live',
  xPoweredBy: 'Love'
});

proxy(/* see previous example */);
```

---

**Note:** The **cert name** is the name of a subfolder in the folder *pathToCerts* (default: */etc/letsencrypt/live*). Each cert folder must contain the two files *privkey.pem* and *fullchain.pem*. This is the standard for LetsEncrypt certificates obtained using **certbot**. (If you have obtained a certificate with different file names for the *pem*-files, then rename them.)