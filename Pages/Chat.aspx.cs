using System;
using System.Data;
using System.Data.OleDb;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace _152120211048_Asrınalp_Şahin_HW4
{
    public partial class Chat : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserID"] == null || Session["Role"] == null)
                {
                    Response.Redirect("Login.aspx");
                    return;
                }

                string role = Session["Role"].ToString();
                string fullName = Session["FullName"].ToString();
                lblPatientName.Text = role == "Doctor" ? "Dr. " + fullName : fullName;

                // Dinamik olarak sidebar menüsünü göster
                patientLinks.Visible = (role == "Patient");
                doctorLinks.Visible = (role == "Doctor");

                string receiverId = Request.QueryString["receiverId"];
                if (string.IsNullOrEmpty(receiverId))
                {
                    Response.Redirect(role == "Doctor" ? "DoctorDashboard.aspx" : "PatientDashboard.aspx");
                }

                LoadReceiverInfo(receiverId);
                LoadMessages(receiverId);

                // Karşı taraftan gelen mesajları "okundu" olarak işaretle
                MarkMessagesAsRead(receiverId, Session["UserID"].ToString());

            }

        }


        private void LoadReceiverInfo(string receiverId)
        {
            string connStr = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + Server.MapPath("~/App_Data/DoctorPatientChat.accdb");
            using (OleDbConnection conn = new OleDbConnection(connStr))
            {
                string query = "SELECT [FullName] FROM USERS WHERE UserID=?";
                using (OleDbCommand cmd = new OleDbCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("?", receiverId);
                    conn.Open();
                    object name = cmd.ExecuteScalar();
                    lblReceiverName.Text = name?.ToString() ?? "Unknown";
                }
            }
        }

        private void LoadMessages(string receiverId)
        {
            string userId = Session["UserID"].ToString();
            string connStr = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + Server.MapPath("~/App_Data/DoctorPatientChat.accdb");

            using (OleDbConnection conn = new OleDbConnection(connStr))
            {
                string query = @"
                    SELECT C.MessageText, C.Timestamp, C.IsRead, U.FullName AS SenderName
                    FROM CHAT C
                    INNER JOIN USERS U ON C.SenderID = U.UserID
                    WHERE (C.SenderID=? AND C.ReceiverID=?) OR (C.SenderID=? AND C.ReceiverID=?)
                    ORDER BY C.Timestamp";

                using (OleDbCommand cmd = new OleDbCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("?", userId);
                    cmd.Parameters.AddWithValue("?", receiverId);
                    cmd.Parameters.AddWithValue("?", receiverId);
                    cmd.Parameters.AddWithValue("?", userId);

                    conn.Open();
                    rptMessages.DataSource = cmd.ExecuteReader();
                    rptMessages.DataBind();
                }
            }
        }

        protected string GetMessageClass(object senderName)
        {
            if (senderName == null) return "incoming";

            string currentUserName = Session["FullName"].ToString();
            return senderName.ToString() == currentUserName ? "outgoing" : "incoming";
        }

        protected string FormatMessageText(object messageText)
        {
            if (messageText == null) return string.Empty;

            string text = messageText.ToString();

            if (text.StartsWith("[File]"))
            {
                // Format file messages with an icon
                text = text.Replace("[File] ", "");
                return $"<i class=\"fas fa-file-alt\"></i> {text}";
            }

            return text;
        }

        protected string FormatTime(object timestamp)
        {
            if (timestamp == null || timestamp == DBNull.Value) return string.Empty;

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
                return "Yesterday " + messageTime.ToString("HH:mm");
            }
            else
            {
                // Other dates: show date and time
                return messageTime.ToString("dd/MM/yyyy HH:mm");
            }
        }

        protected string GetMessageTicks(object senderName, object isRead)
        {
            if (senderName == null) return string.Empty;

            string currentUserName = Session["FullName"].ToString();
            if (senderName.ToString() == currentUserName)
            {
                // Gönderen kişi şu anda oturum açmış olan kişi ise (yani kendi mesajımsa)
                bool isReadFlag = isRead != DBNull.Value && Convert.ToBoolean(isRead);
                return $"<i class='fa fa-check{(isReadFlag ? "-double text-success ticks seen" : "")}'></i>";
            }

            return string.Empty;
        }

        // ChatHub.cs dosyasına ekleyin/değiştirin
        public void MarkMessagesAsRead(string senderId, string receiverId)
        {
            // Bu metod, alıcı (receiverId) mesajları okuduğunda çağrılır

            string connStr = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + HttpContext.Current.Server.MapPath("~/App_Data/DoctorPatientChat.accdb");

            using (OleDbConnection conn = new OleDbConnection(connStr))
            {
                // Alıcının okuduğu mesajları güncelle
                string update = "UPDATE CHAT SET IsRead = True WHERE SenderID = ? AND ReceiverID = ? AND IsRead = False";
                using (OleDbCommand cmd = new OleDbCommand(update, conn))
                {
                    cmd.Parameters.AddWithValue("?", senderId);    // Mesajı gönderen
                    cmd.Parameters.AddWithValue("?", receiverId);  // Mesajı alan ve şimdi okuyan

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
           
        }

        protected void btnUpload_Click(object sender, EventArgs e)
        {
            if (fileUpload.HasFile)
            {
                try
                {
                    string fileName = Path.GetFileName(fileUpload.FileName);
                    string uploadFolder = Server.MapPath("~/Uploads/");
                    Directory.CreateDirectory(uploadFolder); // Klasör yoksa oluşturur
                    string savePath = Path.Combine(uploadFolder, fileName);
                    fileUpload.SaveAs(savePath);

                    string fileUrl = "<a href='Uploads/" + fileName + "' target='_blank'>" + fileName + "</a>";
                    string messageContent = "[File] " + fileUrl;

                    string senderId = Session["UserID"].ToString();
                    string receiverId = Request.QueryString["receiverId"];
                    string connStr = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + Server.MapPath("~/App_Data/DoctorPatientChat.accdb");

                    using (OleDbConnection conn = new OleDbConnection(connStr))
                    {
                        string insert = "INSERT INTO CHAT ([SenderID], [ReceiverID], [MessageText], [Timestamp], [IsRead]) VALUES (?, ?, ?, ?, ?)";
                        using (OleDbCommand cmd = new OleDbCommand(insert, conn))
                        {
                            cmd.Parameters.Add("?", OleDbType.Integer).Value = int.Parse(senderId);
                            cmd.Parameters.Add("?", OleDbType.Integer).Value = int.Parse(receiverId);
                            cmd.Parameters.Add("?", OleDbType.VarWChar).Value = messageContent;
                            cmd.Parameters.Add("?", OleDbType.Date).Value = DateTime.Now;
                            cmd.Parameters.Add("?", OleDbType.Boolean).Value = false;

                            conn.Open();
                            cmd.ExecuteNonQuery();
                        }
                    }

                    Response.Redirect(Request.RawUrl); // Refresh the page
                }
                catch (Exception ex)
                {
                    // İsteğe bağlı olarak loglayabilirsin: Global.Log(ex.ToString());
                    lblMessage.Text = "Dosya yüklenirken bir hata oluştu: " + ex.Message;
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                }
            }
            else
            {
                lblMessage.Text = "Lütfen bir dosya seçin.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
            }
        }

        protected void rptMessages_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {           
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }

        protected string GetBackLink()
        {
            string role = Session["Role"]?.ToString();
            return role == "Doctor" ? "DoctorMessages.aspx" : "Messages.aspx";
        }

    }
}