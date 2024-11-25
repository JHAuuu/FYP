using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

namespace fyp
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                txtUserName.Focus();
            }
        }

        protected void RegisterButton_Click(object sender, EventArgs e)
        {
            string UserName = txtUserName.Text.Trim();
            string UserEmail = txtEmail.Text.Trim();
            string UserPhoneNumber = txtPhone.Text.Trim();
            string UserAddress = txtAddress.Text.Trim();
            string EduLvl = ddlEducationLevel.SelectedValue;
            string userPassword = newPass.Text.Trim();

            String UserPassword = encryption.HashPassword(userPassword);

            try
            {
                // Check if username or email already exists
                string queryFindUser = "SELECT COUNT(*) FROM [User] WHERE UserName = @UserName OR UserEmail = @UserEmail";
                string[] arrFindUser = new string[4];
                arrFindUser[0] = "@UserName";
                arrFindUser[1] = UserName;
                arrFindUser[2] = "@UserEmail";
                arrFindUser[3] = UserEmail;

                DataTable dt = fyp.DBHelper.ExecuteQuery(queryFindUser, arrFindUser);

                if (dt.Rows.Count > 0 && Convert.ToInt32(dt.Rows[0][0]) > 0)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "showalert", "alert('Username or Email already exists!');", true);
                }
                else
                {
                    // Insert new user
                    string insertUserQuery = "INSERT INTO [User] (UserName, UserEmail, UserPhoneNumber, UserAddress, UserPassword) " +
                                             "VALUES (@UserName, @UserEmail, @UserPhoneNumber, @UserAddress, @UserPassword); " +
                                             "SELECT SCOPE_IDENTITY();";

                    string[] arrInsertUser = new string[10];
                    arrInsertUser[0] = "@UserName";
                    arrInsertUser[1] = UserName;
                    arrInsertUser[2] = "@UserEmail";
                    arrInsertUser[3] = UserEmail;
                    arrInsertUser[4] = "@UserPhoneNumber";
                    arrInsertUser[5] = UserPhoneNumber;
                    arrInsertUser[6] = "@UserAddress";
                    arrInsertUser[7] = UserAddress;
                    arrInsertUser[8] = "@UserPassword";
                    arrInsertUser[9] = UserPassword;

                    object result = fyp.DBHelper.ExecuteScalar(insertUserQuery, arrInsertUser);

                    if (result != null)
                    {
                        int userId = Convert.ToInt32(result);

                        // Insert into Patron table
                        string insertPatronQuery = "INSERT INTO Patron (EduLvl, UserId) VALUES (@EduLvl, @UserId); SELECT SCOPE_IDENTITY();";
                        object[] arrInsertPatron = new object[4];
                        arrInsertPatron[0] = "@EduLvl";
                        arrInsertPatron[1] = EduLvl;
                        arrInsertPatron[2] = "@UserId";
                        arrInsertPatron[3] = userId;

                        object patronResult = fyp.DBHelper.ExecuteScalar(insertPatronQuery, arrInsertPatron);

                        if (patronResult != null)
                        {
                            int patronId = Convert.ToInt32(patronResult);

                            // Insert Trustworthy data
                            string insertTrustQuery = "INSERT INTO Trustworthy (TrustScore, TrustLvl, PatronId) VALUES (@TrustScore, @TrustLvl, @PatronId)";
                            object[] arrInsertTrust = new object[6];
                            arrInsertTrust[0] = "@TrustScore";
                            arrInsertTrust[1] = 100;
                            arrInsertTrust[2] = "@TrustLvl";
                            arrInsertTrust[3] = "high";
                            arrInsertTrust[4] = "@PatronId";
                            arrInsertTrust[5] = patronId;

                            int trustRowsAffected = fyp.DBHelper.ExecuteNonQuery(insertTrustQuery, arrInsertTrust);

                            if (trustRowsAffected > 0)
                            {
                                ScriptManager.RegisterStartupScript(this, this.GetType(), "showalert", "alert('Registration successful!'); window.location='Login.aspx';", true);
                            }
                            else
                            {
                                ScriptManager.RegisterStartupScript(this, this.GetType(), "showalert", "alert('Error occurred while saving Trust data.');", true);
                            }
                        }
                        else
                        {
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "showalert", "alert('Error occurred while registering Patron data.');", true);
                        }
                    }
                    else
                    {
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "showalert", "alert('Error occurred while registering user.');", true);
                    }
                }
            }
            catch (Exception ex)
            {
                string alertMessage = "Error: " + ex.Message;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "showalert", "alert('" + alertMessage.Replace("'", "\\'") + "');", true);
            }
        }





    }
}