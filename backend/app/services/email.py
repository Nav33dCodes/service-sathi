import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from app.core.config import settings

def send_email(subject: str, html_content: str, to_email: str):
    # Fallback to printing in console if credentials aren't set yet
    if not settings.smtp_username or not settings.smtp_password:
        print("\n" + "="*50)
        print(f"SMTP WARNING: Email configuration missing in .env.")
        print(f"To: {to_email}")
        print(f"Subject: {subject}")
        print(f"HTML Body Preview:")
        print(html_content[:500] + "...")
        print("="*50 + "\n")
        return

    try:
        # Create message container
        msg = MIMEMultipart('alternative')
        msg['Subject'] = subject
        msg['From'] = settings.smtp_username
        msg['To'] = to_email

        # HTML content
        part = MIMEText(html_content, 'html')
        msg.attach(part)

        # Connect to Gmail SMTP
        server = smtplib.SMTP(settings.smtp_host, settings.smtp_port)
        server.starttls() # Enable security
        server.login(settings.smtp_username, settings.smtp_password)
        server.sendmail(settings.smtp_username, to_email, msg.as_string())
        server.quit()
        print(f"Email successfully sent to {to_email} with subject: '{subject}'")
    except Exception as e:
        print(f"Error sending email to {to_email}: {str(e)}")

def send_welcome_email(email_to: str, user_name: str):
    subject = "Welcome to ServiceSathi AI Orchestrator!"
    
    html_content = f"""
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="utf-8">
        <title>Welcome to ServiceSathi</title>
        <style>
            body {{
                font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
                background-color: #000000;
                color: #ffffff;
                margin: 0;
                padding: 0;
            }}
            .container {{
                max-width: 600px;
                margin: 20px auto;
                background-color: #0d0d0d;
                border: 1px solid #1a1a1a;
                border-radius: 12px;
                padding: 40px;
                box-shadow: 0 4px 20px rgba(0, 255, 157, 0.1);
            }}
            .header {{
                text-align: center;
                border-bottom: 1px solid #1a1a1a;
                padding-bottom: 20px;
                margin-bottom: 30px;
            }}
            .logo {{
                font-size: 28px;
                font-weight: bold;
                color: #00FF9D;
                letter-spacing: 1px;
            }}
            h1 {{
                color: #ffffff;
                font-size: 24px;
                margin-top: 0;
            }}
            p {{
                color: #a0a0a0;
                font-size: 16px;
                line-height: 1.6;
            }}
            .button {{
                display: inline-block;
                background: linear-gradient(135deg, #00FF9D, #00BFA5);
                color: #000000 !important;
                text-decoration: none;
                padding: 14px 30px;
                font-weight: bold;
                border-radius: 8px;
                margin-top: 20px;
                text-align: center;
            }}
            .footer {{
                margin-top: 40px;
                border-top: 1px solid #1a1a1a;
                padding-top: 20px;
                text-align: center;
                font-size: 12px;
                color: #606060;
            }}
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <div class="logo">ServiceSathi AI</div>
            </div>
            <h1>Assalam-o-Alaikum, {user_name}!</h1>
            <p>Welcome to ServiceSathi, your futuristic multi-agent AI orchestrator. We are absolutely thrilled to have you onboard.</p>
            <p>Whether you need an AC repair technician, an electrician, a painter, or emergency support, our AI agent scans live databases, selects the best provider, and manages the entire pipeline for you.</p>
            <div style="text-align: center;">
                <a href="#" class="button">Open App & Get Started</a>
            </div>
            <p style="margin-top: 30px;">If you have any questions or feedback, simply hit reply. Our team is here to assist you.</p>
            <div class="footer">
                <p>&copy; 2026 ServiceSathi AI. All rights reserved.</p>
            </div>
        </div>
    </body>
    </html>
    """
    
    send_email(subject, html_content, email_to)

def send_reset_otp_email(email_to: str, otp: str):
    subject = "Reset Your ServiceSathi AI Password"
    
    html_content = f"""
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="utf-8">
        <title>Reset Password</title>
        <style>
            body {{
                font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
                background-color: #000000;
                color: #ffffff;
                margin: 0;
                padding: 0;
            }}
            .container {{
                max-width: 600px;
                margin: 20px auto;
                background-color: #0d0d0d;
                border: 1px solid #1a1a1a;
                border-radius: 12px;
                padding: 40px;
                box-shadow: 0 4px 20px rgba(255, 171, 0, 0.1);
            }}
            .header {{
                text-align: center;
                border-bottom: 1px solid #1a1a1a;
                padding-bottom: 20px;
                margin-bottom: 30px;
            }}
            .logo {{
                font-size: 28px;
                font-weight: bold;
                color: #00FF9D;
                letter-spacing: 1px;
            }}
            h1 {{
                color: #ffffff;
                font-size: 24px;
                margin-top: 0;
            }}
            p {{
                color: #a0a0a0;
                font-size: 16px;
                line-height: 1.6;
            }}
            .otp-box {{
                background-color: #1a1a1a;
                border: 1px solid #333333;
                border-radius: 8px;
                padding: 20px;
                text-align: center;
                font-size: 32px;
                font-weight: bold;
                letter-spacing: 6px;
                color: #00FF9D;
                margin: 30px 0;
            }}
            .footer {{
                margin-top: 40px;
                border-top: 1px solid #1a1a1a;
                padding-top: 20px;
                text-align: center;
                font-size: 12px;
                color: #606060;
            }}
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <div class="logo">ServiceSathi AI</div>
            </div>
            <h1>Password Reset Request</h1>
            <p>We received a request to reset the password for your ServiceSathi AI account. Use the following One-Time Password (OTP) to complete the reset. This code is active for 10 minutes.</p>
            <div class="otp-box">{otp}</div>
            <p>If you did not request a password reset, please ignore this email or contact support if you have security concerns.</p>
            <div class="footer">
                <p>&copy; 2026 ServiceSathi AI. All rights reserved.</p>
            </div>
        </div>
    </body>
    </html>
    """
    
    send_email(subject, html_content, email_to)
