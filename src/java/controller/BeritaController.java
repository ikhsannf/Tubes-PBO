package controller;

import model.Berita;
import service.BeritaService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/berita")
public class BeritaController extends HttpServlet {

    private BeritaService service = new BeritaService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null) action = "index";

        switch (action) {

            case "add":
                req.getRequestDispatcher("admin/berita/add.jsp").forward(req, resp);
                break;

            case "edit":
                int id = Integer.parseInt(req.getParameter("id"));
                Berita berita = service.getById(id);
                req.setAttribute("berita", berita);
                req.getRequestDispatcher("admin/berita/edit.jsp").forward(req, resp);
                break;

            default:
                List<Berita> list = service.getAll();
                req.setAttribute("list", list);
                req.getRequestDispatcher("admin/berita/index.jsp").forward(req, resp);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if ("insert".equals(action)) {
            Berita b = new Berita();
            b.setJudul(req.getParameter("judul"));
            b.setIsi(req.getParameter("isi"));
            b.setTanggal(java.sql.Date.valueOf(req.getParameter("tanggal")));
            b.setPenulis(req.getParameter("penulis"));
            b.setIdAdmin(Integer.parseInt(req.getParameter("adminId")));

            service.insert(b);
            resp.sendRedirect("berita");

        } else if ("update".equals(action)) {
            Berita b = new Berita();
            b.setIdBerita(Integer.parseInt(req.getParameter("id")));
            b.setJudul(req.getParameter("judul"));
            b.setIsi(req.getParameter("isi"));
           b.setTanggal(java.sql.Date.valueOf(req.getParameter("tanggal")));
            b.setPenulis(req.getParameter("penulis"));

            service.update(b);
            resp.sendRedirect("berita");

        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            service.delete(id);
            resp.sendRedirect("berita");
        }
    }
}
