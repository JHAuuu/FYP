using System;
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
    }
}
