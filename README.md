# EnrollChat

Enrollchat accepts a feed of course section data and allows users to comment on individual sections. The feed may be uploaded manually as a CSV or XSLT file or brought in via a scheduled rake task.

## Dependencies

* Ruby 2.4.2
* PostgreSQL for the database
* Yarn for JS package management
* Redis server

The app presumes Heroku hosting and some development decisions reflect that presumption.

Both the manual upload and the feed are dependent on Amazon S3 file storage, managed through Carrierwave. Your development and production environments will need to store these environment variables for S3:
* S3_BUCKET_NAME
* AWS_ACCESS_KEY_ID
* AWS_SECRET_ACCESS_KEY

For the rake-based feed, you will need to have a CSV file delivered to a directory on a server you can access via SFTP. This is dependent on these environmental variables:
* ENROLLCHAT_REMOTE: The server's address. E.g. "myserver.myhost.edu"
* ENROLLCHAT_REMOTE_DIR: The directory on that server. That directory should also contain a subdirectory named "backup."
* ENROLLCHAT_REMOTE_USER: Username.
* ENROLLCHAT_REMOTE_PASS: Password.

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

The app uses Rails' built in testing mechanisms. System Tests are configured to inherit from Capybara and run Selenium with headless Chrome. The chromedriver is required to use this setup.

To run tests: `bin/rails test`  
To run system tests: `bin/rails test:system`
