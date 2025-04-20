using Microsoft.AspNet.SignalR;
using System;
using System.Data.OleDb;
using System.Web;

namespace _152120211048_Asrınalp_Şahin_HW4
{
    public class ChatHub : Hub
    {
        public void SendMessage(string senderId, string receiverId, string senderName, string message)
        {
            Global.Log($"💬 Message sent | From: {senderId} | To: {receiverId} ");

            string timestamp = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");

            // Mesajı karşı tarafa gönder
            Clients.All.receiveMessage(senderId, senderName, message, timestamp);

            // Veritabanına kaydet
            string connStr = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + HttpContext.Current.Server.MapPath("~/App_Data/DoctorPatientChat.accdb");
            using (OleDbConnection conn = new OleDbConnection(connStr))
            {
                string insert = "INSERT INTO CHAT ([SenderID], [ReceiverID], [MessageText], [Timestamp], [IsRead]) VALUES (?, ?, ?, ?, ?)";
                using (OleDbCommand cmd = new OleDbCommand(insert, conn))
                {
                    // Parametreleri doğru türde ekleyin
                    cmd.Parameters.Add("?", OleDbType.Integer).Value = int.TryParse(senderId, out int parsedSenderId) ? parsedSenderId : throw new ArgumentException("SenderID geçerli bir sayı değil.");
                    cmd.Parameters.Add("?", OleDbType.Integer).Value = int.TryParse(receiverId, out int parsedReceiverId) ? parsedReceiverId : throw new ArgumentException("ReceiverID geçerli bir sayı değil.");
                    cmd.Parameters.Add("?", OleDbType.VarChar).Value = message;
                    cmd.Parameters.Add("?", OleDbType.Date).Value = DateTime.Now;
                    cmd.Parameters.Add("?", OleDbType.Boolean).Value = false;

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        public void Typing(string senderId, string receiverId, string senderName)
        {
            Clients.All.showTyping(senderId, senderName);
        }

        public void MarkMessagesAsRead(string senderId, string receiverId)
        {
            string connStr = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + HttpContext.Current.Server.MapPath("~/App_Data/DoctorPatientChat.accdb");
            using (OleDbConnection conn = new OleDbConnection(connStr))
            {
                string update = "UPDATE CHAT SET [IsRead] = ? WHERE [SenderID] = ? AND [ReceiverID] = ? AND [IsRead] = false";
                using (OleDbCommand cmd = new OleDbCommand(update, conn))
                {
                    cmd.Parameters.AddWithValue("?", true);
                    cmd.Parameters.AddWithValue("?", int.Parse(senderId));
                    cmd.Parameters.AddWithValue("?", int.Parse(receiverId));

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            Clients.All.messageSeen(senderId, receiverId);
        }
    }
}