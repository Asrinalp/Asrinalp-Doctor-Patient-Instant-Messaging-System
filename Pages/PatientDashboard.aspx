<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="/Pages/PatientDashboard.aspx.cs" Inherits="_152120211048_Asrınalp_Şahin_HW4.PatientDashboard" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Patient Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Font awesome for icons -->
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
            --success: #10b981;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--gray-light);
            color: var(--text);
            line-height: 1.6;
        }

        .layout {
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar */
        .sidebar {
            width: 250px;
            background-color: var(--white);
            box-shadow: 2px 0 10px rgba(0,0,0,0.05);
            transition: all 0.3s;
            position: fixed;
            height: 100%;
            z-index: 100;
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
            transition: all 0.2s;
        }

        .logout-btn:hover {
            background-color: #dc2626;
        }

        .logout-btn i {
            margin-right: 8px;
        }

        /* Main content */
        .main-content {
            margin-left: 250px;
            flex: 1;
            padding: 20px;
        }

        .header {
            background-color: var(--white);
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header h1 {
            font-size: 24px;
            font-weight: 600;
            color: var(--text);
        }

        .container {
            background-color: var(--white);
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            padding: 25px;
            margin-bottom: 25px;
        }

        h2 {
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid var(--secondary);
            color: var(--text);
            font-size: 20px;
            font-weight: 600;
            display: flex;
            align-items: center;
        }

        h2 i {
            margin-right: 10px;
            color: var(--primary);
        }

        .doctor-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 20px;
        }

        .doctor-card {
            border: 1px solid var(--gray-light);
            border-radius: 12px;
            padding: 20px;
            background-color: var(--white);
            box-shadow: 0 2px 10px rgba(0,0,0,0.03);
            transition: all 0.2s;
            display: flex;
            flex-direction: column;
            height: 100%;
        }

        .doctor-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
        }

        .doctor-card h4 {
            margin: 0 0 8px;
            color: var(--text);
            font-size: 16px;
            font-weight: 600;
            display: flex;
            align-items: center;
        }

        .doctor-card h4 i {
            color: var(--primary);
            margin-right: 8px;
        }

        .doctor-card p {
            margin: 0 0 15px;
            color: var(--gray-dark);
            font-size: 14px;
            display: flex;
            align-items: center;
        }

        .doctor-card p i {
            margin-right: 8px;
            color: var(--gray);
        }

        .doctor-card-footer {
            margin-top: auto;
        }

        .btn-chat {
            padding: 10px 15px;
            background-color: var(--primary);
            color: var(--white);
            text-align: center;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            font-size: 14px;
            transition: all 0.2s;
            width: 100%;
            justify-content: center;
        }

        .btn-chat i {
            margin-right: 8px;
        }

        .btn-chat:hover {
            background-color: var(--primary-dark);
        }

        .empty-state {
            text-align: center;
            padding: 30px;
            color: var(--gray);
        }

        .empty-state i {
            font-size: 40px;
            margin-bottom: 15px;
            opacity: 0.5;
        }

        .empty-state p {
            font-size: 16px;
        }

        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 25px;
        }

        .stat-card {
            background-color: var(--white);
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            display: flex;
            align-items: center;
        }

        .stat-icon {
            width: 50px;
            height: 50px;
            border-radius: 12px;
            background-color: var(--secondary);
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            color: var(--primary);
            font-size: 24px;
        }

        .stat-info h3 {
            font-size: 14px;
            color: var(--gray-dark);
            margin: 0;
            font-weight: 500;
        }

        .stat-info p {
            font-size: 20px;
            font-weight: 600;
            color: var(--text);
            margin: 5px 0 0;
        }

        /* For smaller screens */
        @media (max-width: 992px) {
            .sidebar {
                width: 70px;
                overflow: hidden;
            }
            
            .sidebar-header {
                padding: 15px 5px;
                text-align: center;
            }
            
            .patient-info {
                flex-direction: column;
                margin-bottom: 0;
            }
            
            .patient-avatar {
                margin-right: 0;
                margin-bottom: 10px;
            }
            
            .patient-name {
                display: none;
            }
            
            .nav-link {
                justify-content: center;
                padding: 12px;
            }
            
            .nav-link i {
                margin-right: 0;
            }
            
            .nav-link span {
                display: none;
            }
            
            .logout-btn {
                justify-content: center;
            }
            
            .logout-btn i {
                margin-right: 0;
            }
            
            .logout-btn span {
                display: none;
            }
            
            .main-content {
                margin-left: 70px;
            }

            .stats-container {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 576px) {
            .main-content {
                padding: 15px;
            }
            
            .header {
                padding: 15px;
                flex-direction: column;
                align-items: flex-start;
            }
            
            .header h1 {
                margin-bottom: 10px;
            }
            
            .container {
                padding: 15px;
            }
            
            .doctor-list {
                grid-template-columns: 1fr;
            }

            .stats-container {
                grid-template-columns: 1fr;
            }
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
                        <a href="PatientDashboard.aspx" class="nav-link active">
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
                        <a href="FindDoctor.aspx" class="nav-link">
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
                    <h1>Welcome, <asp:Label ID="lblPatientNameHeader" runat="server" /></h1>
                    <div class="date-time">
                        <i class="far fa-calendar-alt"></i> <span id="currentDate"></span>
                    </div>
                </div>

                <div class="stats-container">
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fas fa-user-md"></i>
                        </div>
                        <div class="stat-info">
                            <h3>Your Doctors</h3>
                            <p><asp:Label ID="lblDoctorCount" runat="server" /></p>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fas fa-comments"></i>
                        </div>
                        <div class="stat-info">
                            <h3>Messages</h3>
                            <p><asp:Label ID="lblMessageCount" runat="server" /></p>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fas fa-calendar-check"></i>
                        </div>
                        <div class="stat-info">
                            <h3>Last Activity</h3>
                            <p><asp:Label ID="lblLastActivity" runat="server" /></p>
                        </div>
                    </div>
                </div>

                <div class="container">
                    <h2><i class="fas fa-user-md"></i> Your Doctors</h2>
                    <div class="doctor-list">
                        <asp:DataList ID="dlDoctors" runat="server" RepeatColumns="3" RepeatDirection="Horizontal" RepeatLayout="Flow">
                            <ItemTemplate>
                                <div class="doctor-card">
                                    <div>
                                        <h4><i class="fas fa-user-md"></i> <%# Eval("FullName") %></h4>
                                        <p><i class="fas fa-envelope"></i> <%# Eval("Email") %></p>
                                    </div>
                                    <div class="doctor-card-footer">
                                        <a class="btn-chat" href='Chat.aspx?receiverId=<%# Eval("UserID") %>'>
                                            <i class="fas fa-comment"></i> Send Message
                                        </a>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:DataList>
                    </div>
                </div>
            </div>
        </div>
    </form>

    <script>
        // Display current date
        document.addEventListener('DOMContentLoaded', function() {
            const date = new Date();
            const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
            document.getElementById('currentDate').textContent = date.toLocaleDateString('tr-TR', options);
        });
    </script>
</body>
</html>