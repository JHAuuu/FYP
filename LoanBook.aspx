﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Client.Master" AutoEventWireup="true" CodeBehind="LoanBook.aspx.cs" Inherits="fyp.LoanBook" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Loan Book
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
    <link rel="stylesheet" href="assets/css/main.css" />
    <link rel="stylesheet" href="assets/css/loanBook.css" />
    <link rel="stylesheet" href="assets/css/sweetalert2-theme-bootstrap-4/bootstrap-4.min.css">

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
<div>
    <header>
        <h1>ISBN Scanner</h1>
       
    </header>
    <p id="detected-isbn">Detected ISBN: <span id="isbn-output">None</span></p>

    <div id="scanner-container">
        <video id="video" autoplay playsinline></video>
    </div>
</div>
                <!--Body Content-->
                <div class="form-container">
                    <form action="#">

                            <div class="form-field">
                                <label for="end-date">Return Date:</label>
                                <input type="date" id="end-date" name="end-date">
                            </div>
                            <div class="form-submit">
                                <button type="submit" id="send-button" onclick="loanBook(event)" disabled>Loan</button>
                            
                            </div>
                            <div class="form-submit">
                         
                                <button type="button" style="background-color: gray;margin-top: 10px;" onclick="window.location.href = 'LoanList.apsx'">Cancel</button>
                            </div>
                        

                    </form>
                </div>

</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ScriptContent" runat="server">
        <script src="assets/js/jquery.min.js"></script>
    <script src="assets/js/jquery.dropotron.min.js"></script>
    <script src="assets/js/jquery.scrolly.min.js"></script>
    <script src="assets/js/jquery.scrollex.min.js"></script>
    <script src="assets/js/browser.min.js"></script>
    <script src="assets/js/breakpoints.min.js"></script>
    <script src="assets/js/util.js"></script>
    <script src="assets/js/main.js"></script>
    <script src="assets/js/sweetalert2/sweetalert2.min.js"></script>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/quagga/0.12.1/quagga.min.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script type="text/javascript">

        let detectedISBN = "";

        // Get today's date in YYYY-MM-DD format
        const today = new Date().toISOString().split("T")[0];
        // Set the 'min' attribute of the input
        document.getElementById("end-date").setAttribute("min", today);

        // Initialize QuaggaJS to scan ISBN
        Quagga.init({
            inputStream: {
                name: "Live",
                type: "LiveStream",
                target: document.querySelector('#scanner-container'),
                constraints: {
                    facingMode: "environment",
                    width: 640,
                    height: 480
                }
            },
            decoder: {
                readers: ["ean_reader"] // EAN reader for ISBN barcodes
            }
        }, function (err) {
            if (err) {
                console.error("QuaggaJS initialization error:", err);
                
                return;
            }
            Quagga.start();
        });

        // Detect ISBN using QuaggaJS
        Quagga.onDetected(function (data) {
            detectedISBN = data.codeResult.code;
            document.getElementById('isbn-output').innerText = detectedISBN;
            document.getElementById('send-button').disabled = false;
            console.log("Detected ISBN:", detectedISBN);
        });



 


        function loanBook(event) {
            event.preventDefault();

            // Set the start date to today
            const today = new Date();
            const startDate = today.toISOString().split('T')[0]; // Format as YYYY-MM-DD
            const start = new Date(startDate);

            const endDate = document.getElementById("end-date").value;

            if (!endDate) {
                Swal.fire({
                    icon: 'warning',
                    title: 'Missing Dates',
                    text: 'Please select a date to return.',
                });
                return;
            }

            const end = new Date(endDate);

            if (end < start) {
                Swal.fire({
                    icon: 'error',
                    title: 'Invalid Date Range',
                    text: 'The return date cannot be earlier than today.',
                });
                return;
            }

            const diffInDays = (end - start) / (1000 * 60 * 60 * 24); // Convert milliseconds to days
            if (diffInDays > 7) {
                Swal.fire({
                    icon: 'error',
                    title: 'Invalid Date Range',
                    text: 'The date range cannot more than 7 days.',
                });
                return;
            }


            // AJAX to check trust level
            $.ajax({
                url: 'LoanBook.aspx/checkTrustLevel',
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d === "SUCCESS") {
                        $.ajax({
                            url: 'LoanBook.aspx/InsertLoan',
                            type: 'POST',
                            data: JSON.stringify({ EndDate: endDate, ISBN: detectedISBN }),
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: function (response) {
                                if (response.d === "SUCCESS") {
                                    Swal.fire({
                                        icon: 'success',
                                        title: 'Added to your loan',
                                        text: 'Now you can have the book',
                                        confirmButtonText: 'OK'
                                    }).then((result) => {
                                        if (result.isConfirmed) {
                                            window.location.href = "LoanList.aspx";
                                        }
                                    });
                                } else {
                                    Swal.fire({
                                        icon: 'error',
                                        title: 'Loan Failed',
                                        text: response.d,
                                        confirmButtonText: 'OK'
                                    });
                                }
                            }
                        });
                    } else {
                        Swal.fire({
                            icon: 'error',
                            title: 'Loan Failed',
                            text: response.d,
                            confirmButtonText: 'OK'
                        });
                    }
                }
            });
        }


    </script>
</asp:Content>
