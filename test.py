import os
import sys
import logging
import rds_config
import pymysql

#rds settings
rds_host = str(os.environ["DB_HOST"])
db_name = str(os.environ["DB_NAME"])
name = str(os.environ["DB_USER"])
password = rds_config.db_password

try:
    conn = pymysql.connect(rds_host, user=name, passwd=password, db=db_name, connect_timeout=5)
except pymysql.MySQLError as e:
    logger.error("ERROR: Unexpected error: Could not connect to MySQL instance.")
    logger.error(e)
    sys.exit()

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def handler(event, context):
    """
    This function fetches content from MySQL RDS instance
    """

    for item in os.environ:
        print(str(item) + ":" + str(os.environ[item]))



    logger.info("SUCCESS: Connection to RDS MySQL instance succeeded")
    item_count = 0

    with conn.cursor() as cur:
        cur.execute("create table Employee ( EmpID  int NOT NULL, Name varchar(255) NOT NULL, PRIMARY KEY (EmpID))")
        cur.execute('insert into Employee (EmpID, Name) values(1, "Joe")')
        cur.execute('insert into Employee (EmpID, Name) values(2, "Bob")')
        cur.execute('insert into Employee (EmpID, Name) values(3, "Mary")')
        conn.commit()
        cur.execute("select * from Employee")
        for row in cur:
            item_count += 1
            logger.info(row)
            #print(row)
    conn.commit()

    return "Added %d items from RDS MySQL table" %(item_count)