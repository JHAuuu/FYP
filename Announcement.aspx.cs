using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace fyp
{
    public partial class Announcement : System.Web.UI.Page
    {
        static int userid = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["PatronId"] != null)
                {
                    userid = Convert.ToInt32(Session["PatronId"].ToString());
                }


                DataTable dtNoti = getAllNoti();
                if(dtNoti.Rows.Count > 0)
                {
                    rptMessage.DataSource = dtNoti;
                    rptMessage.DataBind();
                }
            }
        }

        public DataTable getAllNoti()
        {
            try
            {
                string query = @"SELECT 
    InboxId AS ItemId,
    InboxTitle AS Title,
    InboxContent AS Content,
    SendAt AS DateTime,
    'Inbox' AS ItemType,
    UserId
FROM Inbox
WHERE UserId = @userId

UNION ALL

SELECT 
    AnnouncementId AS ItemId,
    Title,
    Content,
    DateTime,
    'Announcement' AS ItemType,
    NULL AS UserId
FROM Announcement
ORDER BY DateTime DESC;
";
                DataTable dt = DBHelper.ExecuteQuery(query, new string[]
                {
                    "userId",userid.ToString()
                });

                
                    return dt;
               

                 
                
            }
            catch (Exception ex)
            {
                return new DataTable();
            }
        }

    }
}