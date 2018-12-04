# Neo4j Backup to Google Cloud Storage (GCS)
This repository contains a simple bash script for backing up and uploading a Neo4j database to a Google Cloud Storage bucket.

## Dependencies
This script requires the following:

* [neo4j-admin](https://neo4j.com/docs/operations-manual/current/tools/neo4j-admin/)
    * Installs by default with neo4j
* [gsutil Tool](https://cloud.google.com/storage/docs/gsutil)
    * Comes by default on Google Compute Engine instances (VMs)
    * Needs to be initialized and have access to write to the bucket

### Permission Notes
When specifiying the bucket in the script config, the account associated with the `gsutil` tool, and the VM itself, need to have permissions to write to the bucket. See [this gist](https://gist.github.com/ryderdamen/926518ddddd46dd4c8c2e4ef5167243d) for more details.

## Installation
Copy this script to your virtual machine in a known location. It's likely a good idea to have this script run under the `neo4j` user, in case you encounter any permissions issues (like TLS certificates from certbot).

Next, set up environment variables.

*Required Variables* 
```bash
# The base directory to upload to (your bucket name, and any subdirectories)
EXPORT NEO4J_GCS_UPLOAD_BUCKET=mybucket/subdirectory/
```

*Optional Variables*
```bash
# The local path to store your backup at before uploading
EXPORT NEO4J_GCS_LOCAL_PATH=/tmp/
```

*NOTE*
For persistance of these variables with system reboot, consider adding them to `/etc/environment` file, so that uploads continue even if there is a power loss.

You can do this like so:
```bash
nano /etc/environment

# Then add the following line and save the file
NEO4J_GCS_UPLOAD_BUCKET=mybucket/subdirectory/
```
Then logout and login to set this variable.

## Cron Config
Once environment variables are set, add the required lines to the crontab to schedule exports and uploads.

```bash
# We likely want to be the neo4j user, to prevent permissions problems
sudo su - neo4j
crontab -e

# Every day at 11:00 PM, backup and upload the graph to GCS
0 23 * * * bash /path/to/neo4j_backup_to_gcs.sh
```
