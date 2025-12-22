package service;

import config.JDBC;
import model.Akun;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AkunService {

    public Akun login(String username, String password) {
        JDBC db = new JDBC();
        Akun user = null;

        try {
            db.connect();
            Connection con = db.getConnection();

            PreparedStatement pst = con.prepareStatement(
                "SELECT * FROM akun WHERE username=? AND password=?"
            );

            pst.setString(1, username);
            pst.setString(2, password);

            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                user = new Akun(
                    rs.getInt("idAkun"),
                    rs.getString("username"),
                    rs.getString("password"),
                    rs.getString("role")
                );
            }

        } catch (Exception e) { e.printStackTrace(); }

        return user;
    }


    public boolean register(Akun a) {
        JDBC db = new JDBC();

        try {
            db.connect();
            Connection con = db.getConnection();

            PreparedStatement pst = con.prepareStatement(
                "INSERT INTO akun(username, password, role) VALUES(?,?,'pengguna')"
            );

            pst.setString(1, a.getUsername());
            pst.setString(2, a.getPassword());
            

            return pst.executeUpdate() > 0;

        } catch (Exception e) { e.printStackTrace(); }

        return false;
    }


    public List<Akun> getAll() {
        List<Akun> list = new ArrayList<>();
        JDBC db = new JDBC();

        try {
            db.connect();
            Connection con = db.getConnection();

            PreparedStatement pst = con.prepareStatement("SELECT * FROM akun");
            ResultSet rs = pst.executeQuery();

            while (rs.next()) {
                list.add(new Akun(
                    rs.getInt("idAkun"),
                    rs.getString("username"),
                    rs.getString("password"),
                    rs.getString("role")
                ));
            }

        } catch (Exception e) { e.printStackTrace(); }

        return list;
    }
}
