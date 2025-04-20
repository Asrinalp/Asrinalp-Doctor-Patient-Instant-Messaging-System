<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="/Pages/Chat.aspx.cs" Inherits="_152120211048_Asrınalp_Şahin_HW4.Chat" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Chat</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/Scripts/jquery.signalR-2.4.3.min.js"></script>
    <script src="/signalr/hubs"></script>
    <style>
        :root {
            --primary: #4285f4;
            --secondary: #f8f9fa;
            --white: #ffffff;
            --gray: #6c757d;
            --gray-dark: #343a40;
            --success: #28a745;
            --danger: #dc3545;
            --light-blue: #e1f5fe;
            --chat-bg: #f0f2f5;
            --sent-msg: #dcf8c6;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background-color: #f5f7fa;
        }

        .layout {
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar Styles */
        .sidebar {
            width: 280px;
            background-color: var(--white);
            border-right: 1px solid rgba(0, 0, 0, 0.1);
            padding: 20px 0;
            display: flex;
            flex-direction: column;
        }

        .sidebar-header {
            padding: 0 20px 20px;
            border-bottom: 1px solid rgba(0, 0, 0, 0.1);
        }

        .patient-info {
            display: flex;
            align-items: center;
        }

        .patient-avatar {
            width: 50px;
            height: 50px;
            background-color: var(--primary);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 20px;
            margin-right: 15px;
        }

        .patient-name {
            font-weight: 600;
            font-size: 18px;
        }

        .nav-menu {
            list-style: none;
            margin-top: 20px;
            flex: 1;
        }

        .nav-item {
            margin-bottom: 5px;
        }

        .nav-link {
            display: flex;
            align-items: center;
            padding: 12px 20px;
            color: var(--gray-dark);
            text-decoration: none;
            transition: all 0.2s;
        }

        .nav-link:hover {
            background-color: var(--secondary);
        }

        .nav-link.active {
            background-color: var(--primary);
            color: white;
            border-radius: 0 30px 30px 0;
        }

        .nav-link i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
        }

        .logout-btn {
            margin: 20px;
            padding: 10px;
            background-color: var(--danger);
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: 600;
        }

        /* Main Content Styles */
        .main-content {
            flex: 1;
            padding: 20px;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
        }

        .chat-header {
            display: flex;
            align-items: center;
            padding: 15px 20px;
            background-color: var(--white);
            border-radius: 15px 15px 0 0;
            box-shadow: 0 1px 5px rgba(0,0,0,0.05);
            margin-bottom: 1px;
        }

        .doctor-avatar {
            width: 45px;
            height: 45px;
            background-color: var(--primary);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 18px;
            margin-right: 15px;
        }

        .doctor-info {
            flex: 1;
        }

        .doctor-name {
            font-weight: 600;
            font-size: 18px;
            margin-bottom: 2px;
        }

        .doctor-status {
            font-size: 13px;
            color: var(--success);
        }

        .chat-actions {
            display: flex;
            gap: 15px;
        }

        .chat-actions button {
            background: none;
            border: none;
            font-size: 20px;
            color: var(--gray);
            cursor: pointer;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: background-color 0.2s;
        }

        .chat-actions button:hover {
            background-color: var(--secondary);
        }

        .search-box {
            padding: 10px 20px;
            background-color: var(--white);
            margin-bottom: 1px;
        }

        .search-box input {
            width: 100%;
            padding: 10px 15px;
            border: none;
            border-radius: 20px;
            background-color: var(--secondary);
            outline: none;
            font-size: 14px;
        }

        .search-box input::placeholder {
            color: var(--gray);
        }

        .chat-container {
            flex: 1;
            display: flex;
            flex-direction: column;
            background-color: var(--chat-bg);
            border-radius: 0 0 15px 15px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
        }

        .chat-messages {
            flex: 1;
            padding: 20px;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
            gap: 10px;
            min-height: 400px;
            max-height: calc(100vh - 300px);
        }

        .message {
            max-width: 75%;
            padding: 10px 15px;
            border-radius: 10px;
            position: relative;
            margin-bottom: 5px;
        }

        .message.incoming {
            align-self: flex-start;
            background-color: var(--white);
            border-top-left-radius: 0;
        }

        .message.outgoing {
            align-self: flex-end;
            background-color: var(--sent-msg);
            border-top-right-radius: 0;
        }

        .message-content {
            margin-bottom: 5px;
        }

        .message-meta {
            display: flex;
            justify-content: flex-end;
            align-items: center;
            font-size: 12px;
            color: var(--gray);
        }

        .message-time {
            margin-right: 5px;
        }

        .ticks {
            color: var(--gray);
        }

        .ticks.seen {
            color: #4fc3f7;
        }

        .typing {
            padding: 0 20px;
            height: 25px;
            font-style: italic;
            color: var(--gray);
        }

        .input-container {
            display: flex;
            align-items: center;
            padding: 10px 20px;
            background-color: var(--white);
            border-top: 1px solid rgba(0,0,0,0.05);
        }

        .attach-btn {
            background: none;
            border: none;
            font-size: 20px;
            color: var(--gray);
            cursor: pointer;
            padding: 10px;
            border-radius: 50%;
            transition: background-color 0.2s;
        }

        .attach-btn:hover {
            background-color: var(--secondary);
        }

        .message-input {
            flex: 1;
            border: none;
            padding: 12px 15px;
            border-radius: 20px;
            background-color: var(--secondary);
            margin: 0 10px;
            outline: none;
        }

        .send-btn {
            background-color: var(--primary);
            border: none;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            cursor: pointer;
            transition: background-color 0.2s;
        }

        .send-btn:hover {
            background-color: #3367d6;
        }

        .file-upload {
            display: none;
            position: absolute;
            bottom: 70px;
            left: 20px;
            background-color: var(--white);
            padding: 15px;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            width: 300px;
            z-index: 10;
        }

        .upload-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }

        .upload-header h3 {
            font-size: 16px;
            font-weight: 600;
        }

        .close-upload {
            background: none;
            border: none;
            font-size: 18px;
            cursor: pointer;
            color: var(--gray);
        }

        .upload-message {
            padding: 10px 20px;
            color: var(--danger);
            font-weight: bold;
        }


        .upload-content {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .upload-btn {
            background-color: var(--primary);
            color: white;
            border: none;
            padding: 10px;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.2s;
        }

        .upload-btn:hover {
            background-color: #3367d6;
        }

        .file-name {
            margin-left: 10px;
            font-size: 13px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            max-width: 180px;
        }

        @media (max-width: 768px) {
            .layout {
                flex-direction: column;
            }
            .sidebar {
                width: 100%;
                border-right: none;
                border-bottom: 1px solid rgba(0, 0, 0, 0.1);
            }
            .message {
                max-width: 85%;
            }
            .chat-messages {
                max-height: calc(100vh - 400px);
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server" enctype="multipart/form-data">
        <div class="layout">
            <!-- Sidebar -->
            <div class="sidebar">
                <div class="sidebar-header">
                    <div class="patient-info">
                        <div class="patient-avatar">
                            <i class="fas fa-user"></i>
                        </div>
                        <div class="patient-name">
                            <asp:Label ID="lblPatientName" runat="server" />
                        </div>
                    </div>
                </div>
                <ul class="nav-menu" id="patientLinks" runat="server" visible="false">
                    <li class="nav-item">
                        <a href="PatientDashboard.aspx" class="nav-link">
                            <i class="fas fa-th-large"></i><span>Dashboard</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="Profile.aspx" class="nav-link"><i class="fas fa-user"></i><span>Profile</span></a>
                    </li>
                    <li class="nav-item">
                        <a href="Messages.aspx" class="nav-link active"><i class="fas fa-comment-medical"></i><span>Messages</span></a>
                    </li>
                    <li class="nav-item">
                        <a href="FindDoctor.aspx" class="nav-link"><i class="fas fa-user-md"></i><span>Find Doctor</span></a>
                    </li>
                </ul>

                <ul class="nav-menu" id="doctorLinks" runat="server" visible="false">
                    <li class="nav-item">
                        <a href="DoctorDashboard.aspx" class="nav-link">
                            <i class="fas fa-th-large"></i><span>Dashboard</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="Profile.aspx" class="nav-link"><i class="fas fa-user"></i><span>Profile</span></a>
                    </li>
                    <li class="nav-item">
                        <a href="DoctorMessages.aspx" class="nav-link active"><i class="fas fa-comment-medical"></i><span>Messages</span></a>
                    </li>
                </ul>

                <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="logout-btn" OnClick="btnLogout_Click" />
            </div>

            <!-- Main Content -->
            <div class="main-content">
                <div class="chat-header">
                    <div class="doctor-avatar">
                        <i class="fas fa-user-md"></i>
                    </div>
                    <div class="doctor-info">
                        <div class="doctor-name">
                            <asp:Label ID="lblReceiverName" runat="server" />
                        </div>
                        <div class="doctor-status" id="onlineStatus">Online</div>
                    </div>
                    <div class="chat-actions">
                        <button type="button" id="btnSearch">
                            <i class="fas fa-search"></i>
                        </button>
                        <a href='<%= GetBackLink() %>' class="btn">
                            <i class="fas fa-arrow-left"></i>
                        </a>                       
                    </div>
                </div>

                <div class="search-box" id="searchBox" style="display:none;">
                    <input type="text" id="searchInput" placeholder="Search in conversation..." />
                </div>

                <div class="chat-container">
                    <div class="chat-messages" id="chatMessages">
                        <asp:Repeater ID="rptMessages" runat="server" OnItemDataBound="rptMessages_ItemDataBound">
                            <ItemTemplate>
                                <div class="message <%# GetMessageClass(Eval("SenderName")) %>">
                                    <div class="message-content">
                                        <%# FormatMessageText(Eval("MessageText")) %>
                                    </div>
                                    <div class="message-meta">
                                        <span class="message-time"><%# FormatTime(Eval("Timestamp")) %></span>
                                        <%# GetMessageTicks(Eval("SenderName"), Eval("IsRead")) %>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                
                    <div class="typing" id="typingStatus"></div>
                
                    <div class="input-container">
                        <button type="button" class="attach-btn" id="btnAttach">
                            <i class="fas fa-paperclip"></i>
                        </button>
                        <input type="text" class="message-input" id="txtMessage" placeholder="Type a message..." autocomplete="off" />
                        <button type="button" class="send-btn" id="btnSend">
                            <i class="fas fa-paper-plane"></i>
                        </button>
                    </div>
                </div>

                <div class="file-upload" id="fileUploadPanel">
                    <div class="upload-header">
                        <h3>Upload File</h3>
                        <button type="button" class="close-upload" id="btnCloseUpload">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                    <div class="upload-content">
                        <asp:FileUpload ID="fileUpload" runat="server" />
                        <div class="file-info" id="fileInfo">
                            <span class="file-name" id="fileName"></span>
                        </div>
                        <asp:Label ID="lblMessage" runat="server" CssClass="upload-message" />
                        <asp:Button ID="btnUpload" runat="server" Text="Send File" CssClass="upload-btn" OnClick="btnUpload_Click" />
                    </div>
                </div>
            </div>
        </div>
    </form>

    <script>
        var receiverId = new URLSearchParams(window.location.search).get("receiverId");
        var userId = '<%= Session["UserID"] %>';
        var fullName = '<%= Session["FullName"] %>';

        $(document).ready(function() {
            // Scroll to bottom of chat
            scrollToBottom();
            
            // Toggle search box
            $("#btnSearch").on("click", function() {
                $("#searchBox").slideToggle();
                $("#searchInput").focus();
            });
            
            // Toggle file upload panel
            $("#btnAttach").on("click", function() {
                $("#fileUploadPanel").toggle();
            });
            
            // Close file upload panel
            $("#btnCloseUpload").on("click", function() {
                $("#fileUploadPanel").hide();
            });
            
            // Show file name when selected
            $("#<%= fileUpload.ClientID %>").on("change", function () {
                if (this.files && this.files[0]) {
                    $("#fileName").text(this.files[0].name);
                }
            });

            // Search messages
            $("#searchInput").on("keyup", function () {
                var keyword = $(this).val().toLowerCase();
                $(".message").each(function () {
                    var text = $(this).find(".message-content").text().toLowerCase();
                    $(this).toggle(text.includes(keyword));
                });
            });
        });

        function scrollToBottom() {
            var chatMessages = document.getElementById("chatMessages");
            chatMessages.scrollTop = chatMessages.scrollHeight;
        }

        // SignalR Code
        var chat = $.connection.chatHub;

        // Receive message
        chat.client.receiveMessage = function (senderId, senderName, message, timestamp) {
            if (senderId === receiverId || senderId === userId) {
                const isFile = message.includes("[File]");
                const icon = isFile ? "📎 " : "";
                const cleanMessage = isFile ? message.replace("[File] ", "") : message;
                const messageClass = senderId === userId ? "outgoing" : "incoming";

                
                const ticksHtml = senderId === userId ?
                    '<i class="fa fa-check"></i>' : '';

                $("#chatMessages").append(`
                    <div class="message ${messageClass}">
                        <div class="message-content">
                            ${icon}${cleanMessage}
                        </div>
                        <div class="message-meta">
                            <span class="message-time">${formatTime(timestamp)}</span>
                            ${ticksHtml}
                        </div>
                    </div>
                `);

                scrollToBottom();
            }
        };

        // Show typing indicator
        chat.client.showTyping = function (senderId, senderName) {
            if (senderId === receiverId) {
                $("#typingStatus").text(`${senderName} is typing...`);
                $("#onlineStatus").text("Typing...");
                setTimeout(() => {
                    $("#typingStatus").text('');
                    $("#onlineStatus").text("Online");
                }, 2000);
            }
        };
              
        // Mark messages as seen - bu fonksiyon sadece gerçekten okunduğunda çağrılmalı
        chat.client.messageSeen = function (senderId, receiverId) {
            // Sadece kendi gönderdiğim mesajların durumunu güncelle           
            if (senderId === userId) {
                $(".message.outgoing .message-meta i.fa").removeClass("fa-check").addClass("fa-check-double text-success");
            }
        };

        // Format timestamp
        function formatTime(timestamp) {
            if (!timestamp) return "";

            const date = new Date(timestamp);
            const now = new Date();
            const isToday = date.toDateString() === now.toDateString();

            if (isToday) {
                return date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
            } else {
                return date.toLocaleDateString([], { day: '2-digit', month: '2-digit' }) + ' ' +
                    date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
            }
        }

        // SignalR connection
        $.connection.hub.start().done(function () {
            // Detect typing
            $("#txtMessage").on("input", function () {
                chat.server.typing(userId, receiverId, fullName);
            });

            // Send on Enter key
            $("#txtMessage").on("keypress", function (e) {
                if (e.which === 13 && !e.shiftKey) {
                    e.preventDefault();
                    sendMessage();
                }
            });

            // Send on button click
            $("#btnSend").on("click", function () {
                sendMessage();
            });

            // Send message function
            function sendMessage() {
                var message = $("#txtMessage").val();
                if (message.trim()) {
                    chat.server.sendMessage(userId, receiverId, fullName, message);
                    $("#txtMessage").val("");
                }
            }

            // Mark messages as read
            if (userId !== receiverId) {
                chat.server.markMessagesAsRead(receiverId, userId);
            }
        });
    </script>
</body>
</html>