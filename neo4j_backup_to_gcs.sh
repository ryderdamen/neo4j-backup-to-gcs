# This script backs up a Neo4J Database to Google Cloud Storage
# Dependencies: initialized gsutil / gcloud command line tool with storage bucket write access, neo4j

# Notes:
# * Add `bash /path/to/neo4j-backup-to-cloud.sh` to crontab to easily schedule backups
# * Edit variables in CONFIG section to personalize and change backup schema names
# * May need to run as root if you have private TLS keys, or as user with read access to keys (neo4j user)


# CONFIG **************************************
backup_name=neo4j-backup-$(date +"%Y-%m-%d--%H-%M")
backup_local_path=${NEO4J_GCS_LOCAL_PATH:-"/tmp/"}
backup_bucket_name=${NEO4J_GCS_UPLOAD_BUCKET}


if [ -z ${NEO4J_GCS_UPLOAD_BUCKET+x} ];
then echo "ERROR - Please set the NEO4J_GCS_UPLOAD_BUCKET environment variable" && exit 1;
fi


# Backup and upload
neo4j-admin backup --backup-dir ${backup_local_path} --name ${backup_name}
gsutil -m cp -r ${backup_local_path}/${backup_name} gs://${backup_bucket_name%/}/${backup_name}
