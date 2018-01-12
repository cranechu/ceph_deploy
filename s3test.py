import boto.s3.connection

access_key = '937DQHQ522JRX9X0C6AC'
secret_key = 'cMNrtyGgyyNSDZiN2tiI0E9UiNhBpvNX8C8M0FoS'
conn = boto.connect_s3(
        aws_access_key_id=access_key,
        aws_secret_access_key=secret_key,
        host='mon0', port=7480,
        is_secure=False, calling_format=boto.s3.connection.OrdinaryCallingFormat(),
       )

bucket = conn.create_bucket('my-new-bucket2')
for bucket in conn.get_all_buckets():
    print "{name} {created}".format(
        name=bucket.name,
        created=bucket.creation_date,
    )
