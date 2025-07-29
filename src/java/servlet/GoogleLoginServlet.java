/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package servlet;

import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.json.Json;
import jakarta.json.JsonObject;
import jakarta.json.JsonReader;
import java.net.HttpURLConnection;
import java.net.URL;

/**
 *
 * @author melisda
 */
@WebServlet(name = "GoogleLoginServlet", urlPatterns = {"/GoogleLoginServlet"})
public class GoogleLoginServlet extends HttpServlet {

    private static final String CLIENT_ID = "789019571145-eqlv9vtvmvc0cmtarsi4v1pc02u0nrbu.apps.googleusercontent.com";
    private static final String CLIENT_SECRET = "****_vCW"; // Simpan di env/config sebaiknya
    private static final String REDIRECT_URI = "http://localhost:8080/WebApplication3/GoogleLoginServlet";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String code = request.getParameter("code");

        if (code != null) {
            try {
                // Step 1: Exchange code for access token
                String tokenEndpoint = "https://oauth2.googleapis.com/token";
                String urlParameters = "code=" + code +
                        "&client_id=" + CLIENT_ID +
                        "&client_secret=" + CLIENT_SECRET +
                        "&redirect_uri=" + REDIRECT_URI +
                        "&grant_type=authorization_code";

                URL url = new URL(tokenEndpoint);
                HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                conn.setRequestMethod("POST");
                conn.setDoOutput(true);
                conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");

                try (OutputStreamWriter writer = new OutputStreamWriter(conn.getOutputStream())) {
                    writer.write(urlParameters);
                    writer.flush();
                }

                // Step 2: Parse JSON response to get access token
                JsonObject jsonObject;
                try (JsonReader jsonReader = Json.createReader(new InputStreamReader(conn.getInputStream()))) {
                    jsonObject = jsonReader.readObject();
                }

                String accessToken = jsonObject.getString("access_token");

                // Step 3: Use access token to get user info
                URL userInfoUrl = new URL("https://www.googleapis.com/oauth2/v1/userinfo?access_token=" + accessToken);
                HttpURLConnection userInfoConn = (HttpURLConnection) userInfoUrl.openConnection();

                JsonObject userJson;
                try (JsonReader userReader = Json.createReader(new InputStreamReader(userInfoConn.getInputStream()))) {
                    userJson = userReader.readObject();
                }

                String email = userJson.getString("email");
                String name = userJson.getString("name"); // diperbaiki dari "nama" ke "name"

                // Simpan informasi user di session
                HttpSession session = request.getSession();
                session.setAttribute("email", email);
                session.setAttribute("name", name);

                response.sendRedirect("dashboard_admin.jsp");

            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("dashboard_admin.jsp");
            }
        } else {
            response.sendRedirect("login.jsp?error=google_login_failed");
        }
    }
}
