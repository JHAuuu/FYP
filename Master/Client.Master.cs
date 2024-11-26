using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Security.Claims;
namespace fyp
{
    public partial class Client : System.Web.UI.MasterPage
    {
        public static int userid = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (HttpContext.Current.User.Identity.IsAuthenticated)
                {
                    // Use ClaimsPrincipal to get claims
                    var identity = (ClaimsPrincipal)HttpContext.Current.User;

                    // Extract claims
                    string userId = identity.FindFirst(ClaimTypes.NameIdentifier)?.Value;
                    string userRole = identity.FindFirst(ClaimTypes.Role)?.Value;
                    string userName = identity.FindFirst(ClaimTypes.Name)?.Value;

                    // Store user details in Session for further use (optional)
                    Session["userId"] = userId;
                    Session["UserRole"] = userRole;
                    Session["UserName"] = userName;

                    if (!string.IsNullOrEmpty(userId) && int.TryParse(userId, out int parsedUserId))
                    {
                        userid = parsedUserId;
                    }

                    // Check the role and hide the dropdown if not Admin or Staff
                    if (userRole != "Admin" && userRole != "Staff")
                    {
                        DashDropdown.Visible = false; // Hides the dropdown
                    }

                }
                else
                {
                    // Anonymous user: ensure safe handling
                    Session["userId"] = null;
                    Session["UserRole"] = null;
                    Session["UserName"] = null;

                    //userid = 0; // Default for anonymous users
                    // For unauthenticated users, hide the dropdown
                    DashDropdown.Visible = false;
                    AccDropdown.Visible = false;
                }
            }
        }
    }
}