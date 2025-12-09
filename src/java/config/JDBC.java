package config;

import java.sql.*;

public class JDBC {

    private Connection con;
    private Statement stmt;
    private boolean isConnected;
    private String message;

    public String getMessage() {
        return this.message;
    }

    public void connect() {
        String dbname = "mov_info";
        String username = "root";
        String password = "";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3307/" + dbname + "?useSSL=false&serverTimezone=UTC",
                username,
                password
            );

            stmt = con.createStatement();
            isConnected = true;
            message = "DB connected (Success)";

        } catch (Exception e) {
            isConnected = false;
            message = "Connection Failed: " + e.getMessage();
        }
    }

    private void disconnect() {
        try {
            if (stmt != null) stmt.close();
            if (con != null) con.close();
        } catch (Exception e) {
            message = e.getMessage();
        }
    }

    public void runQuery(String query) {
        try {
            connect();

            int result = stmt.executeUpdate(query);
            message = "Info: " + result + " rows affected";

        } catch (Exception e) {
            message = e.getMessage();
        } finally {
            disconnect();
        }
    }

    public Connection getConnection() {
        return this.con;
    }

    public Statement getStatement() {
        return this.stmt;
    }
}
