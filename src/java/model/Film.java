package model;

public class Film {
    private int idFilm;
    private String judul;
    private String deskripsi;
    private Integer tahunRilis;
    private String posterUrl;
    private String namaGenre;
    private int genreId;
    private double rating;
    private String castFilm;

    

    public Film() {}

    public Film(int idFilm, String judul, String deskripsi, Integer tahunRilis, String posterUrl, String namaGenre, int genreId) {
        this.idFilm = idFilm;
        this.judul = judul;
        this.deskripsi = deskripsi;
        this.tahunRilis = tahunRilis;
        this.posterUrl = posterUrl;
        this.namaGenre = namaGenre;
        this.genreId = genreId;
    }
    public int getGenreId() {
        return genreId;
    }

    public void setGenreId(int genreId) {
        this.genreId = genreId;
    }
    public String getNamaGenre() {
        return namaGenre;
    }

    public void setNamaGenre(String namaGenre) {
        this.namaGenre = namaGenre;
    }
    public int getIdFilm() {
        return idFilm;
    }

    public void setIdFilm(int idFilm) {
        this.idFilm = idFilm;
    }

    public String getJudul() {
        return judul;
    }

    public void setJudul(String judul) {
        this.judul = judul;
    }

    public String getDeskripsi() {
        return deskripsi;
    }

    public void setDeskripsi(String deskripsi) {
        this.deskripsi = deskripsi;
    }

    public Integer getTahunRilis() {
        return tahunRilis;
    }

    public void setTahunRilis(Integer tahunRilis) {
        this.tahunRilis = tahunRilis;
    }

    public String getPosterUrl() {
        return posterUrl;
    }

    public void setPosterUrl(String posterUrl) {
        this.posterUrl = posterUrl;
    }
    
    public double getRating() {
        return rating;
    }

    public void setRating(double rating) {
        this.rating = rating;
    }
    
    public String getGenre() {
        return this.namaGenre; // Mengembalikan nilai dari namaGenre yang sudah ada
    }

    public void setGenre(String genre) {
        this.namaGenre = genre; // Menyimpan ke variable namaGenre yang sudah ada
    }
    
    public String getCastFilm() {
        // Kalau null (kosong), kita kembalikan strip (-) biar tidak error di layar
        if (castFilm == null) {
            return "-";
        }
        return castFilm;
    }
    
    public void setCastFilm(String castFilm) {
        this.castFilm = castFilm;
    }
}
