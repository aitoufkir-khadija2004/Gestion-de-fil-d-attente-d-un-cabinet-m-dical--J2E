<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8" />
        <title>Tests JDBC</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 20px;
                line-height: 1.6;
            }
            h1 {
                color: #333;
                border-bottom: 2px solid #333;
                padding-bottom: 10px;
            }
            p {
                margin: 10px 0;
                padding: 5px;
                background-color: #f9f9f9;
                border-left: 3px solid #ccc;
            }
        </style>
    </head>
    <body>
        <h1>Tests JDBC</h1>

        <%
            // Récupérer la liste des messages
            List<String> notifications = (List<String>) request.getAttribute("notifications");
            
            // Vérifier si la liste existe et n'est pas vide
            if (notifications != null && !notifications.isEmpty()) {
                int count = 0;
                for (String message : notifications) {
                    count++;
        %>
                    <p><%= count %>. <%= message %></p>
        <%
                }
            } else {
        %>
                <p>Aucun message à afficher.</p>
        <%
            }
        %>
    </body>
</html>