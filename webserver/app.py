import jinja2 
import mysql.connector
import os

db_config = {
    'host': os.getenv('MYSQL_HOST'),
    'user': os.getenv('MYSQL_USER'),
    'password': os.getenv('MYSQL_PASS'),
    'database': os.getenv('MYSQL_DB'),
}

# Create an sql query and fetch all tables
def execute_query(query):
    connection = mysql.connector.connect(**db_config)
    cursor = connection.cursor()
    cursor.execute(query)
    table = cursor.fetchall()
    cursor.close()
    connection.close()
    columns = [description[0] for description in cursor.description]
    data = list()
    for entries in table:
        raw = dict()
        for idx,entry in enumerate(entries):
            raw[columns[idx]] = entry 
        data.append(raw)
    return columns, data

# Create a static html file to serve on web server
def render_template():
    query = '''
    SELECT c.Id AS Company_ID, c.Name AS Company_Name, a.Id AS Account_ID, a.Name AS Account_Name, p.Id AS Project_ID, p.Name as Project_Name, p.Status as Project_Status
    FROM As_company AS c join As_account AS a ON a.Company_id = c.Id
    join As_project AS p ON a.Id = p.Account_id'''
    columns, data = execute_query(query)
    template_dir = os.path.join(os.path.dirname(__file__), 'templates')
    env = jinja2.Environment(loader=jinja2.FileSystemLoader(template_dir))
    template = env.get_template('index.html')
    rendered_html = template.render(table=data,columns=columns)

    with open('index.html', 'w') as output_file:
        output_file.write(rendered_html)

if __name__ == '__main__':
    render_template()