package service;

import config.JDBC;
import model.Film;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FilmService {

    // --- FUNGSI BARU: GET BY PAGE (PAGINATION) ---
    public List<Film> getByPage(int page, int limit) {
        List<Film> list = new ArrayList<>();
        JDBC db = new JDBC();
        
        // Rumus Offset: (Halaman - 1) * Limit
        int offset = (page - 1) * limit;

        try {
            db.connect();
            Connection con = db.getConnection();

            // SQL JOIN Genre dengan urutan ASC dan LIMIT OFFSET
            String sql = "SELECT f.*, g.namaGenre FROM film f " +
                         "LEFT JOIN genre g ON f.genre_id = g.idGenre " +
                         "ORDER BY f.idFilm ASC LIMIT ? OFFSET ?";
            
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setInt(1, limit);
            pst.setInt(2, offset);
            
            ResultSet rs = pst.executeQuery();

            while (rs.next()) {
                Film f = new Film();
                f.setIdFilm(rs.getInt("idFilm"));
                f.setJudul(rs.getString("judul"));
                f.setDeskripsi(rs.getString("deskripsi"));
                f.setTahunRilis(rs.getInt("tahun_rilis"));
                f.setPosterUrl(rs.getString("posterUrl"));
                f.setGenreId(rs.getInt("genre_id"));
                f.setNamaGenre(rs.getString("namaGenre"));
                f.setRating(rs.getDouble("rating"));
                f.setCastFilm(rs.getString("cast_film"));
                list.add(f);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            db.disconnect();
        }
        return list;
    }

    // --- FUNGSI BARU: HITUNG TOTAL DATA ---
    public int getTotalCount() {
        JDBC db = new JDBC();
        int count = 0;
        try {
            db.connect();
            String sql = "SELECT COUNT(*) FROM film";
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

    // --- FUNGSI CRUD LAMA TETAP DIPERTAHANKAN ---

    public List<Film> getAll() {
        List<Film> list = new ArrayList<>();
        JDBC db = new JDBC();
        try {
            db.connect();
            Connection con = db.getConnection();
            String sql = "SELECT f.*, g.namaGenre FROM film f LEFT JOIN genre g ON f.genre_id = g.idGenre ORDER BY f.idFilm ASC";
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) {
                Film f = new Film();
                f.setIdFilm(rs.getInt("idFilm"));
                f.setJudul(rs.getString("judul"));
                f.setDeskripsi(rs.getString("deskripsi"));
                f.setTahunRilis(rs.getInt("tahun_rilis"));
                f.setPosterUrl(rs.getString("posterUrl"));
                f.setGenreId(rs.getInt("genre_id"));
                f.setNamaGenre(rs.getString("namaGenre"));
                f.setRating(rs.getDouble("rating"));
                f.setCastFilm(rs.getString("cast_film"));
                list.add(f);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public Film getById(int id) {
        JDBC db = new JDBC();
        Film f = null;
        try {
            db.connect();
            Connection con = db.getConnection();
            String sql = "SELECT f.*, g.namaGenre FROM film f LEFT JOIN genre g ON f.genre_id = g.idGenre WHERE f.idFilm=?";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setInt(1, id);
            ResultSet rs = pst.executeQuery();
            if(rs.next()){
                f = new Film();
                f.setIdFilm(rs.getInt("idFilm"));
                f.setJudul(rs.getString("judul"));
                f.setDeskripsi(rs.getString("deskripsi"));
                f.setTahunRilis(rs.getInt("tahun_rilis"));
                f.setPosterUrl(rs.getString("posterUrl"));
                f.setGenreId(rs.getInt("genre_id")); 
                f.setNamaGenre(rs.getString("namaGenre"));
                f.setRating(rs.getDouble("rating"));
                f.setCastFilm(rs.getString("cast_film"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return f;
    }

    public boolean insertFilm(Film f) {
        JDBC db = new JDBC();
        try {
            db.connect();
            Connection con = db.getConnection();
            String sql = "INSERT INTO film (judul, deskripsi, tahun_rilis, posterUrl, genre_id, rating, cast_film) VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setString(1, f.getJudul());
            pst.setString(2, f.getDeskripsi());
            pst.setInt(3, f.getTahunRilis());
            pst.setString(4, f.getPosterUrl());
            pst.setInt(5, f.getGenreId());
            pst.setDouble(6, f.getRating());
            pst.setString(7, f.getCastFilm());
            return pst.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean updateFilm(Film f) {
        JDBC db = new JDBC();
        try {
            db.connect();
            Connection con = db.getConnection();
            String sql = "UPDATE film SET judul=?, deskripsi=?, tahun_rilis=?, posterUrl=?, genre_id=?, rating=?, cast_film=? WHERE idFilm=?";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setString(1, f.getJudul());
            pst.setString(2, f.getDeskripsi());
            pst.setInt(3, f.getTahunRilis());
            pst.setString(4, f.getPosterUrl());
            pst.setInt(5, f.getGenreId());
            pst.setDouble(6, f.getRating());
            pst.setString(7, f.getCastFilm());
            pst.setInt(8, f.getIdFilm());
            return pst.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean deleteFilm(int idFilm) {
        JDBC db = new JDBC();
        try {
            db.connect();
            Connection con = db.getConnection();
            // Hapus favorite dulu
            String sqlFav = "DELETE FROM favorite WHERE idFilm=?";
            PreparedStatement pstFav = con.prepareStatement(sqlFav);
            pstFav.setInt(1, idFilm);
            pstFav.executeUpdate();

            String sql = "DELETE FROM film WHERE idFilm=?";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setInt(1, idFilm);
            return pst.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }
}