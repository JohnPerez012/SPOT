using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Web.UI.WebControls;

namespace SPOT.ACTii
{
    public partial class InventoryManagement : System.Web.UI.Page
    {
        private readonly string connectionString = ConfigurationManager.ConnectionStrings["InventoryDB"].ConnectionString;
        private readonly string[] categories = { "Electronics", "Clothing", "Food", "Books", "Other" }; 
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindCategoryDropdowns();    
                BindGrid(); // Bind latest product
                BindAllProductsGrid(); // Bind all products for modal
            }
        }

        private void BindCategoryDropdowns()
        {
            // Bind add form dropdown
            ddlCategory.Items.Clear();
            ddlCategory.Items.Add(new ListItem("Select Category", ""));
            foreach (string category in categories)
            {
                ddlCategory.Items.Add(new ListItem(category, category));
            }

            // Bind modal dropdown
            ddlModalCategory.Items.Clear();
            ddlModalCategory.Items.Add(new ListItem("Select Category", ""));
            foreach (string category in categories)
            {
                ddlModalCategory.Items.Add(new ListItem(category, category));
            }
        }

        private void BindGrid()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    // Fetch only the newest product
                    using (SqlCommand cmd = new SqlCommand("SELECT TOP 1 ProductID, ProductName, Category, Price, Quantity, Description, Status, Edition, Image FROM Products ORDER BY ProductID DESC", con))
                    {
                        using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            sda.Fill(dt);
                            gvProducts.DataSource = dt;
                            gvProducts.DataBind();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error loading latest product: " + ex.Message;
                lblMessage.CssClass = "text-danger mt-2";
                lblMessage.Visible = true;
            }
        }

        private void BindAllProductsGrid()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    // Fetch all products for the modal
                    using (SqlCommand cmd = new SqlCommand("SELECT ProductID, ProductName, Category, Price, Quantity, Description,Status, Edition, Image FROM Products", con))
                    {
                        using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            sda.Fill(dt);
                            gvAllProducts.DataSource = dt;
                            gvAllProducts.DataBind();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error loading all products: " + ex.Message;
                lblMessage.CssClass = "text-danger mt-2";
                lblMessage.Visible = true;
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            try
            {
                if (!Page.IsValid)
                {
                    lblMessage.Text = "Please correct the validation errors.";
                    lblMessage.CssClass = "text-danger mt-2";
                    lblMessage.Visible = true;
                    return;
                }

                // Validate file size
                if (fuProductImage.HasFile)
                {
                    int maxFileSize = 20 * 1024 * 1024; // 20 MB in bytes
                    if (fuProductImage.PostedFile.ContentLength > maxFileSize)
                    {
                        lblMessage.Text = "File size exceeds 20 MB. Please upload a smaller file.";
                        lblMessage.CssClass = "text-danger mt-2";
                        lblMessage.Visible = true;
                        return;
                    }
                }

                // Validate category
                string selectedCategory = ddlCategory.SelectedValue.Trim();
                if (string.IsNullOrEmpty(selectedCategory) || !categories.Contains(selectedCategory))
                {
                    lblMessage.Text = "Please select a valid category.";
                    lblMessage.CssClass = "text-danger mt-2";
                    lblMessage.Visible = true;
                    return;
                }

                // Validate price
                if (!decimal.TryParse(txtPrice.Text, out decimal price))
                {
                    lblMessage.Text = "Invalid price format.";
                    lblMessage.CssClass = "text-danger mt-2";
                    lblMessage.Visible = true;
                    return;
                }

                // Validate quantity
                if (!int.TryParse(txtQuantity.Text, out int quantity))
                {
                    lblMessage.Text = "Invalid quantity format.";
                    lblMessage.CssClass = "text-danger mt-2";
                    lblMessage.Visible = true;
                    return;
                }

                // Validate image
                byte[] imageData = null;
                if (fuProductImage.HasFile)
                {
                    string[] allowedExtensions = { ".jpg", ".jpeg", ".png", ".gif" };
                    string extension = Path.GetExtension(fuProductImage.FileName).ToLower();
                    if (!allowedExtensions.Contains(extension))
                    {
                        lblMessage.Text = "Invalid image format. Only .jpg, .jpeg, .png, .gif are allowed.";
                        lblMessage.CssClass = "text-danger mt-2";
                        lblMessage.Visible = true;
                        return;
                    }

                    using (Stream fs = fuProductImage.PostedFile.InputStream)
                    {
                        imageData = new byte[fs.Length];
                        fs.Read(imageData, 0, (int)fs.Length);
                    }
                }

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = "INSERT INTO Products (ProductName, Category, Price, Quantity, Description,Status, Edition, Image) VALUES (@ProductName, @Category, @Price, @Quantity, @Description,@Status,@Edition, @Image)";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.Add("@ProductName", SqlDbType.NVarChar).Value = txtProductName.Text.Trim();
                        cmd.Parameters.Add("@Category", SqlDbType.NVarChar).Value = selectedCategory;
                        cmd.Parameters.Add("@Price", SqlDbType.Decimal).Value = price;
                        cmd.Parameters.Add("@Quantity", SqlDbType.Int).Value = quantity;
                        cmd.Parameters.Add("@Description", SqlDbType.NVarChar).Value = txtDescription.Text ?? string.Empty;
                        cmd.Parameters.Add("@Status", SqlDbType.NVarChar).Value = txtStatus.Text ?? string.Empty;
                        cmd.Parameters.Add("@Edition", SqlDbType.NVarChar).Value = txtEdition.Text ?? string.Empty;
                        cmd.Parameters.Add("@Image", SqlDbType.VarBinary).Value = imageData ?? (object)DBNull.Value;

                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();
                    }
                }

                ClearAddForm();
                BindGrid(); // Update to show newest product
                BindAllProductsGrid(); // Update modal data
                lblMessage.Text = "Product added successfully!";
                lblMessage.CssClass = "text-success mt-2";
                lblMessage.Visible = true;
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error adding product: " + ex.Message;
                lblMessage.CssClass = "text-danger mt-2";
                lblMessage.Visible = true;
            }
        }

        // Helper method to get existing image from database
        private byte[] GetExistingImage(int productId)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = "SELECT Image FROM Products WHERE ProductID = @ProductID";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.Add("@ProductID", SqlDbType.Int).Value = productId;
                        con.Open();
                        var result = cmd.ExecuteScalar();
                        con.Close();
                        return result != DBNull.Value ? (byte[])result : null;
                    }
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error retrieving existing image: " + ex.Message;
                lblMessage.CssClass = "text-danger mt-2";
                lblMessage.Visible = true;
                return null;
            }
        }

        protected void btnModalSave_Click(object sender, EventArgs e)
        {
            try
            {
                if (!Page.IsValid)
                {
                    lblMessage.Text = "Please correct the validation errors.";
                    lblMessage.CssClass = "text-danger mt-2";
                    lblMessage.Visible = true;
                    return;
                }

                // Validate file size
                if (fuModalProductImage.HasFile)
                {
                    int maxFileSize = 20 * 1024 * 1024; // 20 MB in bytes
                    if (fuModalProductImage.PostedFile.ContentLength > maxFileSize)
                    {
                        lblMessage.Text = "File size exceeds 20 MB. Please upload a smaller file.";
                        lblMessage.CssClass = "text-danger mt-2";
                        lblMessage.Visible = true;
                        return;
                    }
                }

                // Validate category
                string selectedCategory = ddlModalCategory.SelectedValue.Trim();
                if (string.IsNullOrEmpty(selectedCategory) || !categories.Contains(selectedCategory))
                {
                    lblMessage.Text = "Please select a valid category in modal.";
                    lblMessage.CssClass = "text-danger mt-2";
                    lblMessage.Visible = true;
                    return;
                }

                // Validate price
                if (!decimal.TryParse(txtModalPrice.Text, out decimal price))
                {
                    lblMessage.Text = "Invalid price format in modal.";
                    lblMessage.CssClass = "text-danger mt-2";
                    lblMessage.Visible = true;
                    return;
                }

                // Validate quantity
                if (!int.TryParse(txtModalQuantity.Text, out int quantity))
                {
                    lblMessage.Text = "Invalid quantity format in modal.";
                    lblMessage.CssClass = "text-danger mt-2";
                    lblMessage.Visible = true;
                    return;
                }

                // Validate and process image
                byte[] imageData = null;
                if (fuModalProductImage.HasFile)
                {
                    string[] allowedExtensions = { ".jpg", ".jpeg", ".png", ".gif" };
                    string extension = Path.GetExtension(fuModalProductImage.FileName).ToLower();
                    if (!allowedExtensions.Contains(extension))
                    {
                        lblMessage.Text = "Invalid image format. Only .jpg, .jpeg, .png, .gif are allowed.";
                        lblMessage.CssClass = "text-danger mt-2";
                        lblMessage.Visible = true;
                        return;
                    }

                    using (Stream fs = fuModalProductImage.PostedFile.InputStream)
                    {
                        imageData = new byte[fs.Length];
                        fs.Read(imageData, 0, (int)fs.Length);
                    }
                }
                else
                {
                    // No new image uploaded; retrieve existing image
                    int productId = Convert.ToInt32(hfModalProductID.Value);
                    imageData = GetExistingImage(productId);
                }

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = "UPDATE Products SET ProductName=@ProductName, Category=@Category, Price=@Price, Quantity=@Quantity, Description=@Description,Status=@Status,Edition=@Edition, Image=@Image WHERE ProductID=@ProductID";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.Add("@ProductID", SqlDbType.Int).Value = Convert.ToInt32(hfModalProductID.Value);
                        cmd.Parameters.Add("@ProductName", SqlDbType.NVarChar).Value = txtModalProductName.Text.Trim();
                        cmd.Parameters.Add("@Category", SqlDbType.NVarChar).Value = selectedCategory;
                        cmd.Parameters.Add("@Price", SqlDbType.Decimal).Value = price;
                        cmd.Parameters.Add("@Quantity", SqlDbType.Int).Value = quantity;
                        cmd.Parameters.Add("@Description", SqlDbType.NVarChar).Value = txtModalDescription.Text ?? string.Empty;
                        cmd.Parameters.Add("@Status", SqlDbType.NVarChar).Value = txtModalStatus.Text ?? string.Empty;
                        cmd.Parameters.Add("@Edition", SqlDbType.NVarChar).Value = txtModalEdition.Text ?? string.Empty;
                        cmd.Parameters.Add("@Image", SqlDbType.VarBinary).Value = imageData ?? (object)DBNull.Value;

                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();
                    }
                }

                BindGrid(); // Update to show newest product
                BindAllProductsGrid(); // Update modal data
                lblMessage.Text = "Product updated successfully!";
                lblMessage.CssClass = "text-success mt-2";
                lblMessage.Visible = true;
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error updating product: " + ex.Message;
                lblMessage.CssClass = "text-danger mt-2";
                lblMessage.Visible = true;
            }
        }

      /*
       
       DELETE
       
        
       */
        protected void gvProducts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            try
            {
                int productID = Convert.ToInt32(e.CommandArgument);

                if (e.CommandName == "DeleteProduct")
                {
                    using (SqlConnection con = new SqlConnection(connectionString))
                    {
                        using (SqlCommand cmd = new SqlCommand("DELETE FROM Products WHERE ProductID=@ProductID", con))
                        {
                            cmd.Parameters.Add("@ProductID", SqlDbType.Int).Value = productID;
                            con.Open();
                            int rowsAffected = cmd.ExecuteNonQuery();
                            con.Close();

                            if (rowsAffected == 0)
                            {
                                lblMessage.Text = "Failed to delete product. It may not exist in the database.";
                                lblMessage.CssClass = "text-danger mt-2";
                                lblMessage.Visible = true;
                                return;
                            }
                        }
                    }
                    lblMessage.Text = "Product deleted successfully!";
                    lblMessage.CssClass = "text-success mt-2";
                    lblMessage.Visible = true;
                    BindGrid(); // Update to show newest product
                    BindAllProductsGrid(); // Update modal data
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error deleting product: " + ex.Message;
                lblMessage.CssClass = "text-danger mt-2";
                lblMessage.Visible = true;
            }
        }

        protected void gvAllProducts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            try
            {
                int productID = Convert.ToInt32(e.CommandArgument);

                if (e.CommandName == "DeleteProduct")
                {
                    using (SqlConnection con = new SqlConnection(connectionString))
                    {
                        using (SqlCommand cmd = new SqlCommand("DELETE FROM Products WHERE ProductID=@ProductID", con))
                        {
                            cmd.Parameters.Add("@ProductID", SqlDbType.Int).Value = productID;
                            con.Open();
                            int rowsAffected = cmd.ExecuteNonQuery();
                            con.Close();

                            if (rowsAffected == 0)
                            {
                                lblMessage.Text = "Failed to delete product. It may not exist in the database.";
                                lblMessage.CssClass = "text-danger mt-2";
                                lblMessage.Visible = true;
                                return;
                            }
                        }
                    }
                    lblMessage.Text = "Product deleted successfully!";
                    lblMessage.CssClass = "text-success mt-2";
                    lblMessage.Visible = true;
                    BindGrid(); // Update to show newest product
                    BindAllProductsGrid(); // Update modal data
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error deleting product: " + ex.Message;
                lblMessage.CssClass = "text-danger mt-2";
                lblMessage.Visible = true;
            }
        }

        private void ClearAddForm()
        {
            txtProductName.Text = string.Empty;
            ddlCategory.SelectedIndex = 0;
            txtPrice.Text = string.Empty;
            txtQuantity.Text = string.Empty;
            txtDescription.Text = string.Empty;
            lblMessage.Visible = false;
        }
    }
}