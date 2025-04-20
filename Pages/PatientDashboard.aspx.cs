using System;
using System.Data;
using System.Data.OleDb;

namespace _152120211048_Asrınalp_Şahin_HW4
{
    public partial class PatientDashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserID"] == null || Session["Role"]?.ToString() != "Patient")
                {
                    Response.Redirect("Login.aspx");
                }

                // Set patient name in both places
                lblPatientName.Text = Session["FullName"].ToString();
                lblPatientNameHeader.Text = Session["FullName"].ToString();

                // Load data
                LoadDoctors();
                LoadStatistics();
            }
        }

        private void LoadStatistics()
        {
            string patientId = Session["UserID"].ToString();
            string connStr = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + Server.MapPath("~/App_Data/DoctorPatientChat.accdb");

            using (OleDbConnection conn = new OleDbConnection(connStr))
            {
                conn.Open();

                // Count doctors
                string doctorQuery = @"
                SELECT COUNT(*) FROM (
                    SELECT U.UserID
                    FROM CHAT C
                    INNER JOIN USERS U ON C.SenderID = U.UserID OR C.ReceiverID = U.UserID
                    WHERE U.[Role]='Doctor' AND (C.SenderID = ? OR C.ReceiverID = ?)
                    GROUP BY U.UserID
                )";


                using (OleDbCommand cmd = new OleDbCommand(doctorQuery, conn))
                {
                    cmd.Parameters.AddWithValue("?", int.Parse(patientId));
                    cmd.Parameters.AddWithValue("?", int.Parse(patientId));
                    int doctorCount = Convert.ToInt32(cmd.ExecuteScalar());
                    lblDoctorCount.Text = doctorCount.ToString();
                }

                // Count messages
                string messageQuery = @"
            SELECT COUNT(*) AS MessageCount
            FROM CHAT
            WHERE SenderID = ? OR ReceiverID = ?";

                using (OleDbCommand cmd = new OleDbCommand(messageQuery, conn))
                {
                    cmd.Parameters.AddWithValue("?", int.Parse(patientId));
                    cmd.Parameters.AddWithValue("?", int.Parse(patientId));
                    int messageCount = Convert.ToInt32(cmd.ExecuteScalar());
                    lblMessageCount.Text = messageCount.ToString();
                }

                // Get last activity
                string lastActivityQuery = @"
            SELECT MAX([Timestamp]) AS LastActivity
            FROM CHAT
            WHERE SenderID = ? OR ReceiverID = ?";

                using (OleDbCommand cmd = new OleDbCommand(lastActivityQuery, conn))
                {
                    cmd.Parameters.AddWithValue("?", int.Parse(patientId));
                    cmd.Parameters.AddWithValue("?", int.Parse(patientId));
                    object result = cmd.ExecuteScalar();
                    if (result != null && result != DBNull.Value)
                    {
                        DateTime lastActivity = Convert.ToDateTime(result);
                        lblLastActivity.Text = lastActivity.ToString("dd MMM yyyy");
                    }
                    else
                    {
                        lblLastActivity.Text = "No activity";
                    }
                }
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            // Önce logla – çünkü Session birazdan silinecek
            string username = Session["FullName"]?.ToString() ?? "Unknown";
            Global.Log("🚪 Logout: " + username);

            // Sonra session'ı temizle
            Session.Clear();
            Session.Abandon();

            // Giriş ekranına yönlendir
            Response.Redirect("Login.aspx");
        }

        private void LoadDoctors()
        {
            string patientId = Session["UserID"].ToString();
            string connStr = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + Server.MapPath("~/App_Data/DoctorPatientChat.accdb");

            using (OleDbConnection conn = new OleDbConnection(connStr))
            {
                string query = @"
                    SELECT DISTINCT U.[UserID], U.[FullName], U.[Email]
                    FROM CHAT C
                    INNER JOIN USERS U ON C.SenderID = U.UserID OR C.ReceiverID = U.UserID
                    WHERE U.[Role]='Doctor' AND (C.SenderID = ? OR C.ReceiverID = ?)";

                using (OleDbCommand cmd = new OleDbCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("?", int.Parse(patientId));
                    cmd.Parameters.AddWithValue("?", int.Parse(patientId));
                    conn.Open();

                    DataTable dt = new DataTable();
                    OleDbDataAdapter adapter = new OleDbDataAdapter(cmd);
                    adapter.Fill(dt);

                    dlDoctors.DataSource = dt;
                    dlDoctors.DataBind();
                }
            }
        }
    }
}