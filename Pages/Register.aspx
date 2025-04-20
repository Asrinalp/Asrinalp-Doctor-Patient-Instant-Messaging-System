<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="/Pages/Register.aspx.cs" Inherits="_152120211048_Asrınalp_Şahin_HW4.Register" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Register</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body, html {
            height: 100%;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .main-container {
            display: flex;
            height: 100vh;
        }

        .left-section {
            width: 40%;
            background: url('Images/doctor-login.jpg') no-repeat center center;
            background-size: cover;
        }

        .right-section {
            width: 60%;
            display: flex;
            justify-content: center;
            align-items: center;
            background-color: #f9f9f9;
        }

        .register-box {
            width: 100%;
            max-width: 400px;
            padding: 40px;
            background-color: white;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
        }

        .register-box h2 {
            margin-bottom: 30px;
            text-align: center;
            color: #333;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            font-weight: bold;
            display: block;
            margin-bottom: 5px;
        }

        .form-group input[type="text"],
        .form-group input[type="password"],
        .form-group input[type="email"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        .btn {
            width: 100%;
            padding: 12px;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
        }

        .btn:hover {
            background-color: #218838;
        }

        .login-link {
            text-align: center;
            margin-top: 15px;
        }

        .login-link a {
            color: #007bff;
            text-decoration: none;
        }

        .login-link a:hover {
            text-decoration: underline;
        }

        .error-message {
            color: red;
            text-align: center;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="main-container">
            <div class="left-section"></div>
            <div class="right-section">
                <div class="register-box">
                    <h2>Patient Registration</h2>
                    <asp:Label ID="lblMessage" runat="server" CssClass="error-message" />
                    <div class="form-group">
                        <label for="txtFullName">Full Name</label>
                        <asp:TextBox ID="txtFullName" runat="server" />
                    </div>
                    <div class="form-group">
                        <label for="txtUsername">Username</label>
                        <asp:TextBox ID="txtUsername" runat="server" />
                    </div>
                    <div class="form-group">
                        <label for="txtPassword">Password</label>
                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" />
                    </div>
                    <div class="form-group">
                        <label for="txtConfirmPassword">Confirm Password</label>
                        <input type="password" id="txtConfirmPassword" class="input" />
                        <span id="matchMessage" style="font-size:13px;"></span>
                    </div>
                    <div class="form-group">
                        <label for="txtEmail">Email</label>
                        <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" />
                    </div>
                    <asp:Button ID="btnRegister" runat="server" Text="Register" CssClass="btn" OnClick="btnRegister_Click" />
                    <div class="login-link">
                        <a href="Login.aspx">Already have an account? Login</a>
                    </div>
                </div>
            </div>
        </div>
    </form>
    <script>
    document.getElementById("txtPassword").addEventListener("input", validatePasswords);
    document.getElementById("txtConfirmPassword").addEventListener("input", validatePasswords);

    function validatePasswords() {
        var pwd = document.getElementById("txtPassword").value;
        var cpwd = document.getElementById("txtConfirmPassword").value;
        var message = document.getElementById("matchMessage");

        if (pwd !== cpwd) {
            message.textContent = "Passwords do not match";
            message.style.color = "red";
        } else {
            message.textContent = "Passwords match";
            message.style.color = "green";
        }
    }
    </script>

</body>
</html>
