<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="/Pages/DoctorMessages.aspx.cs" Inherits="_152120211048_Asrınalp_Şahin_HW4.DoctorMessages" %>
<head runat="server">
    <title>Doctor Messages</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #2563eb;
            --primary-dark: #1e40af;
            --secondary: #f0f9ff;
            --white: #ffffff;
            --gray: #6c757d;
            --gray-dark: #343a40;
            --success: #10b981;
            --danger: #ef4444;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background-color: var(--secondary);
        }

        .layout {
            display: flex;
            min-height: 100vh;
        }

        .sidebar {
            width: 250px;
            background-color: var(--white);
            box-shadow: 2px 0 10px rgba(0,0,0,0.05);
            height: 100vh;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            padding-bottom: 20px;
            position: fixed;
            top: 0;
            left: 0;
        }

        .sidebar-header {
            padding: 20px;
            background-color: var(--primary);
            color: var(--white);
        }

        .doctor-info {
            display: flex;
            align-items: center;
        }

        .doctor-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background-color: var(--secondary);
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 10px;
            color: var(--primary);
            font-size: 24px;
        }

        .doctor-name {
            font-weight: 600;
            font-size: 16px;
        }

        .nav-menu {
            list-style: none;
            padding: 15px;
        }

        .nav-item {
            margin-bottom: 10px;
        }

        .nav-link {
            display: flex;
            align-items: center;
            padding: 12px 15px;
            color: var(--gray-dark);
            text-decoration: none;
            border-radius: 8px;
        }

        .nav-link:hover, .nav-link.active {
            background-color: var(--secondary);
            color: var(--primary);
        }

        .nav-link i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
        }

        .logout-btn {
            margin: 0 15px;
            padding: 12px;
            background-color: var(--danger);
            color: var(--white);
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: background-color 0.2s;
        }

        .logout-btn:hover {
            background-color: #dc2626;
        }
        
        .fa-check-double.text-success {
            color: #4fc3f7 !important;
        }

        .main-content {
            margin-left: 250px;
            flex: 1;
            padding: 30px;
        }

        .message-list {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .message-item {
            background-color: var(--white);
            border-radius: 10px;
            padding: 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 1px 5px rgba(0,0,0,0.05);
            text-decoration: none;
            color: inherit;
        }

        .message-info {
            display: flex;
            flex-direction: column;
        }

        .message-info strong {
            font-size: 16px;
        }

        .message-info span {
            color: var(--gray);
            font-size: 14px;
        }

        .message-meta {
            font-size: 12px;
            color: var(--gray);
            text-align: right;
        }
    </style>
</head>
&nbsp;</html><html xmlns="http://www.w3.org/1999/xhtml"><body><form id="form2" runat="server">
        <div class="layout">
        <!-- Sidebar -->
           <div class="sidebar">         
            <div>
                <div class="sidebar-header">
                    <div class="doctor-info">
                        <div class="doctor-avatar">
                            <i class="fas fa-user-md"></i>
                        </div>
                        <div class="doctor-name">
                            Dr. <asp:Label ID="lblDoctorName" runat="server" />
                        </div>
                    </div>
                </div>
                <ul class="nav-menu">
                    <li class="nav-item">
                        <a id="lnkDashboard" runat="server" href="DoctorDashboard.aspx" class="nav-link">
                            <i class="fas fa-th-large"></i>
                            <span>Dashboard</span>
                        </a>
                        <a id="lnkProfile" runat="server" href="Profile.aspx" class="nav-link">
                            <i class="fas fa-user"></i>
                            <span>Profile</span>
                        </a>
                        <a id="lnkMessages" runat="server" href="DoctorMessages.aspx" class="nav-link">
                            <i class="fas fa-comment-medical"></i>
                            <span>Messages</span>
                        </a>
                    </li>
                </ul>

            </div>

            <!-- Alt kısım: logout -->
            <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="logout-btn" OnClick="btnLogout_Click" />
        </div>



            <!-- Main Content -->
            <div class="main-content">
                <h1>Your Messages</h1>
                <div class="message-list">
                    <asp:Repeater ID="rptMessages" runat="server">
                        <ItemTemplate>
                            <a class="message-item" href='<%# Eval("ChatLink") %>'>
                                <div class="message-info">
                                    <strong><%# Eval("FullName") %></strong>
                                    <span><%# Eval("LastMessage") %></span>
                                </div>
                                <div class="message-meta">
                                    <%# Eval("Timestamp") %><br />
                                    <i class='<%# "fa " + GetSeenIcon(Eval("IsRead")) %>'></i>
                                </div>
                            </a>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>
        </div>
    </form>
</body>
</html>

