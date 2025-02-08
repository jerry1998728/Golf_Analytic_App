
# Importing installed packages\import streamlit as st
import mysql.connector
import pandas as pd
import plotly.express as px
import streamlit as st

# Function to establish MySQL database connection
def connect_db():
    return mysql.connector.connect(
        host="###.#.#.#",
        user="root", 
        password="###########", 
        database="golf"
        )

# Function to execute SQL queries
def run_query(query):
    #set database connection to None
    conn = None
    try:
        # Connect database
        conn = connect_db()
        cursor = conn.cursor(dictionary=True)
        # Execute user query
        cursor.execute(query)
        data = cursor.fetchall()
        # Return result in dataframe
        return pd.DataFrame(data)
    except Exception as e:
        # Error message
        st.error(f"Error executing query: {e}")
        return pd.DataFrame()
    finally:
        if conn:
            conn.close()

# Streamlit UI
st.set_page_config(page_title="PGA Tour Analytics", layout="wide")

st.title("PGA Tour Analytics")

# Sidebar: Select a Table to Query
st.sidebar.header("Database Controls")
# Table Names
tables = ["Players", "Tournaments", "TournamentParticipation", "PerformanceStats", "Financials"] 
# Dropdown for table selection
selected_table = st.sidebar.selectbox("Select a Table", tables)

# Session state to persist query results
if "query_results" not in st.session_state:
    st.session_state.query_results = None

# Display Data from the Selected Table
st.subheader(f"📋 Data from {selected_table}")
df = run_query(f"SELECT * FROM {selected_table} LIMIT 100")
st.dataframe(df)

# Custom SQL Querying
st.sidebar.subheader("Run a Custom SQL Query")
# User query input box
query_input = st.sidebar.text_area("Enter SQL Query", f"SELECT * FROM {selected_table} LIMIT 10")
# User query execution button
query_button = st.sidebar.button("Run Query")

# Run query and store results in session state
if query_button:
    st.session_state.query_results = run_query(query_input)

# Display stored query results if available
if st.session_state.query_results is not None and not st.session_state.query_results.empty:
    st.subheader("🔍 Query Results")
    st.dataframe(st.session_state.query_results)

    # Dynamic Data Visualization
    st.subheader("📊 Visualization of Query Results")
    all_columns = list(st.session_state.query_results.columns)
    # X-axis selection
    x_axis = st.selectbox("Select X-Axis", all_columns, index=0, key='x_axis')
    # Y-axis selection
    y_axis = st.multiselect("Select Y-Axis", all_columns, default=[all_columns[1]] if len(all_columns) > 1 else [all_columns[0]], key='y_axis')
    # Chart type selection
    chart_type = st.selectbox("Select Chart Type", ["Scatter", "Line", "Bar", "Histogram"], key='chart_type')

    # Generate the selected visualization
    if chart_type == "Scatter":
        fig = px.scatter(st.session_state.query_results, x=x_axis, y=y_axis, title="Scatter Plot")
    elif chart_type == "Line":
        fig = px.line(st.session_state.query_results, x=x_axis, y=y_axis, title="Line Chart")
    elif chart_type == "Bar":
        fig = px.bar(st.session_state.query_results, x=x_axis, y=y_axis, title="Bar Chart")
    elif chart_type == "Histogram":
        fig = px.histogram(st.session_state.query_results, x=x_axis, title="Histogram")

    #plot the chart
    st.plotly_chart(fig)

st.sidebar.info("Use this dashboard to query and visualize your MySQL data interactively!")
