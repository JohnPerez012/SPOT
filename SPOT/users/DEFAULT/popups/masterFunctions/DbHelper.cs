using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace SPOT.users.DEFAULT.popups.masterFunctions
{
    public static class DbHelper
    {
        public static int GetPrimaryKeyValue(string tableName, string conditionColumn = null, object conditionValue = null)
        {
            string connStr = ConfigurationManager.ConnectionStrings["LogsDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // Get primary key column dynamically
                string getPkQuery = @"SELECT COLUMN_NAME 
                                      FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE 
                                      WHERE OBJECTPROPERTY(OBJECT_ID(CONSTRAINT_SCHEMA + '.' + QUOTENAME(CONSTRAINT_NAME)), 'IsPrimaryKey') = 1 
                                      AND TABLE_NAME = @TableName";

                string primaryKeyColumn = null;

                using (SqlCommand cmd = new SqlCommand(getPkQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@TableName", tableName);
                    object pkResult = cmd.ExecuteScalar();
                    if (pkResult == null) return 0;
                    primaryKeyColumn = pkResult.ToString();
                }

                // Build query to get latest or condition-based PK value
                string selectQuery = $"SELECT TOP 1 {primaryKeyColumn} FROM {tableName}";

                if (!string.IsNullOrEmpty(conditionColumn))
                {
                    selectQuery += $" WHERE {conditionColumn} = @ConditionValue";
                }

                selectQuery += $" ORDER BY {primaryKeyColumn} DESC";

                using (SqlCommand cmd = new SqlCommand(selectQuery, conn))
                {
                    if (!string.IsNullOrEmpty(conditionColumn) && conditionValue != null)
                    {
                        cmd.Parameters.AddWithValue("@ConditionValue", conditionValue);
                    }

                    object result = cmd.ExecuteScalar();
                    return result != null ? Convert.ToInt32(result) : 0;
                }
            }
        }
    }
}
