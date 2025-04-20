<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="/Pages/Profile.aspx.cs" Inherits="_152120211048_Asrınalp_Şahin_HW4.Profile" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>My Profile</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Font awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #2563eb;
            --primary-dark: #1e40af;
            --secondary: #f0f9ff;
            --success: #10b981;
            --success-light: #d1fae5;
            --danger: #ef4444;
            --danger-light: #fee2e2;
            --warning: #f59e0b;
            --gray-light: #f3f4f6;
            --gray: #9ca3af;
            --gray-dark: #4b5563;
            --text: #1f2937;
            --white: #ffffff;
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
            min-height: 100vh;
            display: flex;
            flex-direction: column;
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

        .user-info {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }

        .user-avatar {
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

        .user-name {
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
            padding: 30px;
        }

        .header-title {
            font-size: 28px;
            font-weight: 600;
            margin-bottom: 25px;
            color: var(--text);
            display: flex;
            align-items: center;
        }

        .header-title i {
            margin-right: 12px;
            color: var(--primary);
        }

        .profile-container {
            background-color: var(--white);
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            padding: 0;
            max-width: 800px;
            margin: 0 auto;
            overflow: hidden;
        }
        .error-message {
            font-size: 14px;
            margin-bottom: 10px;
            display: block;
        }

        .profile-header {
            background-color: var(--primary);
            padding: 30px;
            color: var(--white);
            text-align: center;
            position: relative;
        }

        .profile-avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background-color: var(--white);
            margin: 0 auto 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 40px;
            color: var(--primary);
            border: 4px solid rgba(255, 255, 255, 0.3);
        }

        .profile-name {
            font-size: 24px;
            font-weight: 600;
            margin-bottom: 5px;
        }

        .profile-role {
            font-size: 16px;
            opacity: 0.9;
        }

        .profile-form {
            padding: 30px;
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-label {
            display: block;
            font-weight: 500;
            margin-bottom: 8px;
            color: var(--gray-dark);
            font-size: 14px;
        }

        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid var(--gray);
            border-radius: 8px;
            font-size: 16px;
            transition: all 0.2s;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        .password-field {
            position: relative;
        }

        .toggle-password {
            position: absolute;
            right: 14px;
            top: 14px;
            cursor: pointer;
            color: var(--gray);
            width: 6px;
            height: 20px;
        }

        .btn-container {
            display: flex;
            justify-content: space-between;
            gap: 15px;
            margin-top: 20px;
        }

        .btn {
            padding: 12px 20px;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            border: none;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .btn-primary {
            background-color: var(--primary);
            color: var(--white);
            flex: 1;
        }

        .btn-primary:hover {
            background-color: var(--primary-dark);
        }

        .btn-secondary {
            background-color: var(--gray-light);
            color: var(--gray-dark);
            flex: 1;
        }

        .btn-secondary:hover {
            background-color: var(--gray);
            color: var(--white);
        }

        .btn i {
            margin-right: 8px;
        }

        .alert {
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
        }

        .alert i {
            margin-right: 10px;
            font-size: 20px;
        }

        .alert-success {
            background-color: var(--success-light);
            color: var(--success);
        }

        .alert-danger {
            background-color: var(--danger-light);
            color: var(--danger);
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
            
            .user-info {
                flex-direction: column;
                margin-bottom: 0;
            }
            
            .user-avatar {
                margin-right: 0;
                margin-bottom: 10px;
            }
            
            .user-name {
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
        }

        @media (max-width: 576px) {
            .main-content {
                padding: 15px;
            }
            
            .profile-header {
                padding: 20px;
            }
            
            .profile-avatar {
                width: 80px;
                height: 80px;
                font-size: 30px;
            }
            
            .profile-form {
                padding: 20px;
            }
            
            .btn-container {
                flex-direction: column;
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
                    <div class="user-info">
                        <div class="user-avatar">
                            <i class="fas fa-user"></i>
                        </div>
                        <div class="user-name">
                            <asp:Label ID="lblSidebarName" runat="server" />
                        </div>
                    </div>
                </div>
                <ul class="nav-menu">
                    <li class="nav-item">
                        <a id="dashboardLink" runat="server" href="#" class="nav-link">
                            <i class="fas fa-th-large"></i>
                            <span>Dashboard</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="Profile.aspx" class="nav-link active">
                            <i class="fas fa-user"></i>
                            <span>Profile</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a id="messagesLink" runat="server" href="#" class="nav-link">
                            <i class="fas fa-comment-medical"></i>
                            <span>Messages</span>
                        </a>
                    </li>
                </ul>
                <asp:Button ID="btnLogout" runat="server" CssClass="logout-btn" Text="Logout" OnClick="btnLogout_Click" />
            </div>

            <!-- Main Content -->
            <div class="main-content">
                <h1 class="header-title"><i class="fas fa-user-circle"></i> My Profile</h1>
                
                <div class="profile-container">
                    <div class="profile-header">
                        <div class="profile-avatar">
                            <i class="fas fa-user"></i>
                        </div>
                        <div class="profile-name">
                            <asp:Label ID="lblUserName" runat="server" />
                        </div>
                        <div class="profile-role">
                            <asp:Label ID="lblUserRole" runat="server" />
                        </div>
                    </div>
                    
                    <div class="profile-form">
                        <!-- Success/Error Message -->
                        <asp:Panel ID="pnlSuccess" runat="server" CssClass="alert alert-success" Visible="false">
                            <i class="fas fa-check-circle"></i>
                            <asp:Label ID="lblSuccess" runat="server" />
                        </asp:Panel>
                        <asp:Label ID="lblMessage" runat="server" ForeColor="Red" CssClass="error-message" />

                        <asp:Panel ID="pnlError" runat="server" CssClass="alert alert-danger" Visible="false">
                            <i class="fas fa-exclamation-circle"></i>
                            <asp:Label ID="lblError" runat="server" />
                        </asp:Panel>
                        
                        <!-- Profile Form -->
                        <div class="form-group">
                            <label for="txtFullName" class="form-label">Full Name</label>
                            <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control" placeholder="Enter your full name" />
                        </div>
                        
                        <div class="form-group">
                            <label for="txtEmail" class="form-label">Email Address</label>
                            <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-control" placeholder="Enter your email address" />
                        </div>
                        
                        <div class="form-group">
                            <label for="txtPassword" class="form-label">Password</label>
                            <div class="password-field">
                                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Enter your password" />
                                <i id="togglePassword" class="far fa-eye toggle-password"></i>
                            </div>
                        </div>
                        
                        <div class="btn-container">
                            <asp:Button ID="btnUpdate" runat="server" Text="Update Profile" CssClass="btn btn-primary" OnClick="btnUpdate_Click" />
                            <asp:Button ID="btnBackToDashboard" runat="server" Text="Back to Dashboard" CssClass="btn btn-secondary" OnClick="btnBackToDashboard_Click" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>

    <script>
        // Toggle password visibility
        document.addEventListener('DOMContentLoaded', function() {
            const togglePassword = document.getElementById('togglePassword');
            const passwordField = document.getElementById('<%= txtPassword.ClientID %>');
            
            togglePassword.addEventListener('click', function() {
                if (passwordField.type === 'password') {
                    passwordField.type = 'text';
                    togglePassword.classList.remove('fa-eye');
                    togglePassword.classList.add('fa-eye-slash');
                } else {
                    passwordField.type = 'password';
                    togglePassword.classList.remove('fa-eye-slash');
                    togglePassword.classList.add('fa-eye');
                }
            });
        });
    </script>
</body>
</html>