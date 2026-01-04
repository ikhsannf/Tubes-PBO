package controller;

import model.Akun;
import model.Berita;
import service.BeritaService;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;

@WebServlet("/berita")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class BeritaController extends HttpServlet {

    private BeritaService service = new BeritaService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // 1. Proteksi Session
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String action = req.getParameter("action");
        if (action == null) action = "index";

        switch (action) {
            case "edit":
                int id = Integer.parseInt(req.getParameter("id"));
                Berita berita = service.getById(id);
                
                // Simpan halaman saat ini agar setelah edit bisa balik ke halaman yang sama
                String currentPageAttr = req.getParameter("page");
                req.setAttribute("berita", berita);
                req.setAttribute("currentPage", currentPageAttr);
                
                req.getRequestDispatcher("admin/berita/edit.jsp").forward(req, resp);
                break;

            default: 
                // --- LOGIKA PAGINATION ---
                int page = 1;
                int limit = 5; // Menampilkan 5 berita per halaman
                
                if (req.getParameter("page") != null) {
                    try {
                        page = Integer.parseInt(req.getParameter("page"));
                    } catch (NumberFormatException e) {
                        page = 1;
                    }
                }

                List<Berita> list = service.getByPage(page, limit);
                int totalData = service.getTotalCount();
                int totalPages = (int) Math.ceil((double) totalData / limit);

                req.setAttribute("list", list);
                req.setAttribute("currentPage", page);
                req.setAttribute("totalPages", totalPages);
                
                req.getRequestDispatcher("admin/berita/index.jsp").forward(req, resp);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        HttpSession session = req.getSession();
        Akun akun = (Akun) session.getAttribute("user");
        
        // Tangkap info halaman saat ini dari form (jika ada)
        String pageParam = req.getParameter("page");
        if (pageParam == null || pageParam.isEmpty()) pageParam = "1";

        if (akun == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        // --- FILE UPLOAD LOGIC ---
        String fileName = "";
        Part filePart = req.getPart("gambar");
        
        if (filePart != null && filePart.getSize() > 0) {
            String originFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String extension = "";
            int dotIndex = originFileName.lastIndexOf(".");
            if (dotIndex >= 0) {
                 extension = originFileName.substring(dotIndex);
            }
            fileName = UUID.randomUUID().toString() + extension;
            
            String uploadPath = getServletContext().getRealPath("/") + "uploads" + File.separator + "berita";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();
            
            filePart.write(uploadPath + File.separator + fileName);
        }

        if ("insert".equals(action)) {
            Berita b = new Berita();
            b.setJudul(req.getParameter("judul"));
            b.setIsi(req.getParameter("isi"));
            b.setTanggal(java.sql.Date.valueOf(req.getParameter("tanggal")));
            b.setPenulis(req.getParameter("penulis"));
            b.setIdAdmin(akun.getIdAkun());
            b.setGambarUrl(fileName);

            service.insert(b);
            // Redirect ke halaman 1 karena berita terbaru muncul di awal
            resp.sendRedirect("berita?page=1");

        } else if ("update".equals(action)) {
            Berita b = new Berita();
            int id = Integer.parseInt(req.getParameter("id"));
            b.setIdBerita(id);
            b.setJudul(req.getParameter("judul"));
            b.setIsi(req.getParameter("isi"));
            b.setTanggal(java.sql.Date.valueOf(req.getParameter("tanggal")));
            b.setPenulis(req.getParameter("penulis"));
            b.setIdAdmin(akun.getIdAkun());

            if (fileName.isEmpty()) {
                Berita existing = service.getById(id);
                b.setGambarUrl(existing.getGambarUrl());
            } else {
                b.setGambarUrl(fileName);
            }

            service.update(b);
            // Kembali ke halaman tempat data tersebut berada
            resp.sendRedirect("berita?page=" + pageParam);

        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            service.delete(id);
            // Kembali ke halaman saat ini
            resp.sendRedirect("berita?page=" + pageParam);
        }
    }
}