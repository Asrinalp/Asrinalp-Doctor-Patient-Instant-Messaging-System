using System;
using System.Data;
using System.Data.OleDb;
using System.Web;
using System.Web.UI;

namespace _152120211048_Asrınalp_Şahin_HW4
{
    public partial class Login : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session.Clear();
            }
        }

        private void UpdatePasswordToHashed(OleDbConnection conn, string userId, string newHashed)
        {
            string updateQuery = "UPDATE USERS SET [Password]=? WHERE UserID=?";
            using (OleDbCommand updateCmd = new OleDbCommand(updateQuery, conn))
            {
                updateCmd.Parameters.AddWithValue("?", newHashed);
                updateCmd.Parameters.AddWithValue("?", userId);
                updateCmd.ExecuteNonQuery();
            }
        }

        private void SetUserSession(OleDbDataReader reader)
        {
            Session["UserID"] = reader["UserID"].ToString();
            Session["Username"] = reader["Username"].ToString();
            Session["Role"] = reader["Role"].ToString();
            Session["FullName"] = reader["FullName"].ToString();

            string role = reader["Role"].ToString();
            if (role == "Doctor")
                Response.Redirect("DoctorDashboard.aspx");
            else
                Response.Redirect("PatientDashboard.aspx");
        }


        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();
            string hashedPassword = HashingHelper.ComputeSha256Hash(password);

            string connStr = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + Server.MapPath("~/App_Data/DoctorPatientChat.accdb");

            using (OleDbConnection conn = new OleDbConnection(connStr))
            {
                conn.Open();

                // 1. Hashlenmiş şifreyle kontrol et
                string hashQuery = "SELECT * FROM USERS WHERE Username=? AND Password=?";
                using (OleDbCommand hashCmd = new OleDbCommand(hashQuery, conn))
                {
                    hashCmd.Parameters.AddWithValue("?", username);
                    hashCmd.Parameters.AddWithValue("?", hashedPassword);

                    using (OleDbDataReader reader = hashCmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            // ✅ Hashlenmiş şifre eşleşti, giriş yap
                            SetUserSession(reader);
                            return;
                        }
                    }
                }

                // 2. Düz şifreyle kontrol et (eski kullanıcı olabilir)
                using (OleDbCommand plainCmd = new OleDbCommand(hashQuery, conn))
                {
                    plainCmd.Parameters.AddWithValue("?", username);
                    plainCmd.Parameters.AddWithValue("?", password); // düz şifre

                    using (OleDbDataReader reader2 = plainCmd.ExecuteReader())
                    {
                        if (reader2.Read())
                        {
                            // ✅ Eski şifreyle giriş başarılı → hashle ve güncelle
                            string userId = reader2["UserID"].ToString();
                            string newHashed = HashingHelper.ComputeSha256Hash(password);
                            UpdatePasswordToHashed(conn, userId, newHashed);

                            SetUserSession(reader2);
                            return;
                        }
                    }
                }

                // ❌ Her iki giriş de başarısız
                lblMessage.Text = "Invalid username or password.";
            }
        }
    }
}
