using System;
using System.Data;
using System.Data.OleDb;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace _152120211048_Asrınalp_Şahin_HW4
{
    public partial class Messages : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserID"] == null || Session["Role"]?.ToString() != "Patient")
                {
                    Response.Redirect("Login.aspx");
                }
                lblPatientName.Text = Session["FullName"].ToString();
                LoadConversations();
            }
        }

        private void LoadConversations()
        {
            string patientId = Session["UserID"].ToString();
            string connStr = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + Server.MapPath("~/App_Data/DoctorPatientChat.accdb");

            using (OleDbConnection conn = new OleDbConnection(connStr))
            {
                // Her doktor-patient çifti için en son mesajı getir
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
                AND U.Role = 'Doctor'
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
                    // Sırasıyla tüm parametreleri tekrar giriyoruz
                    for (int i = 0; i < 5; i++)
                    {
                        cmd.Parameters.AddWithValue("?", int.Parse(patientId));
                    }

                    conn.Open();
                    OleDbDataReader reader = cmd.ExecuteReader();
                    DataTable dt = new DataTable();
                    dt.Load(reader);

                    // ChatLink kolonunu oluştur
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


        // Format timestamp to be more like WhatsApp (today shows only time, older shows date)
        protected string FormatTimestamp(object timestamp)
        {
            if (timestamp == DBNull.Value || timestamp == null)
                return "";

            DateTime messageTime = Convert.ToDateTime(timestamp);
            DateTime today = DateTime.Today;

            if (messageTime.Date == today)
            {
                // Today: show only time (13:45)
                return messageTime.ToString("HH:mm");
            }
            else if (messageTime.Date == today.AddDays(-1))
            {
                // Yesterday: show "Yesterday"
                return "Yesterday";
            }
            else if (messageTime.Date > today.AddDays(-7))
            {
                // This week: show day name (Monday, Tuesday, etc.)
                return messageTime.ToString("dddd");
            }
            else
            {
                // Older: show date (15/04/2025)
                return messageTime.ToString("dd/MM/yyyy");
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