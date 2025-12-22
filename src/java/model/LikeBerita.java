package model;

import java.sql.Timestamp;

public class LikeBerita {
    private int idLike;
    private int idAkun;
    private int idBerita;
    private Timestamp tanggalLike;

    public LikeBerita() {}

    public LikeBerita(int idLike, int idAkun, int idBerita, Timestamp tanggalLike) {
        this.idLike = idLike;
        this.idAkun = idAkun;
        this.idBerita = idBerita;
        this.tanggalLike = tanggalLike;
    }

    public int getIdLike() {
        return idLike;
    }

    public void setIdLike(int idLike) {
        this.idLike = idLike;
    }

    public int getIdAkun() {
        return idAkun;
    }

    public void setIdAkun(int idAkun) {
        this.idAkun = idAkun;
    }

    public int getIdBerita() {
        return idBerita;
    }

    public void setIdBerita(int idBerita) {
        this.idBerita = idBerita;
    }

    public Timestamp getTanggalLike() {
        return tanggalLike;
    }

    public void setTanggalLike(Timestamp tanggalLike) {
        this.tanggalLike = tanggalLike;
    }
}
