package servlets;

import dao.DAOFactory;
import dao.UserDAO;
import beans.User;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        DAOFactory factory = DAOFactory.getInstance();
        userDAO = factory.getUserDAO();
    }
    
    public LoginServlet() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            redirectToDashboard(user, response, request);
            return;
        }
        
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        if (email == null || email.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Email et mot de passe requis");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        
        User user = userDAO.login(email.trim(), password);
        
        if (user != null && user.isActif()) {
            HttpSession session = request.getSession(true);
            session.setAttribute("user", user);
            session.setMaxInactiveInterval(30 * 60);
            
            redirectToDashboard(user, response, request);
        } else {
            request.setAttribute("error", "Email ou mot de passe incorrect");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
    
    private void redirectToDashboard(User user, HttpServletResponse response, 
                                     HttpServletRequest request) throws IOException {
        String contextPath = request.getContextPath();
        
        switch (user.getRole()) {
            case "PATIENT":
                response.sendRedirect(contextPath + "/patient/dashboard");
                break;
            case "MEDECIN":
                response.sendRedirect(contextPath + "/medecin/dashboard");
                break;
            case "SECRETAIRE":
                response.sendRedirect(contextPath + "/secretaire/dashboard");
                break;
            case "ADMIN":
                response.sendRedirect(contextPath + "/admin/dashboard");
                break;
            default:
                response.sendRedirect(contextPath + "/login");
        }
    }
}