# PGA Tour Golf Data (2015-2022)

## Introduction
This project provides a comprehensive **PGA Tour Golf Data** dataset covering the years **2015 to 2022**. The database consolidates information about **players, tournaments, scores, and performance metrics**, making it easier for users to access and analyze historical and current data.

### Key Features
- **Enhanced Fan Engagement**: Users can explore detailed statistics such as **player rankings, performance trends, and tournament histories**.
- **Comprehensive Querying & Analysis**: Analysts and fantasy sports enthusiasts can track and analyze **PGA tournament information**.
- **Interactive Web Application**: A **MySQL Interactive Dashboard** built with **Streamlit** allows users to query and visualize PGA Tour data dynamically.

---

## Database Design
This project includes an SQL database named **golf**, structured with five main tables: **Players, Tournaments, TournamentParticipation, PerformanceStats, and Financials**.

### **Tables & Attributes**
#### **1. Players**
- `player_id` (INT, PRIMARY KEY) - Unique identifier for each player.
- `player_name` (VARCHAR(100)) - Name of the player.

#### **2. Tournaments**
- `tournament_id` (INT, PRIMARY KEY) - Unique identifier for each tournament.
- `season` (INT) - Season year of the tournament.
- `purse` (DECIMAL(10,2)) - Total prize money available.
- `no_cut` (BOOLEAN) - Indicates if the tournament has a cut or not.

#### **3. TournamentParticipation (Bridge Table)**
- `tournament_id` (INT, FOREIGN KEY → Tournaments)
- `player_id` (INT, FOREIGN KEY → Players)
- `Finish` (VARCHAR(10)) - Player's finishing position.
- `sg_putt, sg_arg, sg_app, sg_ott, sg_t2g, sg_total` (DECIMAL(5,2)) - Strokes gained statistics.
- **Primary Key:** (`tournament_id`, `player_id`)

#### **4. PerformanceStats**
- `tournament_id` (INT, FOREIGN KEY → Tournaments)
- `player_id` (INT, FOREIGN KEY → Players)
- `hole_par` (INT) - Par value for a given hole.
- `strokes` (INT) - Number of strokes taken by the player.
- `hole_DKP, hole_FDP, hole_SDP` (DECIMAL(5,2)) - Fantasy performance metrics.
- `streak_BIR, streak_BIR_3, streak_BIR_4, streak_BIR_5, streak_BIR_6` (BOOLEAN) - Birdie streak indicators.
- **Primary Key:** (`tournament_id`, `player_id`, `hole_par`)

#### **5. Financials**
- `tournament_id` (INT, FOREIGN KEY → Tournaments)
- `player_id` (INT, FOREIGN KEY → Players)
- `purse` (DECIMAL(10,2)) - Prize money earned by the player.
- `season` (INT, FOREIGN KEY → year)
- **Primary Key:** (`tournament_id`, `player_id`)

### **Relationships**
- **Players ↔ TournamentParticipation** (*Many-to-Many*)
- **Tournaments ↔ TournamentParticipation** (*Many-to-Many*)
- **Players & Tournaments ↔ PerformanceStats** (*Many-to-Many with Additional Data*)
- **Players & Tournaments ↔ Financials** (*One-to-Many*)

---

## 🖥️ Application Implementation
The project features a **MySQL Interactive Dashboard** built with **Streamlit** to enable dynamic querying and visualization of PGA Tour data.

### **Features**
- **Custom SQL Querying**: Users can enter and execute SQL queries interactively.
- **Preloaded Table View**: View any table instantly to prepare for **JOIN queries**.
- **Data Visualization**: Users can customize visualization for their own query results based on easy parameters selection **x-axis, y-axis, and graph type**.
- **Performance Metrics & Fantasy Points**: Detailed statistics for each player.

---

## Challenges & Solutions
### **Database Connection Issues**
**Problem**: Initial failures in establishing communication between **Streamlit** and **MySQL**.
-- **Solution**:
- Ensured **MySQL server was running**:
  ```bash
  sudo systemctl status mysql  # Linux/macOS
  net start mysql  # Windows
  ```
- Verified **credentials (host, user, password, database)** in `connect_db()`.

### **Query Performance Issues**
**Problem**: Running queries like `SELECT * FROM Players;` resulted in slow loading.
**Solution**:
- Used `LIMIT` to restrict query results:
  ```sql
  SELECT * FROM Players LIMIT 50;
  ```

---

## 👥 Individual Contributions
- **Xiang Gu**: Project Proposal, SQL Queries, Final Report
- **Cheng Tso Hsieh**: Data Collection, Database Design, Web Application Development, Final Report
- **Zhuoning Zhang**: Data Collection, SQL Queries, Project Proposal (Title, Team Members, Tech Stack)

---


