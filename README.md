# EnrollChat

![tests](https://github.com/chss-it/enrollchat/workflows/test_suite/badge.svg) ![rubocop](https://github.com/chss-it/enrollchat/workflows/rubocop/badge.svg) ![security](https://github.com/chss-it/enrollchat/workflows/brakeman/badge.svg)

EnrollChat was designed to help college and department administrators cooordinate their efforts during the enrollment process. It accepts a feed of course section data and allows users to discuss individual sections. Users may choose which departments are of interest and how often they wish to receive updates. They may choose to be notified as relevant comments are posted or in digest form each day. They may also chooose to receive a weekly enrollment report.

## Roadmap

Enrollchat was developed by the College of Humanities and Social Sciences at George Mason University. It is currently tied to Mason's CAS server and is otherwise set up in ways that may not be useful outside Mason. Our first priority is to develop an automated import process, which in our case will be coming from Banner. Beyond that, our priority is to loosen ties, remove dependencies, and make EnrollChat as configurable as possible.

## Dependencies and Environment Variables

* Ruby 3.3.10
* PostgreSQL for the database
* Redis server (and Heroku Redis)

The app presumes Heroku hosting and some development decisions reflect that presumption.

The app relies on environment variables for storing key configuration information.
* ENROLLCHAT_HOST - The core host address for the site, e.g. 'myapp.heroku.com'

Both the manual upload and the feed are dependent on Amazon S3 file storage, managed through Carrierwave. Your development and production environments will need to store these environment variables for S3:
* S3_BUCKET_NAME
* AWS_ACCESS_KEY_ID
* AWS_SECRET_ACCESS_KEY
* AWS_DEFAULT_REGION

Emails are dependent on SendGrid, which needs these environment variables:
* SENDGRID_API_USER
* SENDGRID_API_KEY

We are using CAS for logins:
* CAS_BASE_URL

For Redis:
* REDIS_URL

For the rake-based feed, you will need to have a CSV file delivered to a location that you can access, such as a server you can reach via SFTP or an S3 bucket. The task is currently constructed to use an S3 bucket. This is dependent on these environmental variables:
* ENROLLCHAT_REMOTE: The remote location's name or address. E.g. "myserver.myhost.edu" or "my_bucket"
* ENROLLCHAT_REMOTE_USER: Username.
* ENROLLCHAT_REMOTE_PASS: Password.
* ENROLLCHAT_ADMIN_EMAIL: The 'from' address for all emails.
* ENROLLCHAT_HOST: Actionmailer default url host.
* ENROLLMENT_FILE_NAME: The name of the stored enrollment file.

Additional environment variables can be added depending on your needs. E.g. server directory path

We are tracking errors with Insight Hub (formerly Bugsnag).
* BUGSNAG_API_KEY

We have a backup task that uses S3 storage:  
(In addition to AWS_ variables described above)  
* FILE_BACKUP_NAME  
* S3_BACKUP_BUCKET_NAME

We have a task for restoring the development database from production using Heroku's CLI commands:  
* DATABASE_COMMAND

Heroku will need these add-ons:
* Herokupostgres
* Heroku Redis
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

Administrators may manually upload sections in an xlsx file using the upload button on sections#index.

## Email Delivery Configuration

Digest and Report emails are sent to users based on their email preferences. These emails may only be relevant during specific times of the academic year. There are three configuration settings available to control the delivery of these emails:
- :scheduled - emails will only be sent during predefined windows. The terms ranges for the scheduled windows can be set with the following environment variables:  
    `term_one_start`  
    `term_one_end`  
    `term_two_start`  
    `term_two_end`  
Additional variables can be added to accommodate different academic calender structures.  
- :on - emails will be sent on their regular schedule throughout the year
- :off - emails will not be sent

## Marketing Feed

An optional feed of marketing related data can be configured. The application settings allows the configuration of a data feed uri. This uri is used in the `marketing_info` rake task. This task is fairly specific but could be modified to work with specific data feeds and formats. One of the attributes it currently injests are campus codes. If there is a need to display specific labels for campus codes, those can be configured using the following environment variable pattern:
    `CAMPUS_CODE_ONE`
    `CAMPUS_LABEL_ONE`
    `CAMPUS_CODE_TWO`
    `CAMPUS_LABEL_TWO`

These apply specifically to the `campus_label` method in the Section model. Currently, up to 11 codes and 9 labels can be used.

## Testing

The app uses Rails' built in testing mechanisms. System Tests are configured to inherit from Capybara and run Selenium with headless Chrome. Chromedriver is required to use this setup. The selenium-webdriver gem is included to provide installation and support for chromedriver.

To run tests: `bin/rails test`  
To run system tests: `bin/rails test:system`  
To run all tests: `bin/rails test:all`
