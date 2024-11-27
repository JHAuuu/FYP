﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Security.Claims;
namespace fyp
{
    public partial class Home : System.Web.UI.Page
    {
        public static int userid = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (User.Identity.IsAuthenticated)
                {
                    // Use ClaimsPrincipal to get claims
                    var identity = (System.Security.Claims.ClaimsPrincipal)User;

                    // Extract claims
                    string userId = identity.FindFirst(ClaimTypes.NameIdentifier)?.Value;
                    string userRole = identity.FindFirst(ClaimTypes.Role)?.Value;
                    string userName = identity.FindFirst(ClaimTypes.Name)?.Value;

                    // Store user details in Session for further use (optional)
                    Session["userId"] = userId;
                    Session["UserRole"] = userRole;
                    Session["UserName"] = userName;
                }

                if(!string.IsNullOrEmpty(Session["userId"].ToString()))
                {
                    userid = Convert.ToInt32(Session["userId"].ToString());
                }
                
            }
        }
<<<<<<< Updated upstream
=======


        public int getNotiCount()
        {
            try
            {
                if (!String.IsNullOrEmpty(Session["PatronId"].ToString()))
                {
                    string userid = Session["PatronId"].ToString();
                    string query = @"SELECT COUNT(*) AS TotalItems
FROM (
    SELECT 
        i.InboxId AS ItemId
    FROM Inbox i
    LEFT JOIN InboxStatus s ON i.InboxId = s.InboxId AND i.UserId = s.UserId
    WHERE i.UserId = @userId

    UNION ALL

    SELECT 
        a.AnnouncementId AS ItemId
    FROM Announcement a
    LEFT JOIN AnnouncementStatus s ON a.AnnouncementId = s.AnnouncementId
    WHERE s.UserId = @userId
) AS CombinedItems;";

                    int getTotalNoti = Convert.ToInt32(DBHelper.ExecuteScalar(query, new string[]{
                        "userId", userid
                }));

                    return getTotalNoti;
                }
                else
                {
                    return 0;
                }

            }
            catch (Exception ex)
            {
                Console.WriteLine("Error in getNotiCount: " + ex.Message);
                return 0;
            }
        }

>>>>>>> Stashed changes
    }
}
