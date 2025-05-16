<%-- Page Directive: Specifies the language (C#), code-behind file, and the class this page inherits from --%>
<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="InventoryManagement.aspx.cs" Inherits="SPOT.ACTii.InventoryManagement" %>

<%-- DOCTYPE and HTML structure: Standard HTML5 document with XML namespace for compatibility --%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Inventory Management System</title>
    <%-- Bootstrap CSS for responsive styling and prebuilt components --%>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        <%-- Custom CSS for layout and modal behavior --%>
        .container { margin-top: 20px; } <%-- Adds spacing at the top of the main content --%>
        .table { margin-top: 20px; } <%-- Adds spacing above tables --%>
        .product-image { max-width: 100px; max-height: 100px; } <%-- Limits image size in grids --%>
        .validation-summary { color: red; margin-top: 10px; } <%-- Styles validation error messages --%>
        /* Style for View Products modal to cover ~80% of screen */
        #viewProductsModal .modal-dialog {
            max-width: 80%; <%-- Makes the modal wide for better visibility of the product list --%>
        }
        #viewProductsModal .modal-body {
            max-height: 70vh; <%-- Limits modal body height to 70% of viewport height --%>
            overflow-y: auto; <%-- Enables vertical scrolling for long product lists --%>
        }
        /* Sticky header for gvAllProducts in View Products modal */
        #viewProductsModal .table thead th {
            position: sticky; <%-- Keeps table headers fixed while scrolling --%>
            top: 0;
            z-index: 1; <%-- Ensures headers stay above table content --%>
            background-color: #fff; <%-- Keeps header background white for visibility --%>
        }
    </style>
</head>
<body>
    <%-- ASP.NET form: Wraps all server controls and enables postback functionality --%>
    <form id="form1" runat="server" enctype="multipart/form-data">
        <%-- enctype="multipart/form-data" is required for file uploads (e.g., product images) --%>
        <div class="container">
            <h2>Inventory Management System</h2>
            
            <!-- Form for Adding New Products -->
            <div class="card p-4 mb-4">
                <h4>Add New Product</h4>
                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label">Product Name</label>
                        <%-- TextBox for product name input, styled with Bootstrap --%>
                        <asp:TextBox ID="txtProductName" runat="server" CssClass="form-control" ValidationGroup="AddProduct"></asp:TextBox>
                        <%-- RequiredFieldValidator ensures the field is not empty --%>
                        <asp:RequiredFieldValidator ID="rfvProductName" runat="server" ControlToValidate="txtProductName"
                            ErrorMessage="Product Name is required." CssClass="text-danger" Display="Dynamic" ValidationGroup="AddProduct" />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Category</label>
                        <%-- DropDownList for selecting a category, populated in code-behind --%>
                        <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-control" ValidationGroup="AddProduct" onkeypress="return false;">
                            <asp:ListItem Value="">Select Category</asp:ListItem>
                        </asp:DropDownList>
                        <%-- RequiredFieldValidator ensures a category is selected --%>
                        <asp:RequiredFieldValidator ID="rfvCategory" runat="server" ControlToValidate="ddlCategory"
                            ErrorMessage="Category is required." CssClass="text-danger" Display="Dynamic" ValidationGroup="AddProduct" InitialValue="" />
                    </div>
                </div>
                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label">Price</label>
                        <%-- TextBox for price, restricted to numbers with decimal support --%>
                        <asp:TextBox ID="txtPrice" runat="server" CssClass="form-control" TextMode="Number" step="0.01" ValidationGroup="AddProduct"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvPrice" runat="server" ControlToValidate="txtPrice"
                            ErrorMessage="Price is required." CssClass="text-danger" Display="Dynamic" ValidationGroup="AddProduct" />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Quantity</label>
                        <%-- TextBox for quantity, restricted to whole numbers --%>
                        <asp:TextBox ID="txtQuantity" runat="server" CssClass="form-control" TextMode="Number" ValidationGroup="AddProduct"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvQuantity" runat="server" ControlToValidate="txtQuantity"
                            ErrorMessage="Quantity is required." CssClass="text-danger" Display="Dynamic" ValidationGroup="AddProduct" />
                    </div>
                </div>
                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label">Image (Optional, Max 20 MB)</label>
                        <%-- FileUpload control for uploading product images, restricted to image formats --%>
                        <asp:FileUpload ID="fuProductImage" runat="server" CssClass="form-control" accept=".jpg,.jpeg,.png,.gif" />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Description</label>
                        <%-- Multi-line TextBox for product description --%>
                        <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4"></asp:TextBox>
                    </div>
                    <div class="col-md-6">
                    <label class="form-label">Status</label>
                    <%-- Multi-line TextBox for product description --%>
                    <asp:TextBox ID="txtStatus" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4"></asp:TextBox>
                </div>
                        <div class="col-md-6">
    <label class="form-label">Edition</label>
    <%-- Multi-line TextBox for product description --%>
    <asp:TextBox ID="txtEdition" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4"></asp:TextBox>
</div>
                </div>
                <%-- Button to save the new product, triggers server-side btnSave_Click --%>
                <asp:Button ID="btnSave" runat="server" Text="Save Product" CssClass="btn btn-primary" OnClick="btnSave_Click" CausesValidation="true" ValidationGroup="AddProduct" />
                <%-- ValidationSummary displays all validation errors for the AddProduct group --%>
                <asp:ValidationSummary ID="vsAddProduct" runat="server" CssClass="validation-summary" ValidationGroup="AddProduct" />
                <%-- Label to display success/error messages after saving --%>
                <asp:Label ID="lblMessage" runat="server" CssClass="text-success mt-2" Visible="false"></asp:Label>
            </div>

            <!-- View Products Button -->
            <%-- Bootstrap button to open the View Products modal --%>
            <button type="button" class="btn btn-info mb-3" data-bs-toggle="modal" data-bs-target="#viewProductsModal">View Products</button>

            <!-- Latest Product GridView -->
            <%-- GridView to display a list of products, likely the most recent ones --%>
            <asp:GridView ID="gvProducts" runat="server" AutoGenerateColumns="False" CssClass="table table-striped"
                OnRowCommand="gvProducts_RowCommand" DataKeyNames="ProductID" >
                <Columns>
                    <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                    <asp:BoundField DataField="Category" HeaderText="Category" />
                    <asp:BoundField DataField="Price" HeaderText="Price" DataFormatString="{0:C}" /> <%-- Formats price as currency --%>
                    <asp:BoundField DataField="Quantity" HeaderText="Quantity" />
                    <asp:BoundField DataField="Description" HeaderText="Description" />
                    <asp:BoundField DataField="Status" HeaderText="Status" />
                                        <asp:BoundField DataField="Edition" HeaderText="Edition" />

                    <asp:TemplateField HeaderText="Image">
                        <ItemTemplate>
                            <%-- Displays product image as a base64-encoded string if available --%>
                            <asp:Image ID="imgProduct" runat="server" CssClass="product-image"
                                ImageUrl='<%# Eval("Image") != DBNull.Value ? "data:image/jpeg;base64," + Convert.ToBase64String((byte[])Eval("Image")) : "" %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <%-- Edit button opens the edit modal and passes product data via data attributes --%>
                            <asp:LinkButton ID="btnEdit" runat="server" Text="Edit" CssClass="btn btn-sm btn-warning"
                                data-bs-toggle="modal" data-bs-target="#editModal"
                                data-productid='<%# Eval("ProductID") %>'
                                data-productname='<%# Eval("ProductName") %>'
                                data-category='<%# Eval("Category") %>'
                                data-price='<%# Eval("Price") %>'
                                data-quantity='<%# Eval("Quantity") %>'
                                data-description='<%# Eval("Description") %>' 
                                data-status='<%# Eval("Status") %>' 
                                data-edition='<%# Eval("Edition") %>' />

                            <%-- Delete button triggers server-side deletion with confirmation --%>
                            <asp:Button ID="btnDelete" runat="server" Text="Delete" CommandName="DeleteProduct" 
                                CommandArgument='<%# Eval("ProductID") %>' CssClass="btn btn-sm btn-danger" 
                                OnClientClick="return confirm('Are you sure you want to delete this product?');" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>

            <!-- Edit Product Modal -->
            <div class="modal fade" id="editModal" tabindex="-1" aria-labelledby="editModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="editModalLabel">Edit Product</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <%-- Hidden field to store the ProductID for editing --%>
                            <asp:HiddenField ID="hfModalProductID" runat="server" />
                            <div class="mb-3">
                                <label class="form-label">Product Name</label>
                                <asp:TextBox ID="txtModalProductName" runat="server" CssClass="form-control" ValidationGroup="EditProduct"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvModalProductName" runat="server" ControlToValidate="txtModalProductName"
                                    ErrorMessage="Product Name is required." CssClass="text-danger" Display="Dynamic" ValidationGroup="EditProduct" />
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Category</label>
                                <asp:DropDownList ID="ddlModalCategory" runat="server" CssClass="form-control" ValidationGroup="EditProduct" onkeypress="return false;">
                                    <asp:ListItem Value="">Select Category</asp:ListItem>
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="rfvModalCategory" runat="server" ControlToValidate="ddlModalCategory"
                                    ErrorMessage="Category is required." CssClass="text-danger" Display="Dynamic" ValidationGroup="EditProduct" InitialValue="" />
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Price</label>
                                <asp:TextBox ID="txtModalPrice" runat="server" CssClass="form-control" TextMode="Number" step="0.01" ValidationGroup="EditProduct"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvModalPrice" runat="server" ControlToValidate="txtModalPrice"
                                    ErrorMessage="Price is required." CssClass="text-danger" Display="Dynamic" ValidationGroup="EditProduct" />
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Quantity</label>
                                <asp:TextBox ID="txtModalQuantity" runat="server" CssClass="form-control" TextMode="Number" ValidationGroup="EditProduct"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvModalQuantity" runat="server" ControlToValidate="txtModalQuantity"
                                    ErrorMessage="Quantity is required." CssClass="text-danger" Display="Dynamic" ValidationGroup="EditProduct" />
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Description</label>
                                <asp:TextBox ID="txtModalDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4"></asp:TextBox>
                            </div>
                            <div class="mb-3">
                            <label class="form-label">Status</label>
                            <asp:TextBox ID="txtModalStatus" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4"></asp:TextBox>
                        </div>
                            <div class="mb-3">
                            <label class="form-label">Edition</label>
                            <asp:TextBox ID="txtModalEdition" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4"></asp:TextBox>
                        </div>
                               <div class="mb-3">
                                <label class="form-label">Image (Optional, Max 20 MB)</label>
                                <asp:FileUpload ID="fuModalProductImage" runat="server" CssClass="form-control" accept=".jpg,.jpeg,.png,.gif" />
                            </div>
                        </div>
                        <div class="modal-footer">
                            <%-- Save button triggers server-side btnModalSave_Click --%>
                            <asp:Button ID="btnModalSave" runat="server" Text="Save Changes" CssClass="btn btn-primary" OnClick="btnModalSave_Click" CausesValidation="true" ValidationGroup="EditProduct" />
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- View All Products Modal -->
            <div class="modal fade" id="viewProductsModal" tabindex="-1" aria-labelledby="viewProductsModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-xl">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="viewProductsModalLabel">All Products</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <%-- GridView for displaying all products, similar to gvProducts --%>
                            <asp:GridView ID="gvAllProducts" runat="server" AutoGenerateColumns="False" CssClass="table table-striped"
                                OnRowCommand="gvAllProducts_RowCommand" DataKeyNames="ProductID">
                                <Columns>
                                    <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                    <asp:BoundField DataField="Category" HeaderText="Category" />
                                    <asp:BoundField DataField="Price" HeaderText="Price" DataFormatString="{0:C}" />
                                    <asp:BoundField DataField="Quantity" HeaderText="Quantity" />
                                    <asp:BoundField DataField="Description" HeaderText="Description" />
                                    <asp:BoundField DataField="Status" HeaderText="Status" />
                                    <asp:BoundField DataField="Edition" HeaderText="Edition" />

                                    <asp:TemplateField HeaderText="Image">
                                        <ItemTemplate>
                                            <asp:Image ID="imgProduct" runat="server" CssClass="product-image"
                                                ImageUrl='<%# Eval("Image") != DBNull.Value ? "data:image/jpeg;base64," + Convert.ToBase64String((byte[])Eval("Image")) : "" %>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Actions">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="btnEdit" runat="server" Text="Edit" CssClass="btn btn-sm btn-warning"
                                                data-bs-toggle="modal" data-bs-target="#editModal"
                                                data-productid='<%# Eval("ProductID") %>'
                                                data-productname='<%# Eval("ProductName") %>'
                                                data-category='<%# Eval("Category") %>'
                                                data-price='<%# Eval("Price") %>'
                                                data-quantity='<%# Eval("Quantity") %>'
                                                data-description='<%# Eval("Description") %>'
                                             data-Status='<%# Eval("Status") %>' />
                                            <asp:Button ID="btnDelete" runat="server" Text="Delete" CommandName="DeleteProduct" 
                                                CommandArgument='<%# Eval("ProductID") %>' CssClass="btn btn-sm btn-danger" 
                                                OnClientClick="return confirm('Are you sure you want to delete this product?');" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
    <%-- Bootstrap JS for modal and other interactive components --%>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Populate modal fields when edit button is clicked (for both gvProducts and gvAllProducts)
        document.addEventListener('DOMContentLoaded', function () {
            var editModal = document.getElementById('editModal');
            editModal.addEventListener('show.bs.modal', function (event) {
                var button = event.relatedTarget; // The button that triggered the modal
                // Extract product data from data attributes
                var productId = button.getAttribute('data-productid');
                var productName = button.getAttribute('data-productname');
                var category = button.getAttribute('data-category');
                var price = button.getAttribute('data-price');
                var quantity = button.getAttribute('data-quantity');
                var description = button.getAttribute('data-description');

                // Populate modal fields with product data
                document.getElementById('<%= hfModalProductID.ClientID %>').value = productId;
                document.getElementById('<%= txtModalProductName.ClientID %>').value = productName;
                document.getElementById('<%= ddlModalCategory.ClientID %>').value = category;
                document.getElementById('<%= txtModalPrice.ClientID %>').value = price;
                document.getElementById('<%= txtModalQuantity.ClientID %>').value = quantity;
                document.getElementById('<%= txtModalDescription.ClientID %>').value = description || '';
            });

            // Prevent typing in dropdowns to enforce selection from predefined options
            var dropdowns = document.querySelectorAll('select');
            dropdowns.forEach(function (dropdown) {
                dropdown.addEventListener('input', function (e) {
                    var selectedValue = e.target.value;
                    // Only allow predefined category values
                    if (!['', 'Electronics', 'Clothing', 'Food', 'Books', 'Other'].includes(selectedValue)) {
                        e.target.value = ''; // Reset to empty if invalid
                    }
                });
            });

            // File size validation for both FileUpload controls
            var maxFileSize = 20 * 1024 * 1024; // 20 MB in bytes
            var fileInputs = [
                document.getElementById('<%= fuProductImage.ClientID %>'),
                document.getElementById('<%= fuModalProductImage.ClientID %>')
            ];

            fileInputs.forEach(function (input) {
                if (input) {
                    input.addEventListener('change', function (e) {
                        if (e.target.files.length > 0) {
                            var fileSize = e.target.files[0].size; // Size in bytes
                            if (fileSize > maxFileSize) {
                                alert('File size exceeds 20 MB. Please upload a smaller file.');
                                e.target.value = ''; // Clear the file input
                            }
                        }
                    });
                }
            });
        });
    </script>
</body>
</html>