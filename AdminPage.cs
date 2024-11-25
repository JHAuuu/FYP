using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.Security;
using System.Security.Claims;
using Microsoft.Owin.Security;

namespace fyp.Authentication
{
    public class AdminPage: Page
    {
        protected override void OnLoad(EventArgs e)
        {
            base.OnLoad(e);

            // Check if the user is authenticated
            // Check if the user is authenticated
            if (User.Identity.IsAuthenticated)
            {
                // Use ClaimsPrincipal to retrieve user claims
                var identity = (ClaimsPrincipal)User;

                // Extract claims
                string userId = identity.FindFirst(ClaimTypes.NameIdentifier)?.Value;
                string userRole = identity.FindFirst(ClaimTypes.Role)?.Value;
                string userName = identity.FindFirst(ClaimTypes.Name)?.Value;

                // Check if the user has the "Admin" role
                if (userRole == "Admin" || userRole == "Staff")
                {
                    // Store user details in Session for further use
                    Session["userId"] = userId;
                    Session["UserRole"] = userRole;
                    Session["UserName"] = userName;
                }
                else
                {
                    Response.Redirect("/error/401Unauthorized.aspx", true);
                }
            }
            else
            {
                // Redirect to Login if the user is not authenticated
                Response.Redirect("Login.aspx");
            }
        }
    }
}