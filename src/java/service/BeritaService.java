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
                        rs.getInt("idAdmin")
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
                        rs.getInt("idAdmin")
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
                    "INSERT INTO berita(judul, isi, tanggal, penulis, idAdmin) VALUES (?,?,?,?,?)"
            );

            pst.setString(1, b.getJudul());
            pst.setString(2, b.getIsi());
            pst.setDate(3, new java.sql.Date(b.getTanggal().getTime()));
            pst.setString(4, b.getPenulis());
            pst.setInt(5, b.getIdAdmin());

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
                    "UPDATE berita SET judul=?, isi=?, tanggal=?, penulis=?, idAdmin=? WHERE idBerita=?"
            );

            pst.setString(1, b.getJudul());
            pst.setString(2, b.getIsi());
            pst.setDate(3, new java.sql.Date(b.getTanggal().getTime()));
            pst.setString(4, b.getPenulis());
            pst.setInt(5, b.getIdAdmin());
            pst.setInt(6, b.getIdBerita());

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
}
