<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
// Obtener los datos del formulario
String usuario = request.getParameter("usuario");
String clave = request.getParameter("clave");

// Variables para la conexión a la base de datos
Connection con = null;
PreparedStatement pst = null;
ResultSet rs = null;

try {
    // Cargar el driver de MySQL
    Class.forName("com.mysql.cj.jdbc.Driver");
    
    // Establecer conexión con la base de datos pharmapty
    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharmapty", "root", "");

    // Consulta SQL para verificar usuario por nombre de usuario o email
    String sql = "SELECT * FROM usuarios WHERE (nombre_usuario=? OR email=?) AND contraseña=?";
    pst = con.prepareStatement(sql);
    pst.setString(1, usuario);
    pst.setString(2, usuario); // Permite login con email o usuario
    pst.setString(3, clave);
    
    rs = pst.executeQuery();

    if (rs.next()) {
        // Usuario encontrado - obtener datos
        String nombreUsuario = rs.getString("nombre_usuario");
        String email = rs.getString("email");
        String rol = rs.getString("rol");
        int userId = rs.getInt("id");
        
        // Crear sesión para el usuario
        session.setAttribute("usuario", nombreUsuario);
        session.setAttribute("email", email);
        session.setAttribute("rol", rol);
        session.setAttribute("userId", userId);
        session.setAttribute("loggedIn", true);

        // Redirigir según el rol
        if (rol.equals("admin")) {
            response.sendRedirect("admin.jsp");
        } else if (rol.equals("cliente")) {
            response.sendRedirect("home.jsp");
        }
    } else {
        // Usuario no encontrado o contraseña incorrecta
%>
        <script>
            alert('Usuario o contraseña incorrectos');
            history.back();
        </script>
<%
    }
} catch (ClassNotFoundException e) {
%>
    <script>
        alert('Error: Driver de base de datos no encontrado');
        history.back();
    </script>
<%
} catch (SQLException e) {
%>
    <script>
        alert('Error de conexión a la base de datos: <%= e.getMessage() %>');
        history.back();
    </script>
<%
} catch (Exception e) {
%>
    <script>
        alert('Error inesperado: <%= e.getMessage() %>');
        history.back();
    </script>
<%
} finally {
    // Cerrar conexiones
    try {
        if (rs != null) rs.close();
        if (pst != null) pst.close();
        if (con != null) con.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
}
%>