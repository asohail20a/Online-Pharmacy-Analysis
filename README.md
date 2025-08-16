# 📊 Online Pharmacy Analytics Case Study

## 📌 Overview
This project analyzes an **online pharmacy dataset** to extract actionable business insights.  
The case study consists of two parts:
1. **SQL Assessment** → Writing queries to extract KPIs & insights from relational tables.  
2. **Tableau Assessment** → Building an interactive dashboard to visualize results and support decision-making.  

The analysis covers **Orders, Products, and Pharmacies performance**.

---

## 📂 Project Structure
```
📁 Project Folder
 ┣ 📄 README.md              # Project documentation
 ┣ 📄 SQL_Assessment.sql        # SQL scripts used for analysis
 ┣ 📊 Tableau_Project.twbx # Tableau packaged workbook
 ┗ 📄 Data                  # Dataset files (Excel / DB extracts)
```

---

## 🗂 Dataset Description
The dataset contains multiple relational tables:

- **Orders** → Information about each order (OrderId, CreatedOn, OrderSource, PharmacyKey, OrderValue…).  
- **OrderItems** → Products included in each order (ProductKey, Quantity, Price).  
- **Pharmacies** → Information about pharmacies (PharmacyKey, PharmacyName).  
- **OrderStates** → Timeline of order states with timestamps (Accepted, Delivered, Rejected…).  
- **OrderStateTypes** → Lookup table for state names.

---

## 🧮 SQL Assessment

### **Orders Analysis**
- ✅ Total number of orders  
- ✅ Orders by source (ranked)  
- ✅ Overall fulfilment rate (Delivered / Total)  
- ✅ Monthly average order value  
- ✅ Scheduled orders & fulfilment rate  
- ✅ Top 3 reasons for unfulfilled orders (with percentages)

### **Products Analysis**
- ✅ Top 5 products by number of orders  
- ✅ Top 5 products by total sales value  

### **Pharmacies Analysis**
- ✅ Top 5 pharmacies by number of orders  
- ✅ Top 5 pharmacies by fulfilment rate  
- ✅ Total sales value per pharmacy  
- ✅ Customer time = time between order creation and last state  
- ✅ Delivery time = time between "Accepted" and "Delivered"  
- ✅ Top 5 order states before rejection  

👉 All queries are included in: `SQL_Assessment.sql`

---

## 📊 Tableau Assessment

### **Dashboard KPIs**
- 📌 **Total Orders**  
- 📌 **Fulfilment Rate**  
- 📌 **Total Sales Value**  
- 📌 **Top Pharmacies** (by orders & fulfilment)  
- 📌 **Top Products** (by orders & sales)  
- 📌 **Monthly Trends** (orders, sales)  
- 📌 **Three different Order Sources**  

### **Design**
- **Top section (KPIs):** Total Orders | Fulfilment Rate | Sales Value  
- **Middle section (Performance):** Column charts for Top Pharmacies & Top Products  
- **Bottom section (Trends & Insights):** Line chart for monthly performance + Pie chart for order sources

👉 Dashboard file: `Tableau_Project.twbx`
👉 ![Dashboard Preview](Screenshot%202025-08-15%20233919.png)

---

## 🔑 Key Insights
- The overall fulfilment rate = **47%**  
- Top 5 pharmacies contribute to **38% of total orders**  
- Top 5 products generate **42% of total sales value**  
- Average order value shows an increasing/decreasing trend month over month  
- The most common rejection reasons are **[Rejected By Pharmacy, Canceled, Rejected By Vezeeta]**

---

## 📌 Tools & Technologies
- **SQL Server** → Data extraction & KPI calculation  
- **Tableau** → Visualization & storytelling  
- **Git/GitHub** → Version control  

---

## 📧 Author
**Sohail Ali**  
📩 sohailelkashef99@gmail.com 
🔗 [https://www.linkedin.com/in/sohail-ali13](#)
