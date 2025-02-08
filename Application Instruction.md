# Golf Analytics Application Instruction

## Introduction
The **Golf Analytics Application** is a web-based application built using **Streamlit** that allows users to query and visualize **PGA Tour Golf Data** stored in a **MySQL database**. This guide provides a step-by-step explanation of how to use the application efficiently.


## Pre-requisites
### **Step 1: Python Libraries and Packages**
Ensure you have Python and the required libraries installed. Use the following command in your terminal:
```bash
pip install streamlit mysql-connector-python pandas plotly
```

### **Step 2: Database Setup**
Install MySQL/MySQLWorkBench and run golf_dbsetup_script.sql, a script that will:
- Establish database
- Create tables and schemas
- Load data

### **Step 3: Database and Interface Connection**
- Open Golf_SQL_Interface.py file, and update the placeholders in lines 8-15 with your own MySQL administration data.
- Save the file.

### **Step 4: Run the Application**
Execute the following command in your terminal:
```bash
streamlit run Golf_SQL_Interface.py
```

The application will launch in your default web browser.

---

## User Interface Overview
### **Sidebar Controls**
Located on the left, the sidebar allows users to:
- **Select a database table** from the dropdown menu to easily view the raw tables.
- **Run a custom SQL query**

### **Main Display**
- **Table Data Preview:** Displays the first 100 rows of the selected table.
- **Custom Query Results:** Displays query results in a structured table.
- **Dynamic Data Visualization:** Allows users to generate graphs based on query results and customized graph parameters.

---

## Using the Dashboard
### **1. Selecting a Table**
1. Navigate to the **sidebar**.
2. Click the dropdown menu under **Database Controls**.
3. Select a table (e.g., `Players`, `Tournaments`).
4. The first 100 rows of the selected table will appear in the main display.

### **2. Running a Custom SQL Query**
1. Scroll to **Run a Custom SQL Query** in the sidebar.
2. Enter your SQL query (e.g., `SELECT * FROM Players LIMIT 10;`).
3. Click **Run Query**.
4. The results will be displayed in the **Query Results** section.

### **3. Visualizing Data**
1. Once the query results are displayed, go to the **Visualization of Query Results** section.
2. Select an **X-axis** column from the dropdown.
3. Select one or more **Y-axis** columns.
4. Choose a **chart type** (Scatter, Line, Bar, Histogram).
5. The selected graph will be displayed dynamically.


---

## Troubleshooting
### **Database Connection Issues**
If the app fails to connect to MySQL:
- Ensure MySQL is running:
  ```bash
  sudo systemctl start mysql  # Linux/macOS
  net start mysql  # Windows
  ```
- Verify database credentials in the `connect_db()` function.

### **Slow Performance When Running Queries**
- Use `LIMIT` to restrict query results:
  ```sql
  SELECT * FROM Players LIMIT 50;
  ```


