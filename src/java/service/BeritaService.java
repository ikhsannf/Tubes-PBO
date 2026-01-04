package service;

import config.JDBC;
import model.Berita;
import model.ManajemenKonten;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BeritaService implements ManajemenKonten<Berita> {

    @Override
    public List<Berita> getAll() {
        List<Berita> list = new ArrayList<>();
        JDBC db = new JDBC();

        try {
            db.connect();
            Connection con = db.getConnection();

            PreparedStatement pst = con.prepareStatement("SELECT * FROM berita");
            ResultSet rs = pst.executeQuery();

            while (rs.next()) {
                list.add(new Berita(
                        rs.getInt("idBerita"),
                        rs.getString("judul"),
                        rs.getString("isi"),
                        rs.getDate("tanggal"),
                        rs.getString("penulis"),
                        rs.getInt("idAdmin"),
                        rs.getString("gambar") 
                ));
            }

        } catch (Exception e) { e.printStackTrace(); }

        return list;
    }

    @Override
    public Berita getById(int id) {
        JDBC db = new JDBC();
        Berita b = null;

        try {
            db.connect();
            Connection con = db.getConnection();

            PreparedStatement pst = con.prepareStatement("SELECT * FROM berita WHERE idBerita=?");
            pst.setInt(1, id);
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                b = new Berita(
                        rs.getInt("idBerita"),
                        rs.getString("judul"),
                        rs.getString("isi"),
                        rs.getDate("tanggal"),
                        rs.getString("penulis"),
                        rs.getInt("idAdmin"),
                        rs.getString("gambar")
                );
            }

        } catch (Exception e) { e.printStackTrace(); }

        return b;
    }

    @Override
    public boolean insert(Berita b) {
        JDBC db = new JDBC();

        try {
            db.connect();
            Connection con = db.getConnection();

            PreparedStatement pst = con.prepareStatement(
                    "INSERT INTO berita(judul, isi, tanggal, penulis, idAdmin, gambar) VALUES (?,?,?,?,?,?)"
            );

            pst.setString(1, b.getJudul());
            pst.setString(2, b.getIsi());
            pst.setDate(3, new java.sql.Date(b.getTanggal().getTime()));
            pst.setString(4, b.getPenulis());
            pst.setInt(5, b.getIdAdmin());
            pst.setString(6, b.getGambarUrl());

            return pst.executeUpdate() > 0;

        } catch (Exception e) { e.printStackTrace(); }

        return false;
    }

    @Override
    public boolean update(Berita b) {
        JDBC db = new JDBC();

        try {
            db.connect();
            Connection con = db.getConnection();

            PreparedStatement pst = con.prepareStatement(
                    "UPDATE berita SET judul=?, isi=?, tanggal=?, penulis=?, idAdmin=?, gambar=? WHERE idBerita=?"
            );

            pst.setString(1, b.getJudul());
            pst.setString(2, b.getIsi());
            pst.setDate(3, new java.sql.Date(b.getTanggal().getTime()));
            pst.setString(4, b.getPenulis());
            pst.setInt(5, b.getIdAdmin());
            pst.setString(6, b.getGambarUrl()); 
            pst.setInt(7, b.getIdBerita());

            return pst.executeUpdate() > 0;

        } catch (Exception e) { e.printStackTrace(); }

        return false;
    }

    @Override
    public boolean delete(int id) {
        JDBC db = new JDBC();

        try {
            db.connect();
            Connection con = db.getConnection();

            PreparedStatement pst = con.prepareStatement("DELETE FROM berita WHERE idBerita=?");
            pst.setInt(1, id);

            return pst.executeUpdate() > 0;

        } catch (Exception e) { e.printStackTrace(); }

        return false;
    }
    
public List<Berita> getByPage(int page, int limit) {
        List<Berita> list = new ArrayList<>();
        JDBC db = new JDBC();
        
        // Rumus Offset: Data ke berapa kita mulai mengambil
        // Contoh: Page 2, Limit 5 -> (2-1) * 5 = 5 (Mulai ambil dari data ke-6)
        int offset = (page - 1) * limit;

        try {
            db.connect();
            Connection con = db.getConnection();

            // SQL menggunakan LIMIT (jumlah data) dan OFFSET (mulai dari mana)
            String sql = "SELECT * FROM berita ORDER BY idBerita ASC LIMIT ? OFFSET ?";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setInt(1, limit);
            pst.setInt(2, offset);
            
            ResultSet rs = pst.executeQuery();

            while (rs.next()) {
                list.add(new Berita(
                        rs.getInt("idBerita"),
                        rs.getString("judul"),
                        rs.getString("isi"),
                        rs.getDate("tanggal"),
                        rs.getString("penulis"),
                        rs.getInt("idAdmin"),
                        rs.getString("gambar")
                ));
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        } finally {
            db.disconnect();
        }

        return list;
    }

    /**
     * Menghitung total seluruh baris di tabel berita
     */
    public int getTotalCount() {
        JDBC db = new JDBC();
        int count = 0;
        try {
            db.connect();
            String sql = "SELECT COUNT(*) FROM berita";
            Statement stmt = db.getConnection().createStatement();
            ResultSet rs = stmt.executeQuery(sql);
            
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        } finally {
            db.disconnect();
        }
        return count;
    }
}
