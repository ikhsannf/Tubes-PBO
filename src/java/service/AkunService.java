package service;

import config.JDBC;
import model.Akun;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AkunService {

    // RESULT CODE
    public static final int REGISTER_SUCCESS = 1;
    public static final int REGISTER_DUPLICATE = 2;
    public static final int REGISTER_INVALID_USERNAME = 3;
    public static final int REGISTER_INVALID_PASSWORD = 4;
    public static final int REGISTER_FAILED = 0;

    // =======================
    // LOGIN (bcrypt)
    // =======================
    public Akun login(String username, String password) {
        JDBC db = new JDBC();
        Akun user = null;

        try {
            db.connect();
            Connection con = db.getConnection();

            // Hanya cari username, password dicek nanti
            PreparedStatement pst = con.prepareStatement(
                "SELECT * FROM akun WHERE username = ? LIMIT 1"
            );
            pst.setString(1, username);

            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                String hashPasswordDB = rs.getString("password");

                // Cek kesesuaian password input vs hash di DB
                if (hashPasswordDB != null && BCrypt.checkpw(password, hashPasswordDB)) {
                    user = new Akun();
                    user.setIdAkun(rs.getInt("idAkun"));
                    user.setUsername(rs.getString("username"));
                    user.setPassword(rs.getString("password")); // simpan hash
                    user.setRole(rs.getString("role"));
                    user.setEmail(rs.getString("email"));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return user;
    }

    // =======================
    // REGISTER (email + username unique + bcrypt)
    // =======================
    public int register(String email, String username, String passwordPlain) {

        // validasi username (tidak boleh spasi)
        if (username == null || username.trim().isEmpty() || username.contains(" ")) {
            return REGISTER_INVALID_USERNAME;
        }

        // validasi password (minimal 8 karakter)
        if (passwordPlain == null || passwordPlain.length() < 8) {
            return REGISTER_INVALID_PASSWORD;
        }

        // validasi email sederhana
        if (email == null || email.trim().isEmpty()) {
            return REGISTER_FAILED;
        }

        JDBC db = new JDBC();

        try {
            db.connect();
            Connection con = db.getConnection();

            // cek duplikat username/email
            String checkSql = "SELECT idAkun FROM akun WHERE username=? OR email=? LIMIT 1";
            PreparedStatement check = con.prepareStatement(checkSql);
            check.setString(1, username);
            check.setString(2, email);

            ResultSet rs = check.executeQuery();
            if (rs.next()) {
                return REGISTER_DUPLICATE;
            }

            // hash password
            String hashed = BCrypt.hashpw(passwordPlain, BCrypt.gensalt());

            // insert user
            String sql = "INSERT INTO akun(username, email, password, role) VALUES(?,?,?, 'pengguna')";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setString(1, username);
            pst.setString(2, email);
            pst.setString(3, hashed);

            int rows = pst.executeUpdate();
            return rows > 0 ? REGISTER_SUCCESS : REGISTER_FAILED;

        } catch (Exception e) {
            e.printStackTrace();
            return REGISTER_FAILED;
        }
    }

    // =======================
    // ADMIN SEEDER
    // =======================
    public boolean seedAdminIfNotExists(String username, String email, String passwordPlain) {
        JDBC db = new JDBC();

        try {
            db.connect();
            Connection con = db.getConnection();

            // cek apakah admin sudah ada
            String checkSql = "SELECT idAkun FROM akun WHERE username = ?";
            PreparedStatement check = con.prepareStatement(checkSql);
            check.setString(1, username);
            ResultSet rs = check.executeQuery();

            if (rs.next()) {
                return false; // admin sudah ada
            }

            // hash password
            String hashed = BCrypt.hashpw(passwordPlain, BCrypt.gensalt());

            String sql = "INSERT INTO akun(username, email, password, role) VALUES (?, ?, ?, 'admin')";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setString(1, username);
            pst.setString(2, email);
            pst.setString(3, hashed);

            return pst.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public void setupAdminBaru() {
        this.seedAdminIfNotExists("admin123", "admin123@mov.com", "bayaradmin");
    }

    // =======================
    // METODE LAMA YANG DIPERTAHANKAN
    // =======================
    public List<Akun> getAll() {
        List<Akun> list = new ArrayList<>();
        JDBC db = new JDBC();

        try {
            db.connect();
            Connection con = db.getConnection();

            PreparedStatement pst = con.prepareStatement("SELECT * FROM akun");
            ResultSet rs = pst.executeQuery();

            while (rs.next()) {
                Akun a = new Akun();
                a.setIdAkun(rs.getInt("idAkun"));
                a.setUsername(rs.getString("username"));
                a.setPassword(rs.getString("password"));
                a.setRole(rs.getString("role"));
                a.setEmail(rs.getString("email"));
                list.add(a);
            }

        } catch (Exception e) { e.printStackTrace(); }

        return list;
    }

    public boolean updateUsername(int idAkun, String newUsername) {
        JDBC db = new JDBC();
        try {
            db.connect();
            Connection con = db.getConnection();

            String sql = "UPDATE akun SET username=? WHERE idAkun=?";
            PreparedStatement pst = con.prepareStatement(sql);
            
            pst.setString(1, newUsername);
            pst.setInt(2, idAkun);

            return pst.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            db.disconnect();
        }
    }
}