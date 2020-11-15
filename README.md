# Cookza

## Links
- [Bitbucket Repository](https://bitbucket.org/alex0711/cookly/src/master/)
- [Bitrise CI Pipeline](https://app.bitrise.io/app/918ad19024d15f9e#/builds)

## Building the app

Run the following command to built an apk for ARM64
* flutter build apk --target-platform android-arm64 --split-per-abi

* Applied itermin patch due to ML Vision dependency issue: https://github.com/google/play-services-plugins/issues/153
Remove this once the dependency issue got fixed by the Firebase team.

## Run test coverage

* flutter test --coverage
* genhtml coverage/lcov.info --output-directory coverage

## Generating models

The following command generates models (annoted with @JsonSerializable) and internationalization (see lib/localization) constants.
* flutter pub run build_runner build --delete-conflicting-outputs

## Generating translations

Needed to generate for first run after checkout as the generated classes are not checked in.
* flutter gen-l10n

## Cloud Firestore Scheme

* don't directly use the DataProvider
* hide it behind a profile service
* which uses the data provider
* only return immutable model classes

abstract DataProvider
* FirebaseDataProvider
* LocalStorageDataProvider => don't implement, even for web view the firebase is needed hence, probably not really desired

views are being fed by streams of data so they directly react to changes occurring to the data
* then refactor all model names (e.g. no firebase prefix)

### Handshakes
* top level collection
* webClientUserID: The user ID of the browser app requesting a connection
* owner: user ID of the accepted owner
* creationTimestamp: Creation timestamp of this entry
* operatingSystem: The operating system of the web app
* browser: The browser being used by the web app
* repositoryID: The repositoryID the web app got permissions granted to

### RecipeCollection
* top level collection
* has an ID
* has a map of string <> userID, storing access details for users, e.g. member - 123, readonly - 1234, owner - 33456
* allows a user to be part of multiple recipe collections in the future

### Recipes
* top level collection
* each recipe has a reference to a recipe collection => enables access control based on the referenced document controls map
* stores details in subcollections => shallow requests don't read the subcollections, e.g. ingredients and instructions
* details: doc for instr and doc for ingredients => different subcollections due to subgoup queries!


### MealPlanCollection
* top level collection
* has an ID
* has a map of string <> userID, storing access details for users, e.g. member - 123, readonly - 1234, owner - 33456
* TODO: the meal plan should also sync the shopping list (e.g. crossed off items)

### MealPlans
* top level collection
* has an ID
* contains a subcollection mealPlanDateItems with the meal plan for specific dates
* has an array of used recipes
* each meal plan has a reference to a meal plan collection => access control

* if a user always has only a single meal plan...
* then A invites B
* the former meal plan of B would need to be deleted 
* B requires offer from A to delete it's own meal plan, but A needs to add B to it's meal plan..
* hence easier to have multiple meal plans and let the user delete the unused ones...?
* or a cloud function makes sure adding the user and deleting a meal plan is handled in a transaction?

// TODO:
recipes nicht als subcollection => sonst muss bei move von einer group in andere immer 3x delete + 3x add ausgeführt werden
=> als main collection wird nur das referenzfeld geändert mit einem merge update

## Web App Login

Anonymous user stays the same on same device and app => then use the user.id !

App:
* User is logged in anonymously with a generated id

Web:
* A new anonymous user is being generated
* listen on a new record with the content: web app user id, web app platform, initialization date
* QR code sends the document id the web app listens on

App:
* Scans QR code, reads the document id 
* on special collection add a reference to the handshake document (so we can display the current logins)
* if own repository is not yet online, upload it
* add an entry to the web app record with the repository id

Web:
* web app receives the record, and can then listen on the repository

App:
* on logoff, the web user id is being deleted from the authorized users list
* the handshake document is being deleted

Collection of Recipes:
* Identified by a generated ID
* app created firebase collection



anonymous login: on each exit, delete the anonymous user => check if locally cached data stays, otherwise not feasible
first web login: encrypt a repositoryToken and store it. store the key locally

web login: app uploads encrypted key - web app sends key to encrypt in qr code and can therefore decrypt and then read the repositoryToken

- WebApp generates Session Token
- WebApp opens Socket with Session 
- WebApp displays QR Code with encoded Session Token
- Client Scans QR code
- Client connects to same Socket using the Session Token
- Client sends the profile data