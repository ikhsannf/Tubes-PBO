package model;

import java.sql.Date;

public class Berita {
    private int idBerita;
    private String judul;
    private String isi;
    private Date tanggal;
    private String penulis;
    private int idAdmin;

    public Berita() {}

    public Berita(int idBerita, String judul, String isi, Date tanggal, String penulis, int idAdmin) {
        this.idBerita = idBerita;
        this.judul = judul;
        this.isi = isi;
        this.tanggal = tanggal;
        this.penulis = penulis;
        this.idAdmin = idAdmin;
    }

    public int getIdBerita() {
        return idBerita;
    }

    public void setIdBerita(int idBerita) {
        this.idBerita = idBerita;
    }

    public String getJudul() {
        return judul;
    }

    public void setJudul(String judul) {
        this.judul = judul;
    }

    public String getIsi() {
        return isi;
    }

    public void setIsi(String isi) {
        this.isi = isi;
    }

    public Date getTanggal() {
        return tanggal;
    }

    public void setTanggal(Date tanggal) {
        this.tanggal = tanggal;
    }

    public String getPenulis() {
        return penulis;
    }

    public void setPenulis(String penulis) {
        this.penulis = penulis;
    }

    public int getIdAdmin() {
        return idAdmin;
    }

    public void setIdAdmin(int idAdmin) {
        this.idAdmin = idAdmin;
    }
}
