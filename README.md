# cookly

- [Bitbucket Repository](https://bitbucket.org/alex0711/cookly/src/master/)
- [Bitrise CI Pipeline](https://app.bitrise.io/app/918ad19024d15f9e#/builds)

## Persistence

Firestore local cache for offline usage

## Web App Login

anonymous login: on each exit, delete the anonymous user => check if locally cached data stays, otherwise not feasible
first web login: encrypt a repositoryToken and store it. store the key locally

web login: app uploads encrypted key - web app sends key to encrypt in qr code and can therefore decrypt and then read the repositoryToken

- WebApp generates Session Token
- WebApp opens Socket with Session 
- WebApp displays QR Code with encoded Session Token
- Client Scans QR code
- Client connects to same Socket using the Session Token
- Client sends the profile data