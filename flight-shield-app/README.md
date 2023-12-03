# flight-shield-app

## Folder Structure
```
.
└── flight-shield-app/
    ├── python_scripts # Scripts used to impute data and generate insert queries
    ├── src            # HTML code for our app
    ├── sql            # Stored procedures + Triggers SQL queries
    └── static         # Images etc.
```
### Link to [citations](citations.md)

## Setup
We have setup our project by following [this tutorial](https://billmartin.io/blog/how-to-build-and-deploy-a-nodejs-api-on-google-cloud)

For database authentication, you will need to create a `.env` file inside the `flight-shield-app` folder locally. To do this, execute the following from your terminal.
```
cd flight-shield-app
touch .env
```
And add the following lines to the `.env` file:
```
DB_HOST=<DB IP ADDRESS>
DB_NAME=<DB NAME>
DB_USER=<USER NAME>
DB_PASS=<PASSWORD>
INSTANCE_CONNECTION_NAME=<INSTANCE_CONNECTION_NAME>
```
Replace <...> with the corresponding values.

## Installing dependencies
Ensure that all the dependencies are installed locally by executing `npm install`.

## Running the app

To run the app, execute `npm run start`

Open a browser to [http://localhost:8080/](http://localhost:8080/).

## Deploying the app to GCP

To deploy the app to GCP, execute `npm run deploy`

To view the deployed app, execute `gcloud app browse`
