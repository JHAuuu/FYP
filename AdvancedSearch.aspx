<%@ Page Language="C#" MasterPageFile="~/Master/Client.Master" AutoEventWireup="true" CodeBehind="AdvancedSearch.aspx.cs" Inherits="fyp.AdvancedSearch" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Search Book
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
    <link rel="stylesheet" href="assets/css/main.css" />
    <link rel="stylesheet" href="assets/css/bookSearch.css" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        /* General Styles */
        .search-container {
            max-width: 800px;
            margin: 20px auto;
        }

        h1 {
            text-align: left;
            font-size: 24px;
            margin-bottom: 20px;
        }

        .search-form, .date-filters {
            display: flex;
            flex-direction: column;
        }

        .title-row, .input-row {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr 1fr 40px; /* Adjusted for '×' button */
            gap: 10px;
            align-items: center; /* Aligns content vertically */
            text-align: center; /* Centers text horizontally */
        }

            .title-row label {
                font-size: 14px;
                font-weight: bold;
                margin: 0;
            }

            .input-row select, .input-row input {
                padding: 8px;
                font-size: 14px;
                border: 1px solid #ccc;
                border-radius: 5px;
                box-sizing: border-box; /* Ensures consistent box dimensions */
            }

        .hidden-column {
            visibility: hidden; /* Keeps the space but hides content */
            opacity: 0; /* Makes it fully transparent */
            transition: visibility 0s, opacity 0.3s ease;
        }

            .hidden-column.show {
                visibility: visible; /* Reveals content */
                opacity: 1; /* Makes it fully visible */
            }

        .search-button-row {
            margin-top: 10px;
            text-align: right;
        }

            .search-button-row button {
                background-color: #2b74a9;
                color: white;
                padding: 10px 20px;
                font-size: 16px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
            }

                .search-button-row button:hover {
                    background-color: #1a5b7a;
                }

        .date-filters {
            margin-top: 20px;
            padding: 10px;
            background-color: #f9f9f9;
            border-radius: 10px;
            box-shadow: 0px 2px 10px rgba(0, 0, 0, 0.1);
        }

            /* Date Filters Section */
            .date-filters .title-row {
                display: grid;
                grid-template-columns: 1fr 1fr 1fr; /* Three equal columns */
                gap: 10px;
                text-align: center;
            }

            .date-filters .input-row {
                display: grid;
                grid-template-columns: 1fr 1fr 1fr; /* Three equal columns */
                gap: 10px;
                align-items: center;
            }

            .date-filters select, .date-filters input {
                padding: 8px;
                font-size: 14px;
                border: 1px solid #ccc;
                border-radius: 5px;
                box-sizing: border-box; /* Ensures consistent box dimensions */
            }

        .reset-button {
            margin-top: 10px;
            text-align: right;
        }

            .reset-button button {
                background-color: #e0e0e0;
                color: black;
                padding: 10px 20px;
                font-size: 16px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
            }

                .reset-button button:hover {
                    background-color: #d3d3d3;
                }

        .date-filters .search-button-row {
            margin-top: 10px;
            text-align: right;
        }

            .date-filters .search-button-row button {
                background-color: #2b74a9;
                color: white;
                padding: 10px 20px;
                font-size: 16px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
            }

                .date-filters .search-button-row button:hover {
                    background-color: #1a5b7a;
                }

        /* Remove button style for each search field */
        .remove-btn {
            background-color: red;
            color: white;
            font-size: 16px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            padding: 8px;
        }

            .remove-btn:hover {
                background-color: darkred;
            }

        /* Add New Search Field Button */
        #addNewField {
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            font-size: 14px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

            #addNewField:hover {
                background-color: #45a049;
            }
    </style>
    <form class="search-form" runat="server">
        <div class="search-container">
            <h1>Search 1,147,721 records for:</h1>


            <!-- Title Row -->
            <div class="title-row" style="width: 100%;">
                <label for="hiddenColumn"></label>
                <label for="searchIn">Search In</label>
                <label for="contains">Contains</label>
                <label for="searchTerm">Search Term</label>
            </div>

            <div id="searchFieldsContainer">
                <!-- Input Row -->
                <div class="input-row" style="width: 100%;">
                    <div class="hidden-column">
                        <input type="text" placeholder="Hidden content here" />
                    </div>
                    <select>
                        <option value="allFields">All fields</option>
                        <option value="title">Title</option>
                        <option value="author">Author</option>
                    </select>
                    <select>
                        <option value="allWords">All words</option>
                        <option value="exact">Exact match</option>
                        <option value="anyWords">Any words</option>
                    </select>
                    <input type="text" placeholder="Enter search term" />
                    <button type="button" class="remove-btn" style="visibility: hidden;">×</button>
                </div>
            </div>
            <div style="text-align: right; margin-top: 10px;">
                <button type="button" id="addNewField" style="background-color: #444; padding: 10px 20px; font-size: 14px; border: none; border-radius: 5px; cursor: pointer;">+ Add New Search Field</button>
            </div>
            <!-- Date Filters Section -->
            <div class="date-filters">
                <!-- Title Row -->
                <div class="title-row">
                    <label for="timePeriod">Time Period</label>
                    <label for="fromDate">From Date</label>
                    <label for="toDate">To Date</label>
                </div>

                <!-- Input Row -->
                <div class="input-row">
                    <select id="timePeriod">
                        <option value="allTime">All time</option>
                        <option value="lastYear">Last year</option>
                        <option value="lastMonth">Last month</option>
                    </select>
                    <input type="date" id="fromDate" />
                    <input type="date" id="toDate" />
                </div>

                <!-- Reset Button Row -->
                <div class="reset-button">
                    <button type="button" id="btnReset">Reset</button>
                    <asp:Button ID="btnSearch" runat="server" Text="Search" />
                </div>
            </div>
            <small style="font-size: .9286rem;">Search Tips ::<asp:HyperLink ID="HyperLink1" runat="server" Style="border: none; color: #2b74a9;" NavigateUrl="~/BookSearch.aspx">Simple Search</asp:HyperLink></small>
        </div>
    </form>
    <script>
        document.getElementById('addNewField').addEventListener('click', function () {
            // Get the container for input rows
            const container = document.getElementById('searchFieldsContainer');

            // Create a new input row
            const newRow = document.createElement('div');
            newRow.className = 'input-row';
            newRow.style.width = '100%';

            // Add hidden column
            const hiddenColumn = document.createElement('div');
            hiddenColumn.className = 'hidden-column';
            const hiddenInput = document.createElement('input');
            hiddenInput.type = 'text';
            hiddenInput.placeholder = 'Hidden content here';
            hiddenColumn.appendChild(hiddenInput);

            // Add searchIn dropdown
            const searchInSelect = document.createElement('select');
            searchInSelect.innerHTML = `
            <option value="allFields">All fields</option>
            <option value="title">Title</option>
            <option value="author">Author</option>
        `;

            // Add contains dropdown
            const containsSelect = document.createElement('select');
            containsSelect.innerHTML = `
            <option value="allWords">All words</option>
            <option value="exact">Exact match</option>
            <option value="anyWords">Any words</option>
        `;

            // Add search term input
            const searchTermInput = document.createElement('input');
            searchTermInput.type = 'text';
            searchTermInput.placeholder = 'Enter search term';

            // Add remove button
            const removeBtn = document.createElement('button');
            removeBtn.type = 'button';
            removeBtn.className = 'remove-btn';
            removeBtn.textContent = '×';
            removeBtn.style.cssText = `
            background-color: red; 
            color: white; 
            font-size: 16px; 
            padding: 5px 10px; 
            border: none; 
            border-radius: 5px; 
            cursor: pointer;
        `;
            removeBtn.addEventListener('click', function () {
                container.removeChild(newRow);
            });

            // Append elements to the new row
            newRow.appendChild(hiddenColumn);
            newRow.appendChild(searchInSelect);
            newRow.appendChild(containsSelect);
            newRow.appendChild(searchTermInput);
            newRow.appendChild(removeBtn);

            // Append the new row to the container
            container.appendChild(newRow);
        });

        // Add functionality to remove button in the first row if needed
        const firstRowRemoveBtn = document.querySelector('.input-row .remove-btn');
        if (firstRowRemoveBtn) {
            firstRowRemoveBtn.style.display = 'block';
            firstRowRemoveBtn.addEventListener('click', function () {
                const container = document.getElementById('searchFieldsContainer');
                const row = this.closest('.input-row');
                container.removeChild(row);
            });
        }
</script>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ScriptContent" runat="server">
    <!-- Scripts -->
    <script src="assets/js/jquery.min.js"></script>
    <script src="assets/js/jquery.dropotron.min.js"></script>
    <script src="assets/js/jquery.scrolly.min.js"></script>
    <script src="assets/js/jquery.scrollex.min.js"></script>
    <script src="assets/js/browser.min.js"></script>
    <script src="assets/js/breakpoints.min.js"></script>
    <script src="assets/js/util.js"></script>
    <script src="assets/js/main.js"></script>
    <script src="assets/js/pagination.js"></script>
</asp:Content>
