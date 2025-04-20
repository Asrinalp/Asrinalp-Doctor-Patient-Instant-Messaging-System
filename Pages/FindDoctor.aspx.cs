using System;
using System.Data;
using System.Data.OleDb;
using System.Web.UI;

namespace _152120211048_Asrınalp_Şahin_HW4
{
    public partial class FindDoctor : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserID"] == null || Session["Role"]?.ToString() != "Patient")
                {
                    Response.Redirect("Login.aspx");
                    return;
                }

                lblPatientName.Text = Session["FullName"].ToString();
                LoadDoctors();
            }
        }

        private void LoadDoctors()
        {
            string connStr = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + Server.MapPath("~/App_Data/DoctorPatientChat.accdb");

            using (OleDbConnection conn = new OleDbConnection(connStr))
            {
                string query = "SELECT UserID, FullName, Email FROM USERS WHERE Role='Doctor'";
                using (OleDbCommand cmd = new OleDbCommand(query, conn))
                {
                    conn.Open();
                    rptDoctors.DataSource = cmd.ExecuteReader();
                    rptDoctors.DataBind();
                }
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }
    }
}
