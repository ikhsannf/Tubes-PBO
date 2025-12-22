package service;

import config.JDBC;
import model.Genre;
import model.ManajemenKonten;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class GenreService implements ManajemenKonten<Genre> {

    @Override
    public List<Genre> getAll() {
        List<Genre> list = new ArrayList<>();
        JDBC db = new JDBC();

        try {
            db.connect();
            Connection con = db.getConnection();
            PreparedStatement pst = con.prepareStatement("SELECT * FROM genre");
            ResultSet rs = pst.executeQuery();

            while (rs.next()) {
                list.add(new Genre(
                        rs.getInt("idGenre"),
                        rs.getString("namaGenre")
                ));
            }

        } catch (Exception e) { e.printStackTrace(); }

        return list;
    }

    @Override
    public Genre getById(int id) {
        JDBC db = new JDBC();
        Genre g = null;

        try {
            db.connect();
            Connection con = db.getConnection();
            PreparedStatement pst = con.prepareStatement("SELECT * FROM genre WHERE idGenre=?");
            pst.setInt(1, id);
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                g = new Genre(
                        rs.getInt("idGenre"),
                        rs.getString("namaGenre")
                );
            }

        } catch (Exception e) { e.printStackTrace(); }

        return g;
    }

    @Override
    public boolean insert(Genre g) {
        JDBC db = new JDBC();

        try {
            db.connect();
            Connection con = db.getConnection();
            PreparedStatement pst = con.prepareStatement(
                    "INSERT INTO genre(namaGenre) VALUES(?)"
            );

            pst.setString(1, g.getNamaGenre());
            return pst.executeUpdate() > 0;

        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    @Override
    public boolean update(Genre g) {
        JDBC db = new JDBC();

        try {
            db.connect();
            Connection con = db.getConnection();
            PreparedStatement pst = con.prepareStatement(
                    "UPDATE genre SET namaGenre=? WHERE idGenre=?"
            );

            pst.setString(1, g.getNamaGenre());
            pst.setInt(2, g.getIdGenre());

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
            PreparedStatement pst = con.prepareStatement("DELETE FROM genre WHERE idGenre=?");
            pst.setInt(1, id);

            return pst.executeUpdate() > 0;

        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }
}
