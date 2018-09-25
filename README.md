# EnrollChat

EnrollChat was designed to help college and department administrators cooordinate their efforts during the enrollment process. It accepts a feed of course section data and allows users to discuss individual sections. Users may choose which departments are of interest and how often they wish to receive updates. They may choose to be notified as relevant comments are posted or in digest form each day. They may also chooose to receive a weekly enrollment report.

## Roadmap

Enrollchat was developed by the College of Humanities and Social Sciences at George Mason University. It is currently tied to Mason's CAS server and is otherwise set up in ways that may not be useful outside Mason. Our first priority is to develop an automated import process, which in our case will be coming from Banner. Beyond that, our priority is to loosen ties, remove dependencies, and make EnrollChat as configurable as possible.

## Dependencies and Environment Variables

* Ruby 2.5.1
* PostgreSQL for the database
* Redis server (and RedisToGo)

The app presumes Heroku hosting and some development decisions reflect that presumption.

The app relies on environment variables for storing key configuration information.
* ENROLLCHAT_HOST - The core host address for the site, e.g. 'myapp.heroku.com'

Both the manual upload and the feed are dependent on Amazon S3 file storage, managed through Carrierwave. Your development and production environments will need to store these environment variables for S3:
* S3_BUCKET_NAME
* AWS_ACCESS_KEY_ID
* AWS_SECRET_ACCESS_KEY
* AWS_DEFAULT_REGION

Emails are dependent on SendGrid, which needs these environment variables.
* SENDGRID_USERNAME
* SENDGRID_PASSWORD

We are using CAS for logins.
* CAS_BASE_URL

For Redis:
* REDISTOGO_URL

For the rake-based feed, you will need to have a CSV file delivered to a directory on a server you can access via SFTP. This is dependent on these environmental variables:
* ENROLLCHAT_REMOTE: The server's address. E.g. "myserver.myhost.edu"
* ENROLLCHAT_REMOTE_DIR: The directory on that server. That directory should also contain a subdirectory named "backup."
* ENROLLCHAT_REMOTE_USER: Username.
* ENROLLCHAT_REMOTE_PASS: Password.
* ENROLLCHAT_ADMIN_EMAIL: The 'from' address for all emails.
* ENROLLCHAT_HOST: Actionmailer default url host.

We are tracking errors with AirBrake.
* AIRBRAKE_PROJECT_ID
* AIRBRAKE_PROJECT_KEY

Heroku will need these add-ons:
* Herokupostgres
* Redis To Go
* Heroku Scheduler (to schedule feed ingestion and removal of deleted terms)

## Getting Started Locally
* Clone the repository from Github and navigate into it.

George Mason's CAS server is used for authentication. To set up an initial user, replace the generic information in db/seeds with the information for the user you would like to have access. Additional users can be added from within the application.

* run `bin/setup`

Both the rails server and redis server need to be running locally.

## Scheduled Tasks

Administrators may mark all sections and comments in a term for deletion. Deleted sections and comments are immediately removed from consideration but are held in the database. The "purge_deleted" rake task deletes comments and sections one month after they are marked for deletion.

If you wish to ingest a feed automatically, you will need to set the ENROLLCHAT_ variables described above and you will need to run "import:retrieve_files" nightly.

## Feed Format

Administrators may manually upload sections in an xlsx file using the upload button on sections#index. See the sample file in docs/test for an example of the format.

## Testing

The app uses Rails' built in testing mechanisms. System Tests are configured to inherit from Capybara and run Selenium with headless Chrome. Chromedriver is required to use this setup and is included in the Gemfile.

To run tests: `bin/rails test`  
To run system tests: `bin/rails test:system`
To run all tests: `bin/rails test:system test`
