package service;

import config.JDBC;
import model.Film;
import model.ManajemenKonten;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FilmService implements ManajemenKonten<Film> {

    @Override
    public List<Film> getAll() {
        List<Film> list = new ArrayList<>();
        JDBC db = new JDBC();

        try {
            db.connect();
            Connection con = db.getConnection();

            PreparedStatement pst = con.prepareStatement("SELECT f.idFilm, f.judul, f.deskripsi, f.tahun_rilis, f.posterUrl, f.genre_id, g.namaGenre" +
" FROM film f" +
" LEFT JOIN genre g ON f.genre_id = g.idGenre;");
            ResultSet rs = pst.executeQuery();

            while (rs.next()) {
                list.add(new Film(
                    rs.getInt("idFilm"),
                    rs.getString("judul"),
                    rs.getString("deskripsi"),
                    rs.getInt("tahun_rilis"),
                    rs.getString("posterUrl"),
                    rs.getString("namaGenre"),
                    rs.getInt("genre_id")
                ));
            }

        } catch (Exception e) { e.printStackTrace(); }

        return list;
    }


    @Override
    public Film getById(int id) {
        JDBC db = new JDBC();
        Film f = null;

        try {
            db.connect();
            Connection con = db.getConnection();

            PreparedStatement pst = con.prepareStatement(
                "SELECT f.idFilm, f.judul, f.deskripsi, f.tahun_rilis, f.posterUrl, f.genre_id, g.namaGenre " +
                     " FROM film f" +
                     " LEFT JOIN genre g ON f.genre_id = g.idGenre" +
                     " WHERE f.idFilm = ?"
            );
            pst.setInt(1, id);

            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                f = new Film(
                    rs.getInt("idFilm"),
                    rs.getString("judul"),
                    rs.getString("deskripsi"),
                    rs.getInt("tahun_rilis"),
                    rs.getString("posterUrl"),
                    rs.getString("namaGenre"),
                    rs.getInt("genre_id")
                );
            }

        } catch (Exception e) { e.printStackTrace(); }

        return f;
    }


    @Override
    public boolean insert(Film f) {
        JDBC db = new JDBC();
        try {
            db.connect();
            Connection con = db.getConnection();

            PreparedStatement pst = con.prepareStatement(
                "INSERT INTO film(judul, deskripsi, tahun_rilis, posterUrl, genre_id) VALUES(?,?,?,?,?)"
            );

            pst.setString(1, f.getJudul());
            pst.setString(2, f.getDeskripsi());
            pst.setInt(3, f.getTahunRilis());
            pst.setString(4, f.getPosterUrl());
            pst.setInt(5, f.getGenreId());

            return pst.executeUpdate() > 0;

        } catch (Exception e) { e.printStackTrace(); }

        return false;
    }


    @Override
    public boolean update(Film f) {
        JDBC db = new JDBC();
        try {
            db.connect();
            Connection con = db.getConnection();

            PreparedStatement pst = con.prepareStatement(
                "UPDATE film SET judul=?, deskripsi=?, tahun_rilis=?, posterUrl=?, genre_id=? WHERE idFilm=?"
            );

            pst.setString(1, f.getJudul());
            pst.setString(2, f.getDeskripsi());
            pst.setInt(3, f.getTahunRilis());
            pst.setString(4, f.getPosterUrl());
            pst.setInt(5, f.getGenreId());
            pst.setInt(6, f.getIdFilm());

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

            PreparedStatement pst = con.prepareStatement(
                "DELETE FROM film WHERE idFilm=?"
            );

            pst.setInt(1, id);

            return pst.executeUpdate() > 0;

        } catch (Exception e) { e.printStackTrace(); }

        return false;
    }
}
