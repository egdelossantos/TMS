using System;
using System.Linq;
using System.Net;
using System.Net.Mail;

namespace TMS.Logic.Service
{
    public class EmailNotificationHandler
    {
        private readonly string appEnvironment;

        private readonly string appName;

        private readonly string domainName;

        private readonly string[] sendEnvironments;

        private readonly string mailServer;

        private SmtpClient smtpClient;

        public EmailNotificationHandler()
        {
            appEnvironment = ApplicationConfig.ApplicationEnvironment;

            mailServer = "relay-hosting.secureserver.net"; // godaddy mail server

            sendEnvironments = new[] { "PROD" };

            appName = "Territory Management System";

            domainName = ApplicationConfig.DomainName;            
        }

        public string ResetPasswordEmailBody(string encryptedLogon)
        {
            string body =
                string.Format(
                    @"
                          <html>
                            <body>
                                <div style='margin-bottom:10px;'>
                                    This is to notify that you have recently requested for a password change for {0}.
                                </div>                                                     
                                <div style='margin-bottom:20px;'>
                                     To change password, please click <a href='{1}' target='_blank'>HERE</a>.
                                </div>                                           
                                <div style='margin-bottom:40px;'>
                                     If the above link does not work please copy and paste this link into a browser: {1}
                                </div>
                                <div>
                                    {0} Notification
                                </div>
                            </body> 
                        </html>",
                    appName,
                    domainName + "/Account/ResetPassword?id=" + encryptedLogon);

            return body;
        }

        public string ResetPasswordEmailSubject()
        {
            return string.Format("{0} account password reset", appName);
        }

        public bool SendEmailNotification(string to, string from, string subject, string body)
        {
            try
            {
                // we will on send email only if current environment is allowed to send
                bool send = sendEnvironments.Contains(appEnvironment);

                InitialiseSmtp();
                var mailMessage = new MailMessage(from, to, subject, body) { IsBodyHtml = true };

                if (send)
                {
                    smtpClient.Send(mailMessage);
                }
                
                return true;               
            }
            catch (Exception ex)
            {                
                return false;
            }            
        }

        private void InitialiseSmtp()
        {
            //smtpClient = new SmtpClient();
            //smtpClient.Host = "smtpout.secureserver.net";
            //smtpClient.Port = 25;
            //smtpClient.Timeout = 10000;
            //smtpClient.DeliveryMethod = SmtpDeliveryMethod.Network;
            //smtpClient.UseDefaultCredentials = false;
            //smtpClient.Credentials = new NetworkCredential();
            // 3535
            smtpClient = new SmtpClient(mailServer, 25);
            smtpClient.EnableSsl = false;
            smtpClient.UseDefaultCredentials = false;
            smtpClient.Credentials = new NetworkCredential();
            smtpClient.DeliveryMethod = SmtpDeliveryMethod.Network;
        }
    }
}