using System;
using System.Data;
using System.Data.OleDb;

namespace _152120211048_Asrınalp_Şahin_HW4
{
    public partial class DoctorDashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserID"] == null || Session["Role"]?.ToString() != "Doctor")
                {
                    Response.Redirect("Login.aspx");
                }
                lblDoctorName.Text = Session["FullName"].ToString();
                lblDoctorNameHeader.Text = Session["FullName"].ToString();
                LoadPatients();
                LoadOtherDoctors();
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


        private void LoadPatients()
        {
            string connStr = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + Server.MapPath("~/App_Data/DoctorPatientChat.accdb");
            using (OleDbConnection conn = new OleDbConnection(connStr))
            {
                string query = "SELECT [UserID], [FullName], [Email] FROM USERS WHERE [Role]='Patient'";
                using (OleDbCommand cmd = new OleDbCommand(query, conn))
                {
                    conn.Open();
                    OleDbDataReader reader = cmd.ExecuteReader();
                    rptPatients.DataSource = reader;
                    rptPatients.DataBind();
                }
            }
        }

        private void LoadOtherDoctors()
        {
            string currentDoctorId = Session["UserID"].ToString();
            string connStr = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + Server.MapPath("~/App_Data/DoctorPatientChat.accdb");
            using (OleDbConnection conn = new OleDbConnection(connStr))
            {
                string query = "SELECT [UserID], [FullName], [Email] FROM USERS WHERE [Role]='Doctor' AND UserID<>?";
                using (OleDbCommand cmd = new OleDbCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("?", currentDoctorId);
                    conn.Open();
                    OleDbDataReader reader = cmd.ExecuteReader();
                    rptDoctors.DataSource = reader;
                    rptDoctors.DataBind();
                }
            }
        }
    }
}
