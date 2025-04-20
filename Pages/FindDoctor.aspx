<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="/Pages/FindDoctor.aspx.cs" Inherits="_152120211048_Asrınalp_Şahin_HW4.FindDoctor" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Find Doctor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #10b981;
            --primary-dark: #059669;
            --secondary: #ecfdf5;
            --gray-light: #f3f4f6;
            --gray: #9ca3af;
            --gray-dark: #4b5563;
            --text: #1f2937;
            --white: #ffffff;
            --danger: #ef4444;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--gray-light);
            margin: 0;
            padding: 0;
        }

        .layout {
            display: flex;
            min-height: 100vh;
        }

        .sidebar {
            width: 250px;
            background-color: var(--white);
            box-shadow: 2px 0 10px rgba(0,0,0,0.05);
            position: fixed;
            height: 100%;
            z-index: 100;
            display: flex;
            flex-direction: column;
        }

        .sidebar-header {
            padding: 20px;
            background-color: var(--primary);
            color: var(--white);
        }

        .patient-info {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }

        .patient-avatar {
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

        .patient-name {
            font-weight: 600;
            font-size: 16px;
        }

        .nav-menu {
            padding: 15px;
            list-style: none;
            flex: 1;
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
            transition: all 0.2s;
        }

        .nav-link:hover,
        .nav-link.active {
            background-color: var(--secondary);
            color: var(--primary);
        }

        .nav-link i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
        }

        .logout-btn {
            position: absolute;
            bottom: 20px;
            left: 15px;
            right: 15px;
            padding: 12px;
            background-color: var(--danger);
            color: var(--white);
            border: none;
            border-radius: 8px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 15px;
        }

        .main-content {
            margin-left: 250px;
            flex: 1;
            padding: 30px;
        }

        .header {
            background-color: var(--white);
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            margin-bottom: 20px;
        }

        .header h1 {
            font-size: 24px;
            font-weight: 600;
            color: var(--text);
        }

        .doctor-list {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .doctor-card {
            background-color: var(--white);
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
        }

        .doctor-info h3 {
            margin: 0;
            color: var(--text);
            font-size: 18px;
        }

        .doctor-info p {
            margin: 5px 0 0;
            color: var(--gray-dark);
            font-size: 14px;
        }

        .btn-message {
            background-color: var(--primary);
            color: var(--white);
            padding: 10px 15px;
            border: none;
            border-radius: 6px;
            text-decoration: none;
            font-size: 14px;
            transition: background-color 0.2s;
        }

        .btn-message:hover {
            background-color: var(--primary-dark);
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
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
                <ul class="nav-menu">
                    <li class="nav-item">
                        <a href="PatientDashboard.aspx" class="nav-link">
                            <i class="fas fa-th-large"></i>
                            <span>Dashboard</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="Profile.aspx" class="nav-link">
                            <i class="fas fa-user"></i>
                            <span>Profile</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="Messages.aspx" class="nav-link">
                            <i class="fas fa-comment-medical"></i>
                            <span>Messages</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="FindDoctor.aspx" class="nav-link active">
                            <i class="fas fa-user-md"></i>
                            <span>Find Doctor</span>
                        </a>
                    </li>
                </ul>
                <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="logout-btn" OnClick="btnLogout_Click" />
            </div>

            <!-- Main Content -->
            <div class="main-content">
                <div class="header">
                    <h1>Find a Doctor</h1>
                </div>
                <div class="doctor-list">
                    <asp:Repeater ID="rptDoctors" runat="server">
                        <ItemTemplate>
                            <div class="doctor-card">
                                <div class="doctor-info">
                                    <h3><%# Eval("FullName") %></h3>
                                    <p><i class="fas fa-envelope"></i> <%# Eval("Email") %></p>
                                </div>
                                <a class="btn-message" href='Chat.aspx?receiverId=<%# Eval("UserID") %>'>
                                    <i class="fas fa-comment"></i> Send Message
                                </a>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
