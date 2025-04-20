using System;
using System.Data.OleDb;

namespace _152120211048_Asrınalp_Şahin_HW4
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                lblMessage.Text = "";
            }
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            string fullName = txtFullName.Text.Trim();
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();
            string hashedPassword = HashingHelper.ComputeSha256Hash(password);
            string email = txtEmail.Text.Trim();
            string role = "Patient";

            if (string.IsNullOrWhiteSpace(fullName) ||
                string.IsNullOrWhiteSpace(username) ||
                string.IsNullOrWhiteSpace(password) ||
                string.IsNullOrWhiteSpace(email))
            {
                lblMessage.Text = "All fields are required.";
                return;
            }

            if (password.Length < 6)
            {
                lblMessage.Text = "Password must be at least 6 characters long.";
                return;
            }

            if (!System.Text.RegularExpressions.Regex.IsMatch(email, @"^[^@\s]+@[^@\s]+\.[^@\s]+$"))
            {
                lblMessage.Text = "Please enter a valid email address.";
                return;
            }



            string connStr = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + Server.MapPath("~/App_Data/DoctorPatientChat.accdb");

            using (OleDbConnection conn = new OleDbConnection(connStr))
            {
                conn.Open();

                // Username check
                string checkQuery = "SELECT COUNT(*) FROM USERS WHERE [Username]=?";
                using (OleDbCommand checkCmd = new OleDbCommand(checkQuery, conn))
                {
                    checkCmd.Parameters.AddWithValue("?", username);
                    int count = (int)checkCmd.ExecuteScalar();
                    if (count > 0)
                    {
                        lblMessage.Text = "Username already exists.";
                        return;
                    }
                }

                // Insert new user with hashed password
                string insertQuery = "INSERT INTO USERS ([Username], [Password], [Role], [FullName], [Email]) VALUES (?, ?, ?, ?, ?)";
                using (OleDbCommand cmd = new OleDbCommand(insertQuery, conn))
                {
                    cmd.Parameters.AddWithValue("?", username);
                    cmd.Parameters.AddWithValue("?", hashedPassword); 
                    cmd.Parameters.AddWithValue("?", role);
                    cmd.Parameters.AddWithValue("?", fullName);
                    cmd.Parameters.AddWithValue("?", email);

                    int result = cmd.ExecuteNonQuery();
                    if (result > 0)
                    {
                        lblMessage.ForeColor = System.Drawing.Color.Green;
                        lblMessage.Text = "Registration successful! You can now login.";
                    }
                    else
                    {
                        lblMessage.Text = "Registration failed. Try again.";
                    }
                }
            }
        }   
    }
}
