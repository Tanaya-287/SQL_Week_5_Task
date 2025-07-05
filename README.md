# 🎓 Subject Allotment Tracker (SQL Stored Procedure)

This project helps colleges **track elective subject changes** by students over time. It uses SQL Server to manage a student's subject change history while keeping one subject marked as currently active.

> ✅ Useful for academic ERP systems to preserve audit trails of subject choices.

---

## 📌 Problem Statement

At the beginning of a semester, students often switch their elective subjects. The college wants to:

- Retain a full **history of changes** (not just the latest subject).
- Ensure **only one subject is marked active** at a time.
- Apply a new request **only if the requested subject is different** from the current active one.

---

## 🗃️ Tables Used

### 🔸 `SubjectAllotments`

| Column Name | Data Type | Description                      |
|-------------|-----------|----------------------------------|
| `StudentID` | `VARCHAR` | Unique identifier for student    |
| `SubjectID` | `VARCHAR` | Elective subject code            |
| `Is_valid`  | `BIT`     | `1` for current subject, `0` for past subjects |

---

### 🔸 `SubjectRequest`

| Column Name | Data Type | Description                     |
|-------------|-----------|---------------------------------|
| `StudentID` | `VARCHAR` | Student requesting change       |
| `SubjectID` | `VARCHAR` | Subject requested               |

---

## 🔁 Workflow Logic

The stored procedure processes all requests in `SubjectRequest`:

1. **If requested subject is different** from the currently active one:
   - Mark the current one (`Is_valid = 1`) as `0`
   - Insert the new one with `Is_valid = 1`

2. **If requested subject is the same** as current → do nothing.

3. **If the subject doesn't exist at all** in the allotments:
   - Insert it as valid
   - Invalidate the existing valid subject (if any)

---

## ⚙️ Stored Procedure: `UpdateSubjectAllotments`

A cursor is used to loop through `SubjectRequest`, and the logic above is applied to maintain a consistent and historical record.

---

## 🧪 How to Use

1. Clone the repository:

   ```bash
   git clone https://github.com/your-username/subject-allotment-sql.git
   cd subject-allotment-sql
   
2. Open SQL_week-5_Task.sql in SQL Server Management Studio or your preferred tool.

3. Run the script to:

Create tables

Insert sample data

Create and execute the stored procedure

View updated allotments

## 🛠️ Technologies
SQL Server

Stored Procedures

Cursors

Data Integrity Logic

## 📄 License
This project is open-source and available under the MIT License.
