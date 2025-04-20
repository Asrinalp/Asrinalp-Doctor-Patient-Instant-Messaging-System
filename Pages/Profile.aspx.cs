using System;
using System.Data.OleDb;
using System.Runtime.Remoting.Messaging;

namespace _152120211048_Asrınalp_Şahin_HW4
{
    public partial class Profile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserID"] == null)
                {
                    Response.Redirect("Login.aspx");
                }

                // Set dashboard link based on user role
                string role = Session["Role"]?.ToString();
                if (role == "Doctor")
                {
                    dashboardLink.HRef = "DoctorDashboard.aspx";
                    messagesLink.HRef = "DoctorMessages.aspx"; // ⭐ Burası yeni
                }
                else
                {
                    dashboardLink.HRef = "PatientDashboard.aspx";
                    messagesLink.HRef = "Messages.aspx"; // ⭐ Burası yeni
                }


                // Set user name and role in the sidebar and header
                lblSidebarName.Text = Session["FullName"]?.ToString();
                lblUserName.Text = Session["FullName"]?.ToString();
                lblUserRole.Text = Session["Role"]?.ToString();

                LoadProfileData();
            }
        }

        private void LoadProfileData()
        {
            string connStr = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + Server.MapPath("~/App_Data/DoctorPatientChat.accdb");
            using (OleDbConnection conn = new OleDbConnection(connStr))
            {
                string query = "SELECT FullName, Email, [Password] FROM USERS WHERE UserID = ?";
                using (OleDbCommand cmd = new OleDbCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("?", Session["UserID"]);
                    conn.Open();
                    using (OleDbDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            txtFullName.Text = reader["FullName"].ToString();
                            txtEmail.Text = reader["Email"].ToString();
                            txtPassword.Text = reader["Password"].ToString();
                        }
                    }
                }
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            // Clear all session data
            Session.Clear();
            Session.Abandon();

            // Redirect to login page
            Response.Redirect("Login.aspx");
        }

        protected void btnBackToDashboard_Click(object sender, EventArgs e)
        {
            string role = Session["Role"]?.ToString();
            if (role == "Doctor")
                Response.Redirect("DoctorDashboard.aspx");
            else
                Response.Redirect("PatientDashboard.aspx");
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtFullName.Text) ||
                string.IsNullOrWhiteSpace(txtEmail.Text) ||
                string.IsNullOrWhiteSpace(txtPassword.Text))
            {
                pnlError.Visible = true;
                lblError.Text = "All fields are required.";
                pnlSuccess.Visible = false;
                return;
            }
            string password = txtPassword.Text.Trim();
            lblMessage.Text = ""; // Label'ı her seferinde temizle
            if (password.Length < 6)
            {
                lblMessage.Text = "Password must be at least 6 characters long.";
                return;
            }
            if (!System.Text.RegularExpressions.Regex.IsMatch(txtEmail.Text, @"^[^@\s]+@[^@\s]+\.[^@\s]+$"))
            {
                lblMessage.Text = "Please enter a valid email address.";
                return;
            }
            

            string hashedPassword = HashingHelper.ComputeSha256Hash(txtPassword.Text.Trim()); //Şifreyi hashle

            string connStr = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + Server.MapPath("~/App_Data/DoctorPatientChat.accdb");
            using (OleDbConnection conn = new OleDbConnection(connStr))
            {
                string update = "UPDATE USERS SET FullName = ?, Email = ?, [Password] = ? WHERE UserID = ?";
                using (OleDbCommand cmd = new OleDbCommand(update, conn))
                {
                    cmd.Parameters.AddWithValue("?", txtFullName.Text.Trim());
                    cmd.Parameters.AddWithValue("?", txtEmail.Text.Trim());
                    cmd.Parameters.AddWithValue("?", hashedPassword); // 🔐 Burada artık hashlenmiş şifre
                    cmd.Parameters.AddWithValue("?", Session["UserID"]);

                    conn.Open();
                    cmd.ExecuteNonQuery();

                    // Update session with new name
                    Session["FullName"] = txtFullName.Text.Trim();
                    lblSidebarName.Text = txtFullName.Text.Trim();
                    lblUserName.Text = txtFullName.Text.Trim();

                    pnlSuccess.Visible = true;
                    lblSuccess.Text = "Profile updated successfully.";
                    pnlError.Visible = false;
                }
            }
        }
    }
}