using System;
using System.Data;
using System.Data.OleDb;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace _152120211048_Asrınalp_Şahin_HW4
{
    public partial class DoctorMessages : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserID"] == null || Session["Role"]?.ToString() != "Doctor")
                {
                    Response.Redirect("Login.aspx");
                    return;
                }

                lblDoctorName.Text = Session["FullName"].ToString();
                LoadConversations();
            }

            HighlightCurrentPage();
        }

        private void HighlightCurrentPage()
        {
            string currentPage = System.IO.Path.GetFileName(Request.Url.AbsolutePath).ToLower();

            if (currentPage == "doctordashboard.aspx")
                lnkDashboard.Attributes["class"] += " active";
            else if (currentPage == "profile.aspx")
                lnkProfile.Attributes["class"] += " active";
            else if (currentPage == "doctormessages.aspx")
                lnkMessages.Attributes["class"] += " active";
        }

        protected string GetSeenIcon(object isRead)
        {
            bool seen = isRead != DBNull.Value && Convert.ToBoolean(isRead);
            return seen ? "fa-check-double text-success" : "fa-check";
        }

        private void LoadConversations()
        {
            string doctorId = Session["UserID"].ToString();
            string connStr = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + Server.MapPath("~/App_Data/DoctorPatientChat.accdb");

            using (OleDbConnection conn = new OleDbConnection(connStr))
            {
                string query = @"
                    SELECT 
                        U.FullName,
                        U.UserID,
                        C.MessageText AS LastMessage,
                        C.Timestamp,
                        C.IsRead
                    FROM CHAT AS C
                    INNER JOIN USERS AS U 
                        ON (U.UserID = IIF(C.SenderID = ?, C.ReceiverID, C.SenderID))
                    WHERE 
                        (C.SenderID = ? OR C.ReceiverID = ?) 
                        AND U.Role = 'Patient'
                        AND C.Timestamp = (
                            SELECT MAX(Timestamp) 
                            FROM CHAT 
                            WHERE 
                                (SenderID = ? AND ReceiverID = U.UserID) OR 
                                (ReceiverID = ? AND SenderID = U.UserID)
                        )
                    ORDER BY C.Timestamp DESC";

                using (OleDbCommand cmd = new OleDbCommand(query, conn))
                {
                    for (int i = 0; i < 5; i++)
                        cmd.Parameters.AddWithValue("?", int.Parse(doctorId));

                    conn.Open();
                    OleDbDataReader reader = cmd.ExecuteReader();
                    DataTable dt = new DataTable();
                    dt.Load(reader);

                    dt.Columns.Add("ChatLink", typeof(string));
                    foreach (DataRow row in dt.Rows)
                    {
                        row["ChatLink"] = "Chat.aspx?receiverId=" + row["UserID"];
                    }

                    rptMessages.DataSource = dt;
                    rptMessages.DataBind();
                }
            }
        }

        protected string FormatTimestamp(object timestamp)
        {
            if (timestamp == DBNull.Value || timestamp == null)
                return "";

            DateTime msgTime = Convert.ToDateTime(timestamp);
            DateTime today = DateTime.Today;

            if (msgTime.Date == today)
                return msgTime.ToString("HH:mm");
            else if (msgTime.Date == today.AddDays(-1))
                return "Yesterday";
            else if (msgTime.Date > today.AddDays(-7))
                return msgTime.ToString("dddd");
            else
                return msgTime.ToString("dd/MM/yyyy");
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Global.Log("🚪 Logout: " + Session["FullName"]);
            Session.Clear(  );
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }
    }
}
